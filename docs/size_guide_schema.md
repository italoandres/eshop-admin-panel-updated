# Schema do Guia de Tamanhos (Size Guide)

## FASE 1: Estrutura básica dos campos

### Campos adicionados ao modelo `Product`

#### 1. `sizeGuideType` (String | null)
Define o tipo de guia de tamanhos a ser exibido.

**Valores aceitos:**
- `"shoe"` - Guia de calçados
- `"clothes"` - Guia de roupas/vestuário
- `null` - Produto sem guia (botão não aparece)

**Exemplo de uso no Admin:**
```json
{
  "id": "prod_123",
  "name": "Camisa Umbro TWR Striker",
  "sizeGuideType": "clothes"
}
```

#### 2. `sizeGuideContent` (String | null)
Conteúdo customizado do guia de tamanhos.

**Valores aceitos:**
- URL da imagem (ex: `"https://cdn.example.com/size-guide-custom.png"`)
- Conteúdo HTML (a ser implementado na Fase 2)
- `null` - Usa o guia padrão baseado no `sizeGuideType`

**Exemplo de uso no Admin:**
```json
{
  "id": "prod_123",
  "name": "Tênis Nike Air Max",
  "sizeGuideType": "shoe",
  "sizeGuideContent": "https://cdn.loja.com/guias/tenis-nike-especial.png"
}
```

## Regras de Negócio

### Exibição do botão "Guia de Tamanhos"
O botão só aparece quando:
- `sizeGuideType !== null`

### Prioridade de conteúdo (Fase 2)
1. Se `sizeGuideContent` existe → usar conteúdo custom
2. Se `sizeGuideType === "shoe"` → usar tabela padrão de calçados
3. Se `sizeGuideType === "clothes"` → usar tabela padrão de roupas

## Implementação no Backend/Admin

### MongoDB Schema Example
```javascript
const productSchema = new Schema({
  // ... outros campos existentes

  // FASE 1: Guia de Tamanhos
  sizeGuideType: {
    type: String,
    enum: ['shoe', 'clothes', null],
    default: null,
  },
  sizeGuideContent: {
    type: String,
    default: null,
  },
});
```

### API REST Example
```javascript
// GET /api/products/:id
{
  "id": "prod_123",
  "name": "Camisa Umbro TWR Striker",
  "price": 26.00,
  "sizeGuideType": "clothes",
  "sizeGuideContent": null
}
```

## Casos de Uso

### Caso 1: Produto com guia padrão de roupas
```json
{
  "sizeGuideType": "clothes",
  "sizeGuideContent": null
}
```
→ Mostra botão + abre modal com tabela padrão de roupas (Fase 2)

### Caso 2: Produto com guia padrão de calçados
```json
{
  "sizeGuideType": "shoe",
  "sizeGuideContent": null
}
```
→ Mostra botão + abre modal com tabela padrão de calçados (Fase 2)

### Caso 3: Produto com guia customizado
```json
{
  "sizeGuideType": "clothes",
  "sizeGuideContent": "https://cdn.loja.com/custom-guide.png"
}
```
→ Mostra botão + abre modal com imagem customizada (Fase 2)

### Caso 4: Produto sem guia
```json
{
  "sizeGuideType": null,
  "sizeGuideContent": null
}
```
→ Botão não aparece

## FASE 2 (Próximos Passos)

- [ ] Criar tabelas padrão (imagens ou HTML)
- [ ] Implementar renderização de conteúdo no modal
- [ ] Adicionar lógica condicional baseada no tipo
- [ ] Testar responsividade das tabelas
- [ ] Suporte a múltiplos idiomas (opcional)
