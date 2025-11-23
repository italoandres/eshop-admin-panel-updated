import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/config/store_config_provider.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  // Controle de expansão dos itens
  bool _meninoExpanded = false;
  bool _meninaExpanded = false;
  bool _outletExpanded = false;
  bool _numeroExpanded = false;
  bool _idadeExpanded = false;
  bool _categoriaExpanded = false;

  @override
  Widget build(BuildContext context) {
    final storeConfig = ref.watch(storeConfigProvider).value;
    
    return Drawer(
      child: Column(
        children: [
          // Header com logo e botão fechar
          _buildHeader(storeConfig?.logoUrl),
          
          // Lista de filtros expansíveis
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildExpandableItem(
                  title: 'Menino',
                  isExpanded: _meninoExpanded,
                  onTap: () => setState(() => _meninoExpanded = !_meninoExpanded),
                ),
                _buildExpandableItem(
                  title: 'Menina',
                  isExpanded: _meninaExpanded,
                  onTap: () => setState(() => _meninaExpanded = !_meninaExpanded),
                ),
                _buildExpandableItem(
                  title: 'Outlet',
                  isExpanded: _outletExpanded,
                  onTap: () => setState(() => _outletExpanded = !_outletExpanded),
                ),
                _buildExpandableItem(
                  title: 'Número',
                  isExpanded: _numeroExpanded,
                  onTap: () => setState(() => _numeroExpanded = !_numeroExpanded),
                ),
                _buildExpandableItem(
                  title: 'Idade',
                  isExpanded: _idadeExpanded,
                  onTap: () => setState(() => _idadeExpanded = !_idadeExpanded),
                ),
                _buildCategoriaItem(),
                
                // Black Friday
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Black Friday',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Botões de ação na parte inferior
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(String? logoUrl) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Logo centralizada
          Center(
            child: logoUrl != null
                ? CachedNetworkImage(
                    imageUrl: logoUrl,
                    height: 60,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Icon(
                      Icons.store,
                      size: 60,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.store,
                      size: 60,
                    ),
                  )
                : const Icon(
                    Icons.store,
                    size: 60,
                  ),
          ),
          // Botão X no canto superior direito
          Positioned(
            right: 8,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableItem({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriaItem() {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _categoriaExpanded = !_categoriaExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _categoriaExpanded ? Theme.of(context).primaryColor : Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categoria',
                  style: TextStyle(
                    fontSize: 16,
                    color: _categoriaExpanded ? Colors.white : Colors.black,
                    fontWeight: _categoriaExpanded ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                Icon(
                  _categoriaExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: _categoriaExpanded ? Colors.white : Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (_categoriaExpanded) _buildCategoriaList(),
      ],
    );
  }

  Widget _buildCategoriaList() {
    final categorias = [
      'Tênis',
      'Chinelo',
      'Sapatilha',
      'Sandália e papete',
      'Calçados de luz e led',
      'Botas, coturnos e galochas',
      'Calçados e brinquedos',
      'Personalizáveis',
    ];

    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          ...categorias.map((categoria) => InkWell(
                onTap: () {
                  // TODO: Navegar para categoria
                  debugPrint('Categoria selecionada: $categoria');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      categoria,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              )),
          InkWell(
            onTap: () {
              // TODO: Ver todas categorias
              debugPrint('Ver todos');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ver todos',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão: entre ou cadastre-se
          _buildActionButton(
            icon: Icons.person_outline,
            label: 'entre ou cadastre-se',
            backgroundColor: Colors.white,
            textColor: Colors.black87,
            borderColor: Colors.grey.shade300,
            onTap: () {
              // TODO: Navegar para login/cadastro
              debugPrint('Login/Cadastro');
            },
          ),
          const SizedBox(height: 8),
          
          // Botão: atendimento
          _buildActionButton(
            icon: Icons.headset_mic_outlined,
            label: 'atendimento',
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onTap: () {
              // TODO: Abrir atendimento
              debugPrint('Atendimento');
            },
          ),
          const SizedBox(height: 8),
          
          // Botão: whatsapp
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            label: 'whatsapp',
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onTap: () {
              // TODO: Abrir WhatsApp
              debugPrint('WhatsApp');
            },
          ),
          const SizedBox(height: 8),
          
          // Botão: favoritos
          _buildActionButton(
            icon: Icons.favorite_border,
            label: 'favoritos',
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onTap: () {
              // TODO: Navegar para favoritos
              debugPrint('Favoritos');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
