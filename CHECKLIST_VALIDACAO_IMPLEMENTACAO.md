# ✅ Checklist de Validação de Implementação

Use este prompt após cada implementação para validar se tudo está funcionando:

---

## 📋 PROMPT DE VALIDAÇÃO

```
VALIDAÇÃO DE IMPLEMENTAÇÃO: [Nome da Feature]

Acabei de implementar [descrever brevemente]. Antes de considerar completo, valide:

1. REPOSITÓRIOS
   - Backend está em: https://github.com/italoandres/eshop-backend.git
   - Admin está em: https://github.com/italoandres/eshop-admin-panel-updated.git
   - App Flutter está em: [este workspace]
   
   Confirme que você fez push nos repositórios CORRETOS.

2. DEPLOYS
   - Backend (Render): https://eshop-backend-bfhw.onrender.com
   - Admin (Netlify): https://sunny-lollipop-051661.netlify.app
   
   Confirme que os deploys foram feitos e estão online.

3. TESTE END-TO-END
   Faça um teste completo:
   - [ ] Backend responde corretamente (teste com curl)
   - [ ] Admin salva e carrega dados corretamente
   - [ ] App Flutter exibe corretamente
   
   Cole aqui os logs/resultados dos testes.

4. SINCRONIZAÇÃO
   Verifique se TODOS os arquivos modificados estão sincronizados:
   - [ ] Código local = GitHub
   - [ ] GitHub = Render/Netlify
   - [ ] Banco de dados atualizado (se necessário)

Se QUALQUER item falhar, NÃO considere a implementação completa.
```

---

## 🎯 EXEMPLO DE USO

**Você envia:**
```
VALIDAÇÃO DE IMPLEMENTAÇÃO: Escassez de Marketing

Acabei de implementar a funcionalidade de escassez de marketing. Antes de considerar completo, valide:

1. REPOSITÓRIOS - Confirme push nos corretos
2. DEPLOYS - Confirme que estão online
3. TESTE END-TO-END - Testei no admin e salvou, mas não aparece quando recarrego
4. SINCRONIZAÇÃO - Não tenho certeza se o Render atualizou

Logs do teste:
📤 Enviando: {scarcityMarketing: {enabled: true, unitsLeft: 7}}
✅ Salvo: {scarcityMarketing: undefined}
```

**Eu respondo:**
```
❌ FALHA DETECTADA: Backend retorna undefined

Problema: O código não está no repositório correto do Render.
Solução: Fazer push em https://github.com/italoandres/eshop-backend.git

[Faço o push correto e confirmo]

✅ AGORA SIM: Teste novamente após o deploy.
```

---

## 🚨 REGRAS DE OURO

1. **SEMPRE** teste end-to-end antes de considerar completo
2. **SEMPRE** confirme que o código está nos repositórios corretos
3. **SEMPRE** verifique os logs do console/backend
4. **NUNCA** assuma que funcionou sem testar
5. **NUNCA** considere completo se o teste falhar

---

## 📊 ESTRUTURA DO PROJETO

### Repositórios
```
Backend (Render):
  Repo: https://github.com/italoandres/eshop-backend.git
  Deploy: https://eshop-backend-bfhw.onrender.com
  
Admin Panel (Netlify):
  Repo: https://github.com/italoandres/eshop-admin-panel-updated.git
  Deploy: https://sunny-lollipop-051661.netlify.app
  
App Flutter:
  Local: /ecommerce_app
  Repo: [mesmo do admin panel]
```

### Fluxo de Deploy
```
1. Modifico código local
2. Commit + Push para GitHub correto
3. Deploy automático OU manual
4. Teste end-to-end
5. ✅ Só então considero completo
```

---

## 🧪 COMANDOS DE TESTE RÁPIDO

### Testar Backend
```bash
# Health check
curl https://eshop-backend-bfhw.onrender.com/health

# Testar produto específico
curl https://eshop-backend-bfhw.onrender.com/api/products/[ID] | jq '.scarcityMarketing'
```

### Testar Admin
```
1. Abrir: https://sunny-lollipop-051661.netlify.app
2. F12 → Console
3. Editar produto
4. Verificar logs: 📤 Enviando e ✅ Salvo
5. Recarregar e verificar se mantém
```

### Testar App Flutter
```
1. Hot reload (R)
2. Navegar até produto
3. Verificar se exibe corretamente
4. Verificar logs do console
```

---

## 📝 TEMPLATE DE RESPOSTA

Quando você me enviar o prompt de validação, eu vou responder assim:

```
🔍 VALIDANDO IMPLEMENTAÇÃO...

✅ Repositórios: Código nos repos corretos
✅ Deploys: Backend e Admin online
❌ Teste E2E: [Descrever problema encontrado]
⚠️  Sincronização: [Status]

AÇÃO NECESSÁRIA:
[O que precisa ser feito]

STATUS: ❌ NÃO COMPLETO / ✅ COMPLETO
```

---

**Criado em:** 26/01/2025  
**Objetivo:** Evitar perder 4 horas debugando problemas de sincronização  
**Uso:** Após CADA implementação, antes de considerar completo
