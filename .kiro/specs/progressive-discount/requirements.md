# Requirements Document - Progressive Discount System

## Introduction

Este documento define os requisitos para o sistema de Desconto Progressivo no EShop. O sistema permite que lojistas criem promoções onde o desconto aumenta conforme a quantidade de produtos adicionados ao carrinho, incentivando compras maiores e aumentando a conversão.

## Glossary

- **Progressive Discount**: Sistema de desconto que aumenta conforme quantidade no carrinho
- **Discount Tier**: Nível de desconto (ex: 1 produto = 25%, 2 produtos = 40%)
- **Discount Rule**: Regra completa com múltiplos tiers para um produto
- **Active Tier**: Tier atual baseado na quantidade no carrinho
- **Next Tier**: Próximo nível de desconto disponível
- **Incentive Banner**: Banner que mostra desconto atual e incentiva próximo nível
- **Admin Panel**: Interface para gerenciar regras de desconto
- **Cart Quantity**: Quantidade total do produto no carrinho

---

## Requirements

### Requirement 1: Criação de Regras de Desconto Progressivo

**User Story:** Como um lojista, eu quero criar regras de desconto progressivo para produtos específicos, para que eu possa incentivar compras em maior quantidade.

#### Acceptance Criteria

1. THE Admin Panel SHALL permitir criar uma nova regra de desconto progressivo
2. WHEN criando uma regra, THE Admin Panel SHALL solicitar seleção do produto alvo
3. THE Admin Panel SHALL permitir adicionar múltiplos tiers de desconto (mínimo 2, máximo 10)
4. FOR each tier, THE Admin Panel SHALL solicitar quantidade mínima e porcentagem de desconto
5. THE Admin Panel SHALL validar que porcentagens de desconto aumentam progressivamente
6. THE Admin Panel SHALL validar que quantidades mínimas são únicas e crescentes
7. THE Admin Panel SHALL permitir ativar/desativar regras sem deletá-las
8. THE Admin Panel SHALL permitir agendar início e fim da promoção
9. WHEN salvando, THE Admin Panel SHALL validar todos os campos obrigatórios
10. THE Admin Panel SHALL exibir preview visual da regra antes de salvar

---

### Requirement 2: Visualização de Regras no Admin Panel

**User Story:** Como um lojista, eu quero visualizar todas as regras de desconto criadas, para que eu possa gerenciar minhas promoções facilmente.

#### Acceptance Criteria

1. THE Admin Panel SHALL exibir lista de todas as regras de desconto progressivo
2. FOR each rule, THE Admin Panel SHALL mostrar: produto, status (ativa/inativa), número de tiers, data de criação
3. THE Admin Panel SHALL permitir filtrar regras por status (ativas/inativas/todas)
4. THE Admin Panel SHALL permitir buscar regras por nome do produto
5. THE Admin Panel SHALL ordenar regras por data de criação (mais recentes primeiro)
6. THE Admin Panel SHALL exibir badge visual indicando status da regra
7. WHEN uma regra está agendada, THE Admin Panel SHALL mostrar data de início/fim
8. THE Admin Panel SHALL permitir ações rápidas: editar, ativar/desativar, deletar
9. THE Admin Panel SHALL solicitar confirmação antes de deletar uma regra
10. THE Admin Panel SHALL exibir mensagem de sucesso após operações

---

### Requirement 3: Edição de Regras Existentes

**User Story:** Como um lojista, eu quero editar regras de desconto existentes, para que eu possa ajustar promoções conforme necessário.

#### Acceptance Criteria

1. THE Admin Panel SHALL permitir editar qualquer regra existente
2. WHEN editando, THE Admin Panel SHALL pré-preencher formulário com dados atuais
3. THE Admin Panel SHALL permitir adicionar novos tiers à regra
4. THE Admin Panel SHALL permitir remover tiers existentes (mínimo 2 tiers)
5. THE Admin Panel SHALL permitir modificar porcentagens e quantidades
6. THE Admin Panel SHALL revalidar regra após modificações
7. THE Admin Panel SHALL manter histórico de alterações (audit log)
8. WHEN salvando edições, THE Admin Panel SHALL atualizar regra no backend
9. THE Admin Panel SHALL exibir preview das mudanças antes de salvar
10. THE Admin Panel SHALL permitir cancelar edições sem salvar

---

### Requirement 4: Cálculo Automático de Desconto

**User Story:** Como um sistema, eu preciso calcular automaticamente o desconto aplicável, para que o preço correto seja exibido ao usuário.

#### Acceptance Criteria

1. THE Backend SHALL calcular desconto baseado na quantidade no carrinho
2. WHEN quantidade muda, THE Backend SHALL recalcular desconto automaticamente
3. THE Backend SHALL aplicar o tier mais alto elegível
4. THE Backend SHALL considerar apenas regras ativas
5. WHEN múltiplas regras aplicáveis, THE Backend SHALL aplicar a mais vantajosa
6. THE Backend SHALL validar datas de início/fim da promoção
7. THE Backend SHALL retornar: desconto aplicado, tier atual, próximo tier disponível
8. THE Backend SHALL calcular economia total em R$
9. THE Backend SHALL arredondar valores para 2 casas decimais
10. THE Backend SHALL logar erros de cálculo para debugging

---

### Requirement 5: Exibição de Banner Dinâmico no App

**User Story:** Como um usuário do app, eu quero ver claramente o desconto atual e o incentivo para adicionar mais produtos, para que eu entenda os benefícios de comprar mais.

#### Acceptance Criteria

1. THE App SHALL exibir banner de desconto progressivo quando regra ativa existe
2. THE Banner SHALL mostrar desconto atual aplicado (ex: "-25%")
3. WHEN próximo tier disponível, THE Banner SHALL exibir mensagem incentivando adição
4. THE Banner SHALL mostrar quantidade necessária para próximo tier
5. THE Banner SHALL exibir desconto do próximo tier
6. WHEN tier máximo atingido, THE Banner SHALL exibir mensagem de parabéns
7. THE Banner SHALL usar cores progressivas (verde → amarelo → vermelho)
8. THE Banner SHALL ter ícone de presente ou troféu
9. THE Banner SHALL ser clicável para mostrar detalhes completos
10. THE Banner SHALL atualizar em tempo real quando quantidade muda

---

### Requirement 6: Modal de Detalhes da Promoção

**User Story:** Como um usuário do app, eu quero ver todos os níveis de desconto disponíveis, para que eu possa planejar minha compra.

#### Acceptance Criteria

1. WHEN usuário toca no banner, THE App SHALL abrir modal com detalhes completos
2. THE Modal SHALL listar todos os tiers de desconto
3. FOR each tier, THE Modal SHALL mostrar: quantidade, desconto, economia em R$
4. THE Modal SHALL destacar tier atual do usuário
5. THE Modal SHALL mostrar barra de progresso visual
6. THE Modal SHALL calcular e exibir economia potencial
7. THE Modal SHALL ter botão "Adicionar ao Carrinho" para cada tier
8. THE Modal SHALL ter design atrativo e persuasivo
9. THE Modal SHALL ter botão de fechar no topo
10. THE Modal SHALL ter animação suave ao abrir/fechar

---

### Requirement 7: Atualização em Tempo Real

**User Story:** Como um usuário do app, eu quero que o desconto atualize automaticamente quando adiciono produtos, para que eu veja imediatamente os benefícios.

#### Acceptance Criteria

1. WHEN usuário adiciona produto ao carrinho, THE App SHALL atualizar banner imediatamente
2. THE App SHALL animar transição entre tiers
3. THE App SHALL exibir notificação quando novo tier é atingido
4. THE App SHALL atualizar preço exibido automaticamente
5. THE App SHALL recalcular economia total
6. THE App SHALL sincronizar com backend em background
7. WHEN erro de sincronização, THE App SHALL usar último valor conhecido
8. THE App SHALL exibir loading state durante cálculo
9. THE App SHALL manter estado consistente entre telas
10. THE App SHALL persistir estado localmente para performance

---

### Requirement 8: API Backend para Regras de Desconto

**User Story:** Como um desenvolvedor, eu preciso de APIs para gerenciar regras de desconto, para que o admin panel e app possam funcionar corretamente.

#### Acceptance Criteria

1. THE Backend SHALL expor endpoint POST /api/discount-rules para criar regra
2. THE Backend SHALL expor endpoint GET /api/discount-rules para listar regras
3. THE Backend SHALL expor endpoint GET /api/discount-rules/:id para obter regra específica
4. THE Backend SHALL expor endpoint PUT /api/discount-rules/:id para atualizar regra
5. THE Backend SHALL expor endpoint DELETE /api/discount-rules/:id para deletar regra
6. THE Backend SHALL expor endpoint GET /api/discount-rules/product/:productId para regras de produto
7. THE Backend SHALL expor endpoint POST /api/discount-rules/calculate para calcular desconto
8. THE Backend SHALL validar autenticação em todos os endpoints
9. THE Backend SHALL validar permissões (apenas admin pode criar/editar)
10. THE Backend SHALL retornar erros padronizados com códigos HTTP apropriados

---

### Requirement 9: Validações e Regras de Negócio

**User Story:** Como um sistema, eu preciso validar dados para garantir integridade, para que promoções funcionem corretamente.

#### Acceptance Criteria

1. THE System SHALL validar que porcentagens estão entre 1% e 99%
2. THE System SHALL validar que quantidades são números inteiros positivos
3. THE System SHALL validar que tiers não se sobrepõem
4. THE System SHALL validar que produto existe antes de criar regra
5. THE System SHALL validar que datas de início são anteriores a datas de fim
6. THE System SHALL impedir múltiplas regras ativas para mesmo produto
7. THE System SHALL validar que tier máximo tem desconto maior que mínimo
8. THE System SHALL validar formato de dados em todas as requisições
9. THE System SHALL sanitizar inputs para prevenir injeção
10. THE System SHALL logar todas as validações falhadas

---

### Requirement 10: Performance e Otimização

**User Story:** Como um usuário, eu quero que o sistema seja rápido, para que eu tenha uma boa experiência.

#### Acceptance Criteria

1. THE Backend SHALL responder cálculos de desconto em menos de 100ms
2. THE Backend SHALL cachear regras ativas em memória
3. THE Backend SHALL invalidar cache quando regras mudam
4. THE App SHALL cachear regras localmente por 5 minutos
5. THE App SHALL fazer cálculos locais quando possível
6. THE App SHALL sincronizar com backend apenas quando necessário
7. THE Admin Panel SHALL carregar lista de regras em menos de 1 segundo
8. THE Admin Panel SHALL usar paginação para listas grandes (>50 itens)
9. THE System SHALL usar índices de banco de dados apropriados
10. THE System SHALL monitorar performance e logar operações lentas

---

### Requirement 11: Analytics e Relatórios

**User Story:** Como um lojista, eu quero ver estatísticas das promoções, para que eu possa avaliar efetividade.

#### Acceptance Criteria

1. THE System SHALL rastrear quantas vezes cada tier foi atingido
2. THE System SHALL rastrear conversões atribuídas à promoção
3. THE System SHALL calcular receita adicional gerada
4. THE System SHALL rastrear taxa de abandono por tier
5. THE Admin Panel SHALL exibir dashboard com métricas principais
6. THE Admin Panel SHALL permitir exportar relatórios em CSV
7. THE Admin Panel SHALL mostrar gráficos de performance
8. THE System SHALL comparar períodos (antes/durante promoção)
9. THE System SHALL calcular ROI da promoção
10. THE System SHALL enviar relatórios automáticos por email (opcional)

---

### Requirement 12: Acessibilidade e UX

**User Story:** Como um usuário com necessidades especiais, eu quero que o sistema seja acessível, para que eu possa usar todas as funcionalidades.

#### Acceptance Criteria

1. THE Banner SHALL ter labels semânticos para leitores de tela
2. THE Banner SHALL ter contraste mínimo de 4.5:1
3. THE Banner SHALL ter área de toque mínima de 48x48dp
4. THE Modal SHALL ser navegável por teclado
5. THE Modal SHALL anunciar mudanças de tier para leitores de tela
6. THE Admin Panel SHALL ter formulários acessíveis
7. THE Admin Panel SHALL ter mensagens de erro claras
8. THE System SHALL usar linguagem simples e direta
9. THE System SHALL fornecer feedback visual para todas as ações
10. THE System SHALL funcionar em modo escuro (dark mode)

---

## Non-Functional Requirements

### Segurança
- Apenas administradores podem criar/editar regras
- Validação de inputs em frontend e backend
- Proteção contra manipulação de preços
- Audit log de todas as operações

### Escalabilidade
- Suportar 1000+ regras ativas
- Suportar 10000+ cálculos por minuto
- Cache distribuído para alta disponibilidade
- Banco de dados otimizado com índices

### Manutenibilidade
- Código documentado e testado
- Logs estruturados para debugging
- Monitoramento de erros
- Versionamento de API

---

**Última atualização:** 13 de Novembro de 2025
