import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/banner_admin_provider.dart';

/// Widget de teste para criar banners
class BannerTestWidget extends ConsumerWidget {
  const BannerTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Banners'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(bannerAdminProvider.notifier).createBanner(
                        title: 'Banner de Teste ${DateTime.now().millisecond}',
                        imageUrl: 'https://via.placeholder.com/800x400',
                        targetUrl: 'https://example.com',
                        order: 1,
                        active: true,
                      );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Banner criado com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao criar banner: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Criar Banner de Teste'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(bannerAdminProvider.notifier).loadBanners();
              },
              child: const Text('Recarregar Banners'),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final bannersState = ref.watch(bannerAdminProvider);

                  return bannersState.when(
                    data: (banners) {
                      if (banners.isEmpty) {
                        return const Text('Nenhum banner encontrado');
                      }

                      return ListView.builder(
                        itemCount: banners.length,
                        itemBuilder: (context, index) {
                          final banner = banners[index];
                          return ListTile(
                            title: Text(banner.title),
                            subtitle: Text('Order: ${banner.order}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  banner.active
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color:
                                      banner.active ? Colors.green : Colors.red,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    try {
                                      await ref
                                          .read(bannerAdminProvider.notifier)
                                          .deleteBanner(banner.id);

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Banner deletado com sucesso!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Erro ao deletar banner: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('Erro: $error'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
