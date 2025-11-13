# Requirements Document - Product Details Page

## Introduction

Esta especificação define os requisitos para a tela de detalhes do produto no aplicativo EShop. A tela deve apresentar informações completas sobre o produto, incluindo preço, descontos, opções de frete, variações disponíveis e proteções ao cliente, seguindo o padrão visual de e-commerce moderno similar ao TikTok Shop e Shopee.

## Glossary

- **Product Details Screen**: Tela que exibe informações detalhadas de um produto específico
- **Price Section**: Seção que mostra preço atual, desconto e parcelamento
- **Shipping Section**: Seção que exibe informações de frete e prazo de entrega
- **Customer Protection Modal**: Modal que detalha as garantias e proteções oferecidas ao cliente
- **Product Variants**: Diferentes opções disponíveis do mesmo produto (cor, tamanho, etc.)
- **Promotional Banner**: Banner clicável que exibe promoções especiais
- **Rating Component**: Componente que exibe avaliação em estrelas e número de avaliações
- **Payment Methods Grid**: Grid que exibe os métodos de pagamento aceitos
- **Benefit Card**: Card que exibe um benefício específico da proteção ao cliente

---

## Requirements

### Requirement 1: Exibição de Preço e Desconto

**User Story:** Como um usuário do app, eu quero ver claramente o preço do produto com desconto destacado, para que eu possa identificar rapidamente a economia que estou fazendo.

#### Acceptance Criteria

1. WHEN o produto possui desconto, THE Product Details Screen SHALL exibir um badge com a porcentagem de desconto em cor vermelha/rosa no canto superior esquerdo da seção de preço
2. THE Product Details Screen SHALL exibir o preço atual em fonte grande (mínimo 28sp) e cor vermelha/rosa destacada
3. WHEN o produto possui desconto, THE Product Details Screen SHALL exibir o preço original riscado em fonte menor e cor cinza ao lado do preço atual
4. WHEN o produto permite parcelamento, THE Product Details Screen SHALL exibir a opção de parcelamento com ícone de cartão, número de parcelas e valor de cada parcela
5. THE Product Details Screen SHALL exibir todos os valores monetários no formato brasileiro (R$ XX,XX)

---

### Requirement 2: Banner Promocional

**User Story:** Como um usuário do app, eu quero ver promoções especiais disponíveis, para que eu possa aproveitar ofertas adicionais.

#### Acceptance Criteria

1. WHEN existe uma promoção ativa, THE Product Details Screen SHALL exibir um banner promocional com fundo rosa claro abaixo da seção de preço
2. THE Promotional Banner SHALL exibir um ícone de presente à esquerda do texto
3. THE Promotional Banner SHALL exibir o texto da promoção de forma clara e legível
4. WHEN o usuário toca no banner promocional, THE Product Details Screen SHALL exibir detalhes completos da promoção
5. THE Promotional Banner SHALL ter um ícone de seta à direita indicando que é clicável

---

### Requirement 3: Informações do Produto

**User Story:** Como um usuário do app, eu quero ver informações essenciais do produto (título, avaliações, vendas), para que eu possa avaliar a qualidade e popularidade do produto.

#### Acceptance Criteria

1. THE Product Details Screen SHALL exibir o título completo do produto com no máximo 3 linhas, truncando com reticências se necessário
2. THE Product Details Screen SHALL exibir a avaliação média do produto com ícone de estrela amarela e nota numérica
3. THE Rating Component SHALL exibir o número total de avaliações entre parênteses ao lado da nota
4. THE Product Details Screen SHALL exibir o número total de produtos vendidos em texto cinza
5. THE Product Details Screen SHALL separar visualmente a nota e o número de vendidos com um separador vertical (|)

---

### Requirement 4: Informações de Frete

**User Story:** Como um usuário do app, eu quero ver claramente as opções de frete e prazo de entrega, para que eu possa planejar quando receberei o produto.

#### Acceptance Criteria

1. THE Shipping Section SHALL exibir um ícone de caminhão à esquerda das informações de frete
2. WHEN o frete é gratuito, THE Shipping Section SHALL exibir um badge "Frete grátis" em cor verde
3. THE Shipping Section SHALL exibir o prazo de entrega estimado no formato "Receba até DD-DD de MMM"
4. WHEN existe taxa de envio, THE Shipping Section SHALL exibir o valor da taxa em texto cinza
5. WHEN o frete é gratuito, THE Shipping Section SHALL exibir o valor da taxa riscado indicando economia
6. THE Shipping Section SHALL ter um ícone de seta à direita indicando que é clicável para mais detalhes
7. WHEN o usuário toca na seção de frete, THE Product Details Screen SHALL exibir opções detalhadas de envio

---

### Requirement 5: Variações do Produto

**User Story:** Como um usuário do app, eu quero ver as diferentes opções disponíveis do produto, para que eu possa escolher a variação que prefiro.

#### Acceptance Criteria

1. WHEN o produto possui variações, THE Product Details Screen SHALL exibir uma seção de variações com ícone de grid
2. THE Product Variants Section SHALL exibir miniaturas das primeiras 2-3 variações disponíveis
3. THE Product Variants Section SHALL exibir o texto "X opções disponíveis" onde X é o número total de variações
4. THE Product Variants Section SHALL ter um ícone de seta à direita indicando que é clicável
5. WHEN o usuário toca na seção de variações, THE Product Details Screen SHALL exibir um modal ou tela com todas as variações disponíveis
6. THE Product Variants Section SHALL ter fundo branco e bordas arredondadas

---

### Requirement 6: Card de Proteção do Cliente

**User Story:** Como um usuário do app, eu quero ver rapidamente as proteções oferecidas, para que eu me sinta seguro ao fazer a compra.

#### Acceptance Criteria

1. THE Product Details Screen SHALL exibir um card "Proteção do cliente" com fundo bege/creme claro
2. THE Customer Protection Card SHALL exibir um ícone de escudo dourado à esquerda do título
3. THE Customer Protection Card SHALL exibir o título "Proteção do cliente" em cor marrom/dourada
4. THE Customer Protection Card SHALL exibir 4 benefícios principais em formato de grid 2x2
5. THE Benefit Card SHALL exibir cada benefício com um ícone de check (✓) verde à esquerda
6. THE Customer Protection Card SHALL ter um ícone de seta à direita indicando que é clicável
7. WHEN o usuário toca no card de proteção, THE Product Details Screen SHALL abrir o modal de proteção do cliente
8. THE Customer Protection Card SHALL ter bordas arredondadas e padding adequado

---

### Requirement 7: Modal de Proteção do Cliente - Pagamento Seguro

**User Story:** Como um usuário do app, eu quero ver detalhes sobre a segurança do pagamento, para que eu confie em fornecer meus dados de pagamento.

#### Acceptance Criteria

1. WHEN o usuário abre o modal de proteção, THE Customer Protection Modal SHALL exibir um cabeçalho com título "Proteção do cliente" e ícone de escudo
2. THE Customer Protection Modal SHALL ter um botão de fechar (X) no canto superior direito
3. THE Customer Protection Modal SHALL exibir uma seção "Pagamento seguro" com ícone de carteira dourado
4. THE Payment Security Section SHALL exibir texto explicativo sobre criptografia e proteção de dados
5. THE Payment Security Section SHALL exibir texto sobre política de não compartilhamento de dados
6. THE Customer Protection Modal SHALL exibir o texto "Aceitamos pagamento de:" seguido de logos dos métodos de pagamento
7. THE Payment Methods Grid SHALL exibir logos de: Mastercard, Visa, Elo, American Express, Maestro, Boleto, PIX e Google Pay
8. THE Customer Protection Modal SHALL exibir uma seção "Certificações de segurança:" com logos de certificações
9. THE Customer Protection Modal SHALL exibir um link clicável para a "Política de privacidade"

---

### Requirement 8: Modal de Proteção do Cliente - Cupons e Garantias

**User Story:** Como um usuário do app, eu quero entender todas as garantias e compensações oferecidas, para que eu me sinta protegido contra problemas.

#### Acceptance Criteria

1. THE Customer Protection Modal SHALL exibir uma seção "Cupom por perda ou dano" com ícone de presente dourado
2. THE Coupon Section SHALL exibir o valor do cupom (R$ 25,00) e condições de uso
3. THE Customer Protection Modal SHALL exibir uma seção "Cupom por problema de estoque" com ícone de presente dourado
4. THE Customer Protection Modal SHALL exibir uma seção "Cupom por atraso na coleta" com ícone de presente dourado
5. THE Customer Protection Modal SHALL exibir uma seção "Reembolso automático por danos" com ícone de cadeado dourado
6. THE Refund Section SHALL explicar que o reembolso é automático sem necessidade de solicitação
7. THE Customer Protection Modal SHALL exibir uma seção "Reembolso automático por atraso na coleta" com ícone de relógio dourado
8. THE Refund Section SHALL especificar o prazo de 7 dias úteis para reembolso automático
9. THE Customer Protection Modal SHALL permitir scroll vertical para visualizar todo o conteúdo
10. THE Customer Protection Modal SHALL ter fundo branco e texto em cor marrom/dourada para títulos

---

### Requirement 9: Responsividade e Layout

**User Story:** Como um usuário do app, eu quero que a tela se adapte ao meu dispositivo, para que eu tenha uma boa experiência em qualquer tamanho de tela.

#### Acceptance Criteria

1. THE Product Details Screen SHALL ser scrollável verticalmente para acomodar todo o conteúdo
2. THE Product Details Screen SHALL manter padding horizontal de 16px em todos os componentes
3. THE Product Details Screen SHALL usar espaçamento vertical de 12-16px entre seções
4. THE Product Details Screen SHALL adaptar o tamanho das fontes proporcionalmente ao tamanho da tela
5. THE Product Details Screen SHALL manter proporções adequadas de imagens em diferentes resoluções
6. THE Customer Protection Modal SHALL ocupar no máximo 90% da altura da tela
7. THE Customer Protection Modal SHALL ter bordas arredondadas superiores de 16px

---

### Requirement 10: Interações e Navegação

**User Story:** Como um usuário do app, eu quero interagir facilmente com os elementos da tela, para que eu possa acessar informações detalhadas quando necessário.

#### Acceptance Criteria

1. WHEN o usuário toca em qualquer seção com ícone de seta, THE Product Details Screen SHALL fornecer feedback visual (ripple effect)
2. WHEN o usuário toca no banner promocional, THE Product Details Screen SHALL navegar para a tela de detalhes da promoção
3. WHEN o usuário toca na seção de frete, THE Product Details Screen SHALL exibir um modal com opções detalhadas de envio
4. WHEN o usuário toca na seção de variações, THE Product Details Screen SHALL exibir um modal com todas as variações disponíveis
5. WHEN o usuário toca no card de proteção do cliente, THE Product Details Screen SHALL abrir o modal de proteção com animação suave (slide up)
6. WHEN o usuário toca no botão de fechar do modal, THE Customer Protection Modal SHALL fechar com animação suave (slide down)
7. WHEN o usuário toca fora do modal, THE Customer Protection Modal SHALL fechar
8. WHEN o usuário toca no link da política de privacidade, THE Customer Protection Modal SHALL abrir a política em um navegador ou webview

---

### Requirement 11: Acessibilidade

**User Story:** Como um usuário com necessidades especiais, eu quero que a tela seja acessível, para que eu possa usar o app independentemente das minhas limitações.

#### Acceptance Criteria

1. THE Product Details Screen SHALL fornecer labels semânticos para leitores de tela em todos os elementos interativos
2. THE Product Details Screen SHALL manter contraste mínimo de 4.5:1 entre texto e fundo
3. THE Product Details Screen SHALL ter áreas de toque mínimas de 48x48dp para todos os elementos clicáveis
4. THE Rating Component SHALL anunciar a nota e número de avaliações para leitores de tela
5. THE Customer Protection Modal SHALL anunciar o título e permitir navegação sequencial pelo conteúdo

---

### Requirement 12: Performance e Otimização

**User Story:** Como um usuário do app, eu quero que a tela carregue rapidamente, para que eu não perca tempo esperando.

#### Acceptance Criteria

1. THE Product Details Screen SHALL carregar e exibir informações básicas do produto em menos de 2 segundos
2. THE Product Details Screen SHALL usar cache para logos de pagamento e certificações
3. THE Product Details Screen SHALL carregar imagens de forma assíncrona sem bloquear a UI
4. THE Customer Protection Modal SHALL abrir em menos de 300ms após o toque
5. THE Product Details Screen SHALL usar RepaintBoundary em componentes que não mudam frequentemente

---

## Non-Functional Requirements

### Usabilidade
- A interface deve seguir as diretrizes de Material Design 3
- Cores e tipografia devem ser consistentes com o tema do app
- Animações devem ser suaves (60 FPS)

### Compatibilidade
- Suporte para Android 5.0+ (API 21+)
- Suporte para iOS 11+
- Funcionar em telas de 4" a 7"

### Segurança
- Links externos devem abrir em navegador seguro
- Dados sensíveis não devem ser logados

### Manutenibilidade
- Código deve seguir Clean Architecture
- Componentes devem ser reutilizáveis
- Testes unitários para lógica de negócio

---

**Última atualização:** 13 de Novembro de 2025
