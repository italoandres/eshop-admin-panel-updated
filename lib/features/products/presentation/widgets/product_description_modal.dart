import 'package:flutter/material.dart';

class ProductDescriptionModal extends StatelessWidget {
  const ProductDescriptionModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(context),
          const Divider(height: 1, thickness: 1),
          // Conteúdo scrollável
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Propriedades do produto
                  _buildPropertyRow('Nome', 'Camisa Umbro TWR Striker Masculina'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Referência', 'D21-1055-008-03'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Clube', 'Sem Clube'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Composição', '100% Poliéster'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Indicado para', 'Jogo'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Gola', 'Gola Careca'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Manga', 'Manga Curta'),
                  const SizedBox(height: 12),
                  _buildPropertyRow(
                    'Dimensões Aproximadas',
                    'Ombro: 42 cm; Tórax: 102 cm; Comprimento: 71 cm',
                  ),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Número', 'Sem número'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Garantia do Fabricante', 'Contra defeito de fabricação'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Origem', 'Nacional'),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Referência', 'D21-1055-008-02'),

                  const SizedBox(height: 24),
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),

                  // Texto descritivo livre
                  Text(
                    'Camisa Umbro TWR Striker masculina confeccionada em material de alta qualidade e tecnologia. '
                    'Perfeita para a prática esportiva, oferece conforto e estilo. '
                    'Detalhes modernos e acabamento impecável. '
                    'Ideal para quem busca performance e design.\n\n'
                    'A tecnologia aplicada no tecido garante maior respirabilidade e conforto durante o uso. '
                    'O modelo possui corte anatômico que se adapta perfeitamente ao corpo, proporcionando '
                    'liberdade de movimento. Produto oficial com todas as características de qualidade da marca Umbro.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header com título e botão fechar
  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Descrição do Produto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para cada propriedade (label: valor)
  Widget _buildPropertyRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
