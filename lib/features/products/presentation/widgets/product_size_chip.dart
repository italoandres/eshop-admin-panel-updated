import 'package:flutter/material.dart';

/// Chip de tamanho com largura dinâmica
///
/// FASE 1: Componente isolado com largura automática
/// - Largura ajusta automaticamente ao texto
/// - Padding: 14px horizontal, 10px vertical
/// - Border radius: 8px
/// - Sem width fixa, sem minWidth, sem Expanded
///
/// Características:
/// - Estado normal: background claro, borda sutil
/// - Estado selecionado: background primary, texto branco bold
/// - Estado indisponível: opacidade reduzida
class ProductSizeChip extends StatelessWidget {
  final String size;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const ProductSizeChip({
    Key? key,
    required this.size,
    this.isSelected = false,
    this.isAvailable = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        // ✅ SEM width fixa - largura automática baseada no conteúdo
        // ✅ SEM minWidth - permite chips pequenos como "P" ou "M"
        // ✅ SEM Expanded ou Flexible - mantém largura natural
        padding: const EdgeInsets.symmetric(
          horizontal: 14, // Especificação: 14px
          vertical: 10, // Especificação: 10px
        ),
        decoration: BoxDecoration(
          // Background: selecionado usa primary, normal usa cinza escuro
          color: isSelected
              ? theme.primaryColor
              : Colors.grey[850],
          // Borda: selecionado usa primary, normal usa cinza claro
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : Colors.grey[700]!,
            width: isSelected ? 2 : 1,
          ),
          // Cantos arredondados: 8px (especificação)
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 14,
              // Texto SEMPRE branco (tema escuro), exceto quando indisponível
              color: isAvailable ? Colors.white : Colors.grey[600],
              // Bold quando selecionado (especificação)
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
