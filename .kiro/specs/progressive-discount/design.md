# Design Document - Progressive Discount System

## Overview

Sistema completo de desconto progressivo que incentiva compras maiores através de descontos crescentes baseados na quantidade de produtos no carrinho. O sistema é composto por backend (Node.js + MongoDB), admin panel (React) e app mobile (Flutter).

## Architecture

### High-Level Architecture

```
┌─────────────────┐
│   Admin Panel   │ ← Gerencia regras
│     (React)     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Backend API   │ ← Processa e valida
│  (Node.js +     │
│    MongoDB)     │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Mobile App    │ ← Exibe e calcula
│    (Flutter)    │
└─────────────────┘
```

---

## Data Models

### 1. DiscountRule (MongoDB Schema)

```javascript
{
  _id: ObjectId,
  productId: String,           // ID do produto
  name: String,                // Nome da promoção
  description: String,         // Descrição
  isActive: Boolean,           // Ativa/Inativa
  startDate: Date,             // Início (opcional)
  endDate: Date,               // Fim (opcional)
  tiers: [                     // Níveis de desconto
    {
      quantity: Number,        // Quantidade mínima
      discountPercent: Number, // Desconto em %
      _id: ObjectId
    }
  ],
  createdAt: Date,
  updatedAt: Date,
  createdBy: String,           // ID do admin
  analytics: {
    views: Number,
    conversions: Number,
    revenue: Number
  }
}
```

### 2. DiscountTier (Dart Class)

```dart
class DiscountTier {
  final int quantity;
  final double discountPercent;
  
  const DiscountTier({
    required this.quantity,
    required this.discountPercent,
  });
  
  double calculateDiscount(num originalPrice) {
    return originalPrice * (discountPercent / 100);
  }
  
  num calculateFinalPrice(num originalPrice) {
    return originalPrice - calculateDiscount(originalPrice);
  }
}
```

### 3. ProgressiveDiscountRule (Dart Class)

```dart
class ProgressiveDiscountRule {
  final String id;
  final String productId;
  final String name;
  final String description;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<DiscountTier> tiers;
  
  const ProgressiveDiscountRule({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.tiers,
  });
  
  // Retorna tier aplicável baseado na quantidade
  DiscountTier? getApplicableTier(int quantity) {
    final eligibleTiers = tiers
        .where((tier) => quantity >= tier.quantity)
        .toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));
    
    return eligibleTiers.isNotEmpty ? eligibleTiers.first : null;
  }
  
  // Retorna próximo tier disponível
  DiscountTier? getNextTier(int currentQuantity) {
    final nextTiers = tiers
        .where((tier) => tier.quantity > currentQuantity)
        .toList()
      ..sort((a, b) => a.quantity.compareTo(b.quantity));
    
    return nextTiers.isNotEmpty ? nextTiers.first : null;
  }
  
  // Verifica se promoção está ativa no momento
  bool isCurrentlyActive() {
    if (!isActive) return false;
    
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    
    return true;
  }
}
```

---

## Backend Components

### 1. Discount Rule Controller

```javascript
// controllers/discountRuleController.js

// Criar nova regra
exports.createRule = async (req, res) => {
  try {
    const { productId, name, description, tiers, startDate, endDate } = req.body;
    
    // Validar
    if (!productId || !name || !tiers || tiers.length < 2) {
      return res.status(400).json({ error: 'Dados inválidos' });
    }
    
    // Validar tiers
    validateTiers(tiers);
    
    // Verificar se já existe regra ativa para o produto
    const existingRule = await DiscountRule.findOne({
      productId,
      isActive: true
    });
    
    if (existingRule) {
      return res.status(400).json({ 
        error: 'Já existe uma regra ativa para este produto' 
      });
    }
    
    // Criar regra
    const rule = new DiscountRule({
      productId,
      name,
      description,
      tiers: tiers.sort((a, b) => a.quantity - b.quantity),
      startDate,
      endDate,
      isActive: true,
      createdBy: req.user.id
    });
    
    await rule.save();
    
    // Invalidar cache
    await invalidateCache(`discount:${productId}`);
    
    res.status(201).json(rule);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Calcular desconto
exports.calculateDiscount = async (req, res) => {
  try {
    const { productId, quantity, originalPrice } = req.body;
    
    // Buscar regra ativa (com cache)
    const rule = await getActiveRule(productId);
    
    if (!rule) {
      return res.json({
        hasDiscount: false,
        originalPrice,
        finalPrice: originalPrice,
        discountPercent: 0,
        savings: 0
      });
    }
    
    // Encontrar tier aplicável
    const applicableTier = rule.tiers
      .filter(t => quantity >= t.quantity)
      .sort((a, b) => b.quantity - a.quantity)[0];
    
    if (!applicableTier) {
      return res.json({
        hasDiscount: false,
        originalPrice,
        finalPrice: originalPrice,
        discountPercent: 0,
        savings: 0,
        nextTier: rule.tiers[0]
      });
    }
    
    // Calcular
    const discountAmount = originalPrice * (applicableTier.discountPercent / 100);
    const finalPrice = originalPrice - discountAmount;
    
    // Próximo tier
    const nextTier = rule.tiers.find(t => t.quantity > quantity);
    
    res.json({
      hasDiscount: true,
      originalPrice,
      finalPrice,
      discountPercent: applicableTier.discountPercent,
      savings: discountAmount,
      currentTier: applicableTier,
      nextTier,
      rule: {
        id: rule._id,
        name: rule.name,
        description: rule.description
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
```

### 2. Validation Helper

```javascript
// utils/discountValidation.js

function validateTiers(tiers) {
  // Verificar quantidade mínima de tiers
  if (tiers.length < 2) {
    throw new Error('Mínimo 2 tiers necessários');
  }
  
  // Verificar quantidade máxima
  if (tiers.length > 10) {
    throw new Error('Máximo 10 tiers permitidos');
  }
  
  // Ordenar por quantidade
  const sorted = [...tiers].sort((a, b) => a.quantity - b.quantity);
  
  // Validar cada tier
  for (let i = 0; i < sorted.length; i++) {
    const tier = sorted[i];
    
    // Validar quantidade
    if (!Number.isInteger(tier.quantity) || tier.quantity < 1) {
      throw new Error(`Tier ${i + 1}: quantidade deve ser inteiro positivo`);
    }
    
    // Validar desconto
    if (tier.discountPercent < 1 || tier.discountPercent > 99) {
      throw new Error(`Tier ${i + 1}: desconto deve estar entre 1% e 99%`);
    }
    
    // Validar progressão de desconto
    if (i > 0 && tier.discountPercent <= sorted[i - 1].discountPercent) {
      throw new Error(`Tier ${i + 1}: desconto deve ser maior que tier anterior`);
    }
    
    // Validar unicidade de quantidade
    if (i > 0 && tier.quantity === sorted[i - 1].quantity) {
      throw new Error(`Tier ${i + 1}: quantidade duplicada`);
    }
  }
  
  return true;
}
```

---

## Frontend Components (Flutter)

### 1. Progressive Discount Banner

```dart
class ProgressiveDiscountBanner extends StatelessWidget {
  final ProgressiveDiscountRule rule;
  final int currentQuantity;
  final num originalPrice;
  final VoidCallback onTap;
  
  const ProgressiveDiscountBanner({
    required this.rule,
    required this.currentQuantity,
    required this.originalPrice,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final currentTier = rule.getApplicableTier(currentQuantity);
    final nextTier = rule.getNextTier(currentQuantity);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: _getGradient(currentTier, nextTier),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(currentTier, nextTier),
            SizedBox(width: 12),
            Expanded(
              child: _buildContent(currentTier, nextTier),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIcon(DiscountTier? current, DiscountTier? next) {
    if (next == null) {
      return Icon(Icons.emoji_events, color: Colors.white, size: 32);
    }
    return Icon(Icons.card_giftcard, color: Colors.white, size: 32);
  }
  
  Widget _buildContent(DiscountTier? current, DiscountTier? next) {
    if (current == null) {
      // Nenhum desconto ainda
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Desconto Progressivo Disponível!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Adicione ${nextTier!.quantity} e ganhe ${nextTier.discountPercent}% OFF',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      );
    }
    
    if (next == null) {
      // Desconto máximo atingido
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎉 Desconto Máximo Atingido!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${current.discountPercent}% OFF aplicado',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      );
    }
    
    // Tem desconto atual e próximo disponível
    final quantityNeeded = next.quantity - currentQuantity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${current.discountPercent}% OFF Ativo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Adicione +$quantityNeeded e ganhe ${next.discountPercent}% OFF!',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
  
  LinearGradient _getGradient(DiscountTier? current, DiscountTier? next) {
    if (next == null) {
      // Máximo atingido - dourado
      return LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      );
    }
    
    if (current == null) {
      // Nenhum desconto - verde
      return LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
      );
    }
    
    // Desconto intermediário - azul
    return LinearGradient(
      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    );
  }
}
```

Continuando o design...
