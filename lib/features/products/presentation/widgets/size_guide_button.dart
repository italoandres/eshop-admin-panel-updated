import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';

/// Botão para abrir o modal do Guia de Tamanhos
///
/// FASE 1: Estrutura básica do botão
/// Exibe ícone de régua + texto "Guia de tamanhos"
class SizeGuideButton extends StatelessWidget {
  final VoidCallback onTap;

  const SizeGuideButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: spaceM, // 12px
          vertical: spaceS,    // 8px
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.straighten,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: spaceS), // 8px
            Text(
              'Guia de tamanhos',
              style: TextStyle(
                fontSize: fontBody, // 14px
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
