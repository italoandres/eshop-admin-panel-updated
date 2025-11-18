import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cart_item_model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  // Adicionar produto ao carrinho
  void addItem({
    required String productId,
    required String name,
    required String imageUrl,
    required double price,
    double? originalPrice,
    required String size,
    required String color,
  }) {
    // Verificar se o produto já está no carrinho com o mesmo tamanho e cor
    final existingIndex = state.indexWhere(
      (item) =>
          item.productId == productId &&
          item.size == size &&
          item.color == color,
    );

    if (existingIndex != -1) {
      // Se já existe, incrementar a quantidade
      final updatedItem = state[existingIndex].copyWith(
        quantity: state[existingIndex].quantity + 1,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Se não existe, adicionar novo item
      final newItem = CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        originalPrice: originalPrice,
        size: size,
        color: color,
        quantity: 1,
      );
      state = [...state, newItem];
    }
  }

  // Incrementar quantidade
  void incrementQuantity(String itemId) {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final updatedItem = state[index].copyWith(
        quantity: state[index].quantity + 1,
      );
      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    }
  }

  // Decrementar quantidade
  void decrementQuantity(String itemId) {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1 && state[index].quantity > 1) {
      final updatedItem = state[index].copyWith(
        quantity: state[index].quantity - 1,
      );
      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    }
  }

  // Remover item
  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  // Limpar carrinho
  void clear() {
    state = [];
  }

  // Calcular subtotal
  double getSubtotal() {
    return state.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Calcular desconto progressivo
  int getDiscountPercent() {
    final subtotal = getSubtotal();
    if (subtotal >= 1000) return 80;
    if (subtotal >= 700) return 65;
    if (subtotal >= 400) return 40;
    if (subtotal >= 200) return 25;
    return 0;
  }

  // Calcular desconto em reais
  double getDiscountAmount() {
    final subtotal = getSubtotal();
    final percent = getDiscountPercent();
    return subtotal * (percent / 100);
  }

  // Calcular total
  double getTotal() {
    return getSubtotal() - getDiscountAmount();
  }

  // Obter contagem de itens
  int getItemCount() {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

// Provider do carrinho
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>(
  (ref) => CartNotifier(),
);

// Provider para contagem de itens
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});

// Provider para subtotal
final cartSubtotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
});

// Provider para desconto
final cartDiscountPercentProvider = Provider<int>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  if (subtotal >= 1000) return 80;
  if (subtotal >= 700) return 65;
  if (subtotal >= 400) return 40;
  if (subtotal >= 200) return 25;
  return 0;
});

// Provider para valor do desconto
final cartDiscountAmountProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final percent = ref.watch(cartDiscountPercentProvider);
  return subtotal * (percent / 100);
});

// Provider para total
final cartTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final discount = ref.watch(cartDiscountAmountProvider);
  return subtotal - discount;
});
