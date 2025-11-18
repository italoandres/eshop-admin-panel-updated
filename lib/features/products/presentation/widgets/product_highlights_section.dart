import 'package:flutter/material.dart';

/// Seção de Características em Destaque
///
/// FASE 1: Estrutura básica (placeholder de UI)
/// - Renderiza título e lista simples
/// - Ainda sem estilização final dos chips
///
/// FASE 2: Layout final com chips modernos
/// - Estilização completa usando design tokens
/// - Chips com bordas arredondadas e padding
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          const Text(
            'CARACTERÍSTICAS EM DESTAQUE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),

          // FASE 1: Placeholder - lista simples dos highlights
          // FASE 2: Chips estilizados com wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: highlights.map((highlight) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  highlight,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
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
