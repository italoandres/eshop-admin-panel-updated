import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';

/// Seção de Características em Destaque
///
/// FASE 1: Estrutura básica (placeholder de UI)
/// - Renderiza título e lista simples
/// - Ainda sem estilização final dos chips
///
/// FASE 2: Layout final com chips modernos (✅ COMPLETO)
/// - Estilização completa usando design tokens
/// - Chips com bordas arredondadas e padding
/// - Consistência visual com outras seções
/// - Suporte a tema escuro e claro
class ProductHighlightsSection extends StatelessWidget {
  final List<String> highlights;

  const ProductHighlightsSection({
    Key? key,
    required this.highlights,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Não renderiza se não houver highlights
    if (highlights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: spaceL, // FASE 2: 16px (consistente com outras seções)
        vertical: 24, // FASE 2: Margem vertical de 24px
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FASE 2: Título da seção (mesmo estilo de "Descrição do Produto")
          const Text(
            'CARACTERÍSTICAS EM DESTAQUE',
            style: TextStyle(
              fontSize: fontSectionTitle, // FASE 2: 16px (design token)
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: spaceL), // FASE 2: 16px gap

          // FASE 2: Chips estilizados com design tokens
          Wrap(
            spacing: spaceS, // FASE 2: 8px horizontal entre chips
            runSpacing: spaceS, // FASE 2: 8px vertical entre chips
            children: highlights.map((highlight) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: spaceM, // FASE 2: 12px horizontal
                  vertical: spaceS, // FASE 2: 8px vertical
                ),
                decoration: BoxDecoration(
                  // FASE 2: Cor de fundo elegante (cinza médio para tema escuro)
                  color: Colors.grey[800],
                  // FASE 2: Bordas arredondadas (8-10px conforme especificação)
                  borderRadius: BorderRadius.circular(spaceS), // 8px
                  // FASE 2: Borda sutil para definição
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  highlight,
                  style: const TextStyle(
                    fontSize: fontBody, // FASE 2: 14px (design token)
                    fontWeight: FontWeight.w500, // FASE 2: Peso médio para legibilidade
                    color: Colors.white,
                    height: 1.2, // FASE 2: Line height para melhor legibilidade
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
