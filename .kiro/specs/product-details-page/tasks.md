# Implementation Plan - Product Details Page

## Overview

Este plano de implementação divide a criação da tela de detalhes do produto em tarefas incrementais e gerenciáveis. Cada tarefa constrói sobre as anteriores, garantindo progresso contínuo e código sempre funcional.

---

## Tasks

- [x] 1. Criar data models e entidades base


  - Criar ShippingInfo entity com computed property para formatação de prazo
  - Criar Promotion entity com campos de promoção
  - Criar InstallmentInfo class com lógica de formatação
  - Estender Product entity com novos campos (originalPrice, discountPercentage, rating, reviewCount, soldCount, shippingInfo, activePromotion)
  - Adicionar computed property currentPrice e installmentInfo ao Product
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 2.1, 3.1, 3.2, 4.1_



- [ ] 2. Implementar PriceSection component
  - Criar widget PriceSection com props (currentPrice, originalPrice, discountPercentage, installment)
  - Implementar layout com Row para badge de desconto + preços
  - Adicionar badge de desconto com fundo vermelho/rosa e texto branco
  - Implementar exibição de preço atual em fonte grande (32sp) e cor vermelha
  - Adicionar preço original riscado em cinza quando houver desconto
  - Implementar Row secundária com ícone de cartão + texto de parcelamento
  - Aplicar formatação brasileira de moeda (R$ XX,XX)


  - Adicionar RepaintBoundary para otimização
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

- [ ] 3. Implementar RatingComponent
  - Criar widget RatingComponent com props (rating, reviewCount, soldCount)
  - Implementar layout com Row: estrela + nota + (reviews) + separador + vendidos
  - Adicionar ícone de estrela amarela
  - Formatar nota com 1 casa decimal
  - Adicionar número de reviews entre parênteses
  - Adicionar separador vertical (|) em cinza


  - Formatar número de vendidos com texto "vendidos"
  - Aplicar font size 14sp e cor cinza para texto
  - Adicionar Semantics para acessibilidade
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 11.4_

- [ ] 4. Implementar PromotionalBanner component
  - Criar widget PromotionalBanner com props (promotion, onTap)
  - Implementar Container com fundo rosa claro e border radius 8px
  - Adicionar InkWell para ripple effect


  - Implementar Row com ícone de presente + texto + seta
  - Aplicar padding 12px vertical e 16px horizontal
  - Adicionar ícone de seta à direita
  - Implementar callback onTap
  - Adicionar Semantics com hint "Toque para ver detalhes"
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 10.2_

- [ ] 5. Implementar ShippingSection component
  - Criar widget ShippingSection com props (shippingInfo, onTap)
  - Implementar Container com fundo branco e border radius 8px


  - Adicionar InkWell para interação
  - Implementar Row com ícone de caminhão + conteúdo + seta
  - Adicionar badge "Frete grátis" em verde quando isFree = true
  - Exibir prazo de entrega usando shippingInfo.deliveryRange
  - Mostrar taxa de envio riscada quando frete grátis
  - Adicionar ícone de seta à direita
  - Aplicar padding e espaçamento adequados
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 10.3_



- [ ] 6. Implementar ProductVariantsSection component
  - Criar widget ProductVariantsSection com props (variants, onTap)
  - Implementar Container com fundo branco e border radius 8px
  - Adicionar InkWell para interação
  - Implementar Row com ícone de grid + miniaturas + texto + seta
  - Exibir miniaturas das primeiras 2-3 variações
  - Adicionar texto "X opções disponíveis" onde X = variants.length
  - Adicionar ícone de seta à direita
  - Aplicar padding e espaçamento adequados
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.6_



- [ ] 7. Implementar CustomerProtectionCard component
  - Criar widget CustomerProtectionCard com prop onTap
  - Implementar Container com fundo bege/creme (Color(0xFFFFF8E1)) e border radius 8px
  - Adicionar InkWell para interação
  - Implementar header com Row: ícone escudo dourado + título + seta
  - Criar grid 2x2 para 4 benefícios principais
  - Implementar cada benefício com Row: check verde + texto
  - Aplicar padding 16px
  - Usar cores do tema (dourado para ícones, marrom para texto)


  - Adicionar área de toque mínima de 48x48dp
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 11.3_

- [ ] 8. Implementar CustomerProtectionModal - estrutura base
  - Criar widget CustomerProtectionModal como StatelessWidget
  - Implementar método estático show() usando showModalBottomSheet
  - Configurar modal com isScrollControlled: true e backgroundColor: transparent
  - Criar Container principal com fundo branco e border radius superior 16px
  - Implementar header com título "Proteção do cliente" + ícone escudo + botão fechar
  - Adicionar botão X no canto superior direito que fecha o modal



  - Configurar max height como 90% da altura da tela
  - Adicionar SingleChildScrollView para conteúdo scrollável
  - Implementar animação de slide up/down (300ms, easeInOut)
  - _Requirements: 7.1, 7.2, 9.6, 9.7, 10.5, 10.6, 10.7_

- [ ] 9. Implementar CustomerProtectionModal - seção de pagamento seguro
  - Criar seção "Pagamento seguro" com ícone de carteira dourado
  - Adicionar texto explicativo sobre criptografia e proteção
  - Adicionar texto sobre não compartilhamento de dados com terceiros


  - Implementar texto "Aceitamos pagamento de:"
  - Criar grid de logos de pagamento (Mastercard, Visa, Elo, Amex, Maestro, Boleto, PIX, GPay)
  - Usar assets ou ícones para representar métodos de pagamento
  - Adicionar seção "Certificações de segurança:" com logos
  - Implementar link clicável "Política de privacidade" que abre URL externa
  - Aplicar espaçamento e padding adequados
  - _Requirements: 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 10.8_

- [ ] 10. Implementar CustomerProtectionModal - seções de cupons e reembolsos
  - Criar seção "Cupom por perda ou dano" com ícone de presente dourado
  - Adicionar texto com valor do cupom (R$ 25,00) e condições
  - Criar seção "Cupom por problema de estoque" com mesmo padrão

  - Criar seção "Cupom por atraso na coleta" com mesmo padrão
  - Implementar seção "Reembolso automático por danos" com ícone de cadeado
  - Adicionar texto explicando reembolso automático sem solicitação
  - Criar seção "Reembolso automático por atraso na coleta" com ícone de relógio
  - Adicionar texto especificando prazo de 7 dias úteis
  - Aplicar cores consistentes (dourado para ícones, marrom para títulos)
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7, 8.8, 8.10_

- [x] 11. Refatorar ProductDetailsView para integrar novos componentes


  - Manter estrutura existente (Scaffold, AppBar, CarouselSlider, BottomBar)
  - Adicionar PriceSection logo após o carrossel e indicadores
  - Adicionar PromotionalBanner se product.activePromotion não for null
  - Mover título do produto para depois do banner promocional
  - Adicionar RatingComponent após o título
  - Adicionar ShippingSection após rating
  - Adicionar ProductVariantsSection após shipping
  - Adicionar CustomerProtectionCard após variants
  - Manter descrição do produto no final
  - Aplicar espaçamento vertical de 12-16px entre seções

  - Manter padding horizontal de 16px (exceto carrossel)
  - _Requirements: 9.1, 9.2, 9.3_

- [ ] 12. Implementar callbacks e navegação
  - Implementar onTap do PromotionalBanner para navegar para tela de promoção
  - Implementar onTap do ShippingSection para mostrar modal de opções de frete
  - Implementar onTap do ProductVariantsSection para mostrar modal de variações
  - Implementar onTap do CustomerProtectionCard para abrir CustomerProtectionModal
  - Adicionar feedback visual (ripple) em todos os elementos clicáveis
  - Implementar tratamento de erro para abertura de modais

  - Adicionar logs de debug para rastreamento de interações
  - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6_

- [ ] 13. Adicionar tema e estilos customizados
  - Criar ProductDetailsTheme class com cores definidas
  - Definir discountBadge: Color(0xFFFF4D67)
  - Definir priceHighlight: Color(0xFFFF4D67)
  - Definir freeShippingBadge: Color(0xFF00C853)
  - Definir protectionBackground: Color(0xFFFFF8E1)

  - Definir protectionIcon: Color(0xFFD4AF37)
  - Definir protectionText: Color(0xFF8B4513)
  - Criar ProductDetailsTypography class com estilos de texto
  - Aplicar tema em todos os componentes criados
  - _Requirements: 9.4_

- [ ] 14. Implementar tratamento de erros e casos edge
  - Adicionar verificação para product.originalPrice null (não mostrar preço riscado)
  - Adicionar verificação para product.discountPercentage null (não mostrar badge)
  - Adicionar verificação para product.installmentInfo null (não mostrar parcelamento)


  - Adicionar verificação para product.activePromotion null (não mostrar banner)
  - Adicionar verificação para product.shippingInfo null (não mostrar seção de frete)
  - Adicionar verificação para variants vazios (não mostrar seção de variações)
  - Implementar ErrorHandler.handleModalError para falhas ao abrir modais
  - Adicionar placeholder para imagens que falharem ao carregar
  - _Requirements: 9.4, 9.5_

- [ ] 15. Adicionar otimizações de performance
  - Adicionar RepaintBoundary em PriceSection
  - Adicionar RepaintBoundary em RatingComponent


  - Adicionar RepaintBoundary em CustomerProtectionCard
  - Usar const constructors onde possível em todos os widgets
  - Implementar cache para logos de pagamento no modal
  - Otimizar animação do modal para manter 60 FPS
  - Adicionar lazy loading para conteúdo do modal
  - _Requirements: 12.1, 12.2, 12.3, 12.4_




- [ ] 16. Implementar acessibilidade completa
  - Adicionar Semantics em PriceSection com label de preço formatado
  - Adicionar Semantics em RatingComponent com nota e reviews
  - Adicionar Semantics em PromotionalBanner com hint "Toque para detalhes"
  - Adicionar Semantics em ShippingSection com informações de frete
  - Adicionar Semantics em CustomerProtectionCard com hint "Toque para ver proteções"




  - Verificar contraste de cores (mínimo 4.5:1)
  - Garantir áreas de toque mínimas de 48x48dp
  - Testar com TalkBack/VoiceOver
  - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5_



- [ ] 17. Integrar com White Label
  - Criar CustomerProtectionConfig em ThemeConfig
  - Adicionar campo showProtectionCard (default: true)
  - Adicionar campo couponValue (default: 25.00)


  - Adicionar campo paymentMethods (lista customizável)
  - Adicionar campo privacyPolicyUrl (obrigatório)
  - Usar config para mostrar/ocultar CustomerProtectionCard
  - Usar config.couponValue nas seções de cupom do modal


  - Usar config.paymentMethods para filtrar logos exibidos
  - Usar config.privacyPolicyUrl no link do modal
  - _Requirements: 7.9, 10.8_



- [ ] 18. Criar dados mock para desenvolvimento e testes
  - Criar factory method Product.mock() com todos os novos campos preenchidos




  - Criar ShippingInfo.mock() com frete grátis e prazo de 7 dias
  - Criar Promotion.mock() com promoção "Compre R$ 200 e ganhe R$ 20"
  - Adicionar múltiplas variações ao produto mock
  - Criar cenários de teste: com desconto, sem desconto, com frete grátis, sem frete grátis
  - Usar dados mock na tela de desenvolvimento

  - _Requirements: 1.1, 2.1, 4.1, 5.1_

- [ ] 19. Adicionar dependência intl e configurar localização
  - Adicionar intl: ^0.18.0 ao pubspec.yaml
  - Importar package:intl/intl.dart onde necessário
  - Configurar locale pt_BR para formatação de datas

  - Usar NumberFormat.currency para formatação de preços
  - Usar DateFormat para formatação de prazos de entrega
  - Testar formatação em diferentes locales
  - _Requirements: 1.5, 4.3_

- [ ] 20. Criar testes para componentes
- [ ] 20.1 Escrever widget tests para PriceSection
  - Testar exibição de badge de desconto
  - Testar exibição de preço original riscado
  - Testar exibição de parcelamento
  - Testar formatação de valores
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ] 20.2 Escrever widget tests para RatingComponent
  - Testar exibição de estrela e nota
  - Testar formatação de número de reviews
  - Testar formatação de vendidos
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 20.3 Escrever widget tests para ShippingSection
  - Testar exibição de badge "Frete grátis"
  - Testar taxa riscada quando grátis
  - Testar formatação de prazo
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [ ] 20.4 Escrever widget tests para CustomerProtectionCard
  - Testar exibição de 4 benefícios
  - Testar callback onTap
  - _Requirements: 6.1, 6.4, 6.5, 6.7_

- [ ] 20.5 Escrever widget tests para CustomerProtectionModal
  - Testar abertura e fechamento
  - Testar scroll
  - Testar exibição de todas as seções
  - _Requirements: 7.1, 7.2, 8.9, 9.6_

- [ ] 21. Criar testes de integração
- [ ] 21.1 Testar fluxo completo de visualização do produto
  - Navegar para ProductDetailsView
  - Verificar exibição de todos os componentes
  - Testar scroll da página
  - _Requirements: 9.1, 9.2_

- [ ] 21.2 Testar interação com modal de proteção
  - Tocar em CustomerProtectionCard
  - Verificar abertura do modal
  - Scroll pelo conteúdo do modal
  - Fechar modal
  - _Requirements: 10.5, 10.6, 10.7_

- [ ] 21.3 Testar adição ao carrinho
  - Visualizar produto
  - Selecionar variação
  - Adicionar ao carrinho
  - Verificar navegação de volta
  - _Requirements: 10.1_

---

## Notes

### Ordem de Implementação
As tarefas estão ordenadas para permitir desenvolvimento incremental:
1. Data models primeiro (base para tudo)
2. Componentes simples (Price, Rating)
3. Componentes médios (Banner, Shipping, Variants)
4. Componentes complexos (Protection Card, Modal)
5. Integração na view principal
6. Polimento (tema, erros, performance)
7. Acessibilidade e White Label
8. Testes (opcionais)

### Tarefas de Teste
Todas as tarefas de teste (20-21) são obrigatórias para garantir qualidade e confiabilidade do código.

### Dependências Entre Tarefas
- Tarefa 2-7 dependem da Tarefa 1 (data models)
- Tarefa 8-10 podem ser feitas em paralelo
- Tarefa 11 depende de 2-10 (todos os componentes)
- Tarefa 12 depende de 11 (integração)
- Tarefas 13-17 podem ser feitas em paralelo após 12
- Tarefas 20-21 dependem de todas as anteriores

### Estimativa de Tempo
- Tarefas 1-10: ~4-6 horas
- Tarefas 11-17: ~2-3 horas
- Tarefas 18-19: ~1 hora
- Tarefas 20-21 (testes): ~3-4 horas
- **Total completo: ~10-14 horas**

---

**Última atualização:** 13 de Novembro de 2025
