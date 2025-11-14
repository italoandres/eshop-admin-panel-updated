# 🎯 INTEGRAÇÃO DESCONTO PROGRESSIVO - FLUTTER

## ✅ O QUE JÁ FOI FEITO

### Arquivos Criados:
1. ✅ `lib/data/data_sources/remote/discount_rule_remote_data_source.dart`
2. ✅ `lib/domain/repositories/discount_rule_repository.dart`
3. ✅ `lib/data/repositories/discount_rule_repository_impl.dart`
4. ✅ `lib/domain/usecases/discount_rule/get_discount_rule_usecase.dart`
5. ✅ `lib/domain/entities/product/progressive_discount_rule.dart` (corrigido)
6. ✅ `lib/core/services/services_locator.dart` (registrado)

### O que funciona:
- Data Source busca regras da API
- Repository implementado
- Use Case pronto
- Service Locator configurado
- Entidade aceita `productId` nulo (para regras globais)

---

## ⚠️ O QUE FALTA FAZER

### Passo 6: Integrar no CartBloc

Edite `lib/presentation/blocs/cart/cart_bloc.dart`:

```dart
// Adicionar no construtor:
final GetDiscountRuleUseCase _getDiscountRuleUseCase;

CartBloc(
  this._getCachedCartUseCase,
  this._addCartUseCase,
  this._getRemoteCartUseCase,
  this._deleteCartUseCase,
  this._getDiscountRuleUseCase, // ADICIONAR
) : super(CartInitial()) {
  // ...
}
```

### Passo 7: Buscar Regra ao Adicionar Produto

No evento `AddProduct`, após adicionar o item ao carrinho, busque a regra:

```dart
on<AddProduct>((event, emit) async {
  // ... código existente de adicionar ao carrinho ...
  
  // ADICIONAR: Buscar regra de desconto
  final ruleResult = await _getDiscountRuleUseCase(event.cartItem.product.id);
  
  ruleResult.fold(
    (failure) {
      // Sem desconto, continua normal
    },
    (rule) {
      if (rule != null && rule.isCurrentlyActive()) {
        // Tem desconto! Adicionar ao state
        // Você pode criar um novo campo no CartState para armazenar as regras
      }
    },
  );
});
```

### Passo 8: Adicionar Regras ao CartState

Edite `lib/presentation/blocs/cart/cart_state.dart`:

```dart
abstract class CartState extends Equatable {
  final List<CartItem> cartItems;
  final Map<String, ProgressiveDiscountRule> discountRules; // ADICIONAR

  const CartState({
    required this.cartItems,
    this.discountRules = const {}, // ADICIONAR
  });
  
  // ... resto do código
}
```

### Passo 9: Mostrar Banner na Tela do Carrinho

Edite a tela do carrinho para mostrar o `ProgressiveDiscountBanner`:

```dart
// Para cada produto no carrinho:
if (discountRules.containsKey(product.id)) {
  ProgressiveDiscountBanner(
    rule: discountRules[product.id]!,
    currentQuantity: cartItem.quantity,
    originalPrice: product.currentPrice,
    onTap: () {
      ProgressiveDiscountModal.show(
        context,
        discountRules[product.id]!,
        cartItem.quantity,
        product.currentPrice,
      );
    },
  )
}
```

### Passo 10: Calcular Desconto no Total

No cálculo do total do carrinho, aplicar o desconto:

```dart
num calculateTotal() {
  num total = 0;
  
  for (var item in cartItems) {
    final rule = discountRules[item.product.id];
    
    if (rule != null && rule.isCurrentlyActive()) {
      final tier = rule.getApplicableTier(item.quantity);
      if (tier != null) {
        final discountedPrice = tier.calculateFinalPrice(item.product.currentPrice);
        total += discountedPrice * item.quantity;
        continue;
      }
    }
    
    // Sem desconto
    total += item.product.currentPrice * item.quantity;
  }
  
  return total;
}
```

---

## 🚀 TESTANDO

1. Rode o backend: `node backend/server.js`
2. Crie uma promoção no admin para "Todos os produtos"
3. Rode o Flutter: `flutter run`
4. Adicione produtos ao carrinho
5. O banner de desconto progressivo deve aparecer!

---

## 📝 ALTERNATIVA SIMPLES

Se quiser algo mais simples, pode buscar a regra diretamente na tela do produto:

```dart
// Na ProductDetailsView:
Future<void> _loadDiscountRule() async {
  final useCase = sl<GetDiscountRuleUseCase>();
  final result = await useCase(widget.product.id);
  
  result.fold(
    (failure) => null,
    (rule) {
      if (rule != null && rule.isCurrentlyActive()) {
        setState(() {
          _discountRule = rule;
        });
      }
    },
  );
}
```

---

**Status:** Infraestrutura 100% pronta. Falta apenas integrar no BLoC e UI.
**Tempo estimado:** 30-60 minutos
