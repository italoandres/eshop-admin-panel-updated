# Script de Reorganização para Monorepo
# Execute este script no PowerShell: .\reorganizar-monorepo.ps1

Write-Host "🚀 Iniciando reorganização para monorepo..." -ForegroundColor Green

# 1. Remover lock do Git se existir
Write-Host "`n1️⃣ Removendo locks do Git..." -ForegroundColor Yellow
Remove-Item -Path ".git/index.lock" -Force -ErrorAction SilentlyContinue
Write-Host "✅ Locks removidos" -ForegroundColor Green

# 2. Deletar pastas antigas
Write-Host "`n2️⃣ Deletando pastas antigas..." -ForegroundColor Yellow
$pastasAntigas = @(
    "eshop-admin-panel-main",
    "eshop-backend-temp",
    "eshop-backend-render",
    "test-clone",
    "admin-panel-clean"
)

foreach ($pasta in $pastasAntigas) {
    if (Test-Path $pasta) {
        Write-Host "  Deletando $pasta..." -ForegroundColor Gray
        Remove-Item -Path $pasta -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Write-Host "✅ Pastas antigas deletadas" -ForegroundColor Green

# 3. Adicionar arquivos novos ao Git
Write-Host "`n3️⃣ Adicionando arquivos ao Git..." -ForegroundColor Yellow
git add admin/
git add backend/render.yaml
git add .gitignore
git add README.md
git add GUIA_REORGANIZACAO_MONOREPO.md
Write-Host "✅ Arquivos adicionados" -ForegroundColor Green

# 4. Fazer commit
Write-Host "`n4️⃣ Fazendo commit..." -ForegroundColor Yellow
git commit -m "refactor: reorganize to monorepo structure"
Write-Host "✅ Commit realizado" -ForegroundColor Green

# 5. Push para o repositório
Write-Host "`n5️⃣ Fazendo push..." -ForegroundColor Yellow
git push origin main
Write-Host "✅ Push realizado" -ForegroundColor Green

Write-Host "`n🎉 REORGANIZAÇÃO COMPLETA!" -ForegroundColor Green
Write-Host "`n📋 PRÓXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host "`n1️⃣ NETLIFY - Atualizar Base Directory:" -ForegroundColor Yellow
Write-Host "   https://app.netlify.com/sites/sunny-lollipop-051661/settings/deploys" -ForegroundColor Gray
Write-Host "   Base directory: admin" -ForegroundColor White
Write-Host "   Build command: npm install && npm run build" -ForegroundColor White
Write-Host "   Publish directory: admin/dist" -ForegroundColor White

Write-Host "`n2️⃣ RENDER - Trocar Repositório e Root Directory:" -ForegroundColor Yellow
Write-Host "   https://dashboard.render.com/web/srv-d4ceb2a4d50c73d57gj0" -ForegroundColor Gray
Write-Host "   Settings → Build & Deploy → Connect Repository" -ForegroundColor White
Write-Host "   Repositório: eshop-admin-panel-updated" -ForegroundColor White
Write-Host "   Root Directory: backend" -ForegroundColor White
Write-Host "   Build Command: npm install" -ForegroundColor White
Write-Host "   Start Command: node server.js" -ForegroundColor White

Write-Host "`n3️⃣ Fazer deploy manual no Netlify" -ForegroundColor Yellow
Write-Host "`n✅ Depois disso, um único 'git push origin main' atualiza TUDO!" -ForegroundColor Green
Write-Host "`nLeia o arquivo GUIA_REORGANIZACAO_MONOREPO.md para mais detalhes!" -ForegroundColor Cyan
