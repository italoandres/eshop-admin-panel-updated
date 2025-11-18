import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/shipping_option.dart';

class ShippingOptionsModal extends StatefulWidget {
  const ShippingOptionsModal({Key? key}) : super(key: key);

  @override
  State<ShippingOptionsModal> createState() => _ShippingOptionsModalState();
}

class _ShippingOptionsModalState extends State<ShippingOptionsModal> {
  // Mock data
  String currentCep = '01310-100';
  bool isChangingCep = false;
  int selectedIndex = 0;
  final TextEditingController cepController = TextEditingController();

  final List<ShippingOption> mockShippingOptions = [
    ShippingOption(
      type: 'Normal',
      eta: 'Chega dia 25 de novembro',
      price: 9.90,
    ),
    ShippingOption(
      type: 'Expresso',
      eta: 'Chega dia 22 de novembro',
      price: 19.90,
    ),
    ShippingOption(
      type: 'Retire na loja',
      eta: 'Disponível a partir do dia 19 de novembro',
      price: 0.0,
      additionalInfo: 'Retire grátis em uma de nossas lojas',
    ),
    ShippingOption(
      type: 'Agendado',
      eta: 'Escolha o melhor dia para receber',
      price: 14.90,
    ),
  ];

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  void _applyCep() {
    final newCep = cepController.text;
    if (newCep.length == 9) {
      setState(() {
        currentCep = newCep;
        isChangingCep = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEP atualizado para $newCep')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CEP inválido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
          _buildHeader(),
          const Divider(height: 1, thickness: 1),
          // Conteúdo scrollável
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Título e descrição
                  _buildTitleSection(),
                  const SizedBox(height: 16),
                  // Campo de alteração de CEP (se ativo)
                  if (isChangingCep) _buildChangeCepField(),
                  const SizedBox(height: 24),
                  // Lista de opções de frete
                  _buildShippingOptions(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header com CEP detectado
  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Ícone X para fechar
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
            const SizedBox(width: 16),
            // Ícone de localização
            const Icon(
              Icons.location_on,
              color: Color(0xFF6200EE),
              size: 24,
            ),
            const SizedBox(width: 8),
            // Texto com CEP
            Expanded(
              child: Text(
                'Enviar para $currentCep',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            // Botão Alterar
            GestureDetector(
              onTap: () {
                setState(() {
                  isChangingCep = true;
                  cepController.text = currentCep;
                });
              },
              child: const Text(
                'Alterar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6200EE),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Título e descrição
  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRAZO DE ENTREGA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Abaixo, os prazos de entrega para CEP: $currentCep',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                isChangingCep = true;
                cepController.text = currentCep;
              });
            },
            child: const Text(
              'Alterar meu CEP',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6200EE),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Campo para alterar CEP
  Widget _buildChangeCepField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digite o novo CEP:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                      _CepInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      hintText: '00000-000',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF6200EE),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _applyCep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Aplicar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Lista de opções de frete
  Widget _buildShippingOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          mockShippingOptions.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ShippingOptionTile(
              option: mockShippingOptions[index],
              isSelected: index == selectedIndex,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                // Pequeno delay para mostrar seleção antes de fechar
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.pop(context, mockShippingOptions[index]);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para cada opção de frete
class ShippingOptionTile extends StatelessWidget {
  final ShippingOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const ShippingOptionTile({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8E8E8) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6200EE)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tipo de frete
                  Row(
                    children: [
                      Text(
                        option.type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      // Preço
                      Text(
                        option.price == 0
                            ? 'Grátis'
                            : 'R\$ ${option.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: option.price == 0
                              ? Colors.green[700]
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // ETA
                  Text(
                    option.eta,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  // Informação adicional
                  if (option.additionalInfo != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      option.additionalInfo!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Indicador de seleção
            if (isSelected)
              const SizedBox(width: 12),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF6200EE),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

// Formatador de CEP
class _CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length <= 5) {
      return newValue;
    }
    final formatted = '${text.substring(0, 5)}-${text.substring(5)}';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
