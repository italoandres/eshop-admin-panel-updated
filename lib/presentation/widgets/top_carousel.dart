import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/banner/banner.dart' as entity;

class TopCarousel extends StatefulWidget {
  final List<entity.Banner> banners;
  final double? height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;

  const TopCarousel({
    super.key,
    required this.banners,
    this.height,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<TopCarousel> createState() => _TopCarouselState();
}

class _TopCarouselState extends State<TopCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  Timer? _autoPlayTimer;
  Timer? _resumeTimer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && widget.banners.isNotEmpty) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _resumeTimer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (!_isUserInteracting && mounted) {
        final nextIndex = (_currentIndex + 1) % widget.banners.length;
        _carouselController.animateToPage(
          nextIndex,
          duration: widget.autoPlayAnimationDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _pauseAutoPlay() {
    _isUserInteracting = true;
    _autoPlayTimer?.cancel();
    _resumeTimer?.cancel();
  }

  void _scheduleResumeAutoPlay() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _isUserInteracting = false;
        if (widget.autoPlay) {
          _startAutoPlay();
        }
      }
    });
  }

  Future<void> _openUrl(String url) async {
    print('[TopCarousel] Opening URL: $url');
    
    // Log de telemetria para cliques
    print('[TopCarousel] Banner clicked - URL: $url, Index: $_currentIndex');
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('[TopCarousel] Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final carouselHeight = widget.height ?? screenHeight * 0.25;

    return Column(
      children: [
        GestureDetector(
          onPanDown: (_) => _pauseAutoPlay(),
          onPanEnd: (_) => _scheduleResumeAutoPlay(),
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: widget.banners.length,
            options: CarouselOptions(
              height: carouselHeight,
              viewportFraction: 0.92,
              enlargeCenterPage: true,
              autoPlay: false, // Controlado manualmente
              enableInfiniteScroll: widget.banners.length > 1,
              // Reduz a piscada com transição mais suave
              pageSnapping: true,
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
                
                // Se o usuário mudou manualmente, pausar e agendar retomada
                if (reason == CarouselPageChangedReason.manual) {
                  _pauseAutoPlay();
                  _scheduleResumeAutoPlay();
                }
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final banner = widget.banners[index];
              // RepaintBoundary reduz repaint e melhora performance
              return RepaintBoundary(
                child: _BannerItem(
                  banner: banner,
                  onTap: () => _openUrl(banner.targetUrl),
                ),
              );
            },
          ),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 12),
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: widget.banners.length,
            effect: ScrollingDotsEffect(
              dotColor: Colors.grey.shade300,
              activeDotColor: Theme.of(context).primaryColor,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
              maxVisibleDots: 7,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _BannerItem extends StatefulWidget {
  final entity.Banner banner;
  final VoidCallback onTap;

  const _BannerItem({
    required this.banner,
    required this.onTap,
  });

  @override
  State<_BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<_BannerItem> with AutomaticKeepAliveClientMixin {
  bool _imageLoaded = false;
  Uint8List? _cachedBytes; // Cache dos bytes decodificados
  
  @override
  bool get wantKeepAlive => true; // Mantém o widget vivo para evitar rebuild

  bool _isBase64Image(String imageUrl) {
    return imageUrl.startsWith('data:image/');
  }

  Widget _buildImage() {
    // Se for base64, usar Image.memory
    if (_isBase64Image(widget.banner.imageUrl)) {
      try {
        // Usar cache se já foi decodificado
        if (_cachedBytes == null) {
          // Remover o prefixo data:image/...;base64,
          final base64String = widget.banner.imageUrl.split(',').last;
          _cachedBytes = const Base64Decoder().convert(base64String);
        }
        
        final bytes = _cachedBytes!;
        
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          // Adiciona gaplessPlayback para evitar piscada
          gaplessPlayback: true,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              _imageLoaded = true;
              return child;
            }
            
            // Fade in suave quando a imagem carregar
            if (frame != null) {
              if (!_imageLoaded) {
                Future.microtask(() {
                  if (mounted) {
                    setState(() => _imageLoaded = true);
                  }
                });
              }
              return AnimatedOpacity(
                opacity: _imageLoaded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: child,
              );
            }
            
            // Placeholder enquanto carrega
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('[TopCarousel] Error loading base64 image: $error');
            return _buildErrorWidget();
          },
        );
      } catch (e) {
        print('[TopCarousel] Error decoding base64: $e');
        return _buildErrorWidget();
      }
    }
    
    // Se for URL, usar CachedNetworkImage
    return CachedNetworkImage(
      imageUrl: widget.banner.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        print('[TopCarousel] Error loading network image: $error');
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          Text(
            widget.banner.title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessário para AutomaticKeepAliveClientMixin
    
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildImage(),
        ),
      ),
    );
  }
}
