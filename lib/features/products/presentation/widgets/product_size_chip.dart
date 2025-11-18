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
    final colorScheme = theme.colorScheme;

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
          // Background dinâmico
          color: isSelected
              ? colorScheme.primary // Selecionado: cor primária
              : (theme.brightness == Brightness.dark
                  ? Colors.grey[850] // Tema escuro: cinza escuro
                  : colorScheme.surfaceContainerLowest), // Tema claro: surface clara
          // Borda
          border: Border.all(
            color: isSelected
                ? colorScheme.primary // Selecionado: mesma cor do fundo
                : (theme.brightness == Brightness.dark
                    ? Colors.grey[700]!.withOpacity(0.5) // Tema escuro: borda sutil
                    : colorScheme.outline.withOpacity(0.2)), // Tema claro: 20% opacidade
            width: 1,
          ),
          // Cantos arredondados: 8px (especificação)
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: theme.textTheme.labelLarge?.copyWith(
              // Texto branco quando selecionado
              color: isSelected
                  ? Colors.white
                  : (isAvailable
                      ? (theme.brightness == Brightness.dark
                          ? Colors.white
                          : colorScheme.onSurface)
                      : Colors.grey[600]), // Indisponível: cinza
              // Bold quando selecionado (especificação)
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
