# 🎯 Escassez como Estratégia de Marketing

## ⚠️ IMPORTANTE: NÃO É ESTOQUE REAL!

A escassez é uma **estratégia de marketing** para criar urgência, **NÃO** tem relação com estoque real do produto.

---

## 📊 Como Funciona

### No Backend (Product Model)

```javascript
scarcityMarketing: {
  enabled: Boolean,    // Ativar escassez para este produto?
  unitsLeft: Number    // "Últimas X unidades" (FAKE - marketing)
}
```

### No Admin Panel (Ao criar/editar produto)

1. **Checkbox:** "Ativar escassez?"
2. **Se marcado:** Aparece campo "Últimas X unidades"
3. **Admin escolhe:** 5, 7, 10, 20, etc. (número fake)

### No App Flutter

- Se `scarcityEnabled = true` → Mostra alerta
- Texto: "Últimas X unidades em estoque!"
- X vem de `scarcityUnitsLeft` (fake)

---

## 🎭 Exemplo Prático

### Produto 1: Camisa Premium
```json
{
  "name": "Camisa Premium",
  "scarcityMarketing": {
    "enabled": true,
    "unitsLeft": 7
  }
}
```
**No app:** "Últimas 7 unidades em estoque!" ⚠️

### Produto 2: Camisa Básica
```json
{
  "name": "Camisa Básica",
  "scarcityMarketing": {
    "enabled": false,
    "unitsLeft": 10
  }
}
```
**No app:** Nada aparece (escassez desativada)

---

## 🆚 Diferença: Escassez vs Estoque

| Aspecto | Escassez (Marketing) | Estoque Real |
|---------|---------------------|--------------|
| **Propósito** | Criar urgência | Controlar disponibilidade |
| **Valor** | Fake (escolhido pelo admin) | Real (quantidade física) |
| **Configuração** | Por produto | Por variante/tamanho |
| **Visibilidade** | Opcional (liga/desliga) | Sempre validado |
| **Exemplo** | "Últimas 7 unidades!" | Tamanho M: 50 unidades |

---

## 🎯 Casos de Uso

### 1. Lançamento de Produto
```
Ativar escassez: ✅
Últimas unidades: 10
Resultado: Cria urgência no lançamento
```

### 2. Promoção Relâmpago
```
Ativar escassez: ✅
Últimas unidades: 5
Resultado: Aumenta conversão na promo
```

### 3. Produto Regular
```
Ativar escassez: ❌
Resultado: Sem alerta, venda normal
```

---

## 🔧 Implementação Técnica

### Backend
- **Arquivo:** `backend/models/Product.js`
- **Campos:** `scarcityMarketing.enabled`, `scarcityMarketing.unitsLeft`

### Flutter
- **Arquivo:** `lib/features/products/presentation/pages/product_detail_page.dart`
- **Getters:** `scarcityEnabled`, `scarcityUnitsLeft`
- **Widget:** `_buildStockAlert()`

### Admin Panel (TODO)
- Adicionar checkbox "Ativar escassez?"
- Adicionar campo numérico "Últimas X unidades"
- Salvar em `scarcityMarketing`

---

## ✅ Vantagens

1. **Flexibilidade** - Admin decide por produto
2. **Urgência** - Aumenta conversão
3. **Controle** - Liga/desliga quando quiser
4. **Independente** - Não afeta estoque real
5. **Estratégico** - Usa em promos, lançamentos, etc.

---

## 🚀 Próximos Passos

### 1. Admin Panel
- [ ] Adicionar checkbox "Ativar escassez?" no formulário de produto
- [ ] Adicionar campo "Últimas X unidades" (só aparece se checkbox marcado)
- [ ] Salvar em `scarcityMarketing.enabled` e `scarcityMarketing.unitsLeft`

### 2. Testes
- [ ] Criar produto com escassez ativada
- [ ] Criar produto sem escassez
- [ ] Verificar no app se alerta aparece corretamente

---

## 📝 Notas Importantes

- ⚠️ **Escassez é FAKE** - Não tem relação com estoque
- 🎯 **É estratégia de marketing** - Para criar urgência
- 🔧 **Configurável por produto** - Admin tem controle total
- 📊 **Estoque real** - Continua sendo validado separadamente

---

**Data:** 26/01/2025
**Status:** ✅ Implementado no backend e app
**Pendente:** Interface no admin panel
