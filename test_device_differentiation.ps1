# Script de teste de diferenciação de dispositivos
# SISP360 - Sistema de Notificações em Tempo Real

$API_URL = "http://localhost:4000/api/v1/notifications"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  TESTE DE DIFERENCIAÇÃO DE DISPOSITIVOS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Teste 1: Notificação para TODOS os dispositivos
Write-Host "📢 Teste 1: Notificação para TODOS os dispositivos" -ForegroundColor Yellow
Write-Host "-------------------------------------------"
$body1 = @{
    type = "teste_geral"
    title = "Notificação Geral"
    message = "Esta mensagem deve aparecer em TODOS os dispositivos (web, mobile, tablet)"
    data = @{ test = "geral" }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$API_URL/broadcast" -Method Post -Body $body1 -ContentType "application/json" | ConvertTo-Json
Write-Host ""
Write-Host ""

Start-Sleep -Seconds 2

# Teste 2: Notificação APENAS para WEB
Write-Host "🖥️  Teste 2: Notificação APENAS para WEB" -ForegroundColor Yellow
Write-Host "-------------------------------------------"
$body2 = @{
    type = "teste_web"
    title = "Notificação para Web"
    message = "✅ Esta mensagem deve aparecer APENAS no COMPUTADOR (Web)"
    device_types = @("web")
    data = @{ test = "web_only" }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$API_URL/broadcast" -Method Post -Body $body2 -ContentType "application/json" | ConvertTo-Json
Write-Host ""
Write-Host ""

Start-Sleep -Seconds 2

# Teste 3: Notificação APENAS para MOBILE
Write-Host "📱 Teste 3: Notificação APENAS para MOBILE" -ForegroundColor Yellow
Write-Host "-------------------------------------------"
$body3 = @{
    type = "teste_mobile"
    title = "Notificação para Mobile"
    message = "✅ Esta mensagem deve aparecer APENAS no CELULAR (Mobile)"
    device_types = @("mobile")
    data = @{ test = "mobile_only" }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$API_URL/broadcast" -Method Post -Body $body3 -ContentType "application/json" | ConvertTo-Json
Write-Host ""
Write-Host ""

Start-Sleep -Seconds 2

# Teste 4: Notificação para WEB e MOBILE (excluindo tablet)
Write-Host "🖥️ 📱 Teste 4: Notificação para WEB e MOBILE" -ForegroundColor Yellow
Write-Host "-------------------------------------------"
$body4 = @{
    type = "teste_web_mobile"
    title = "Notificação para Web e Mobile"
    message = "✅ Esta mensagem deve aparecer no COMPUTADOR e CELULAR (não em tablet)"
    device_types = @("web", "mobile")
    data = @{ test = "web_and_mobile" }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$API_URL/broadcast" -Method Post -Body $body4 -ContentType "application/json" | ConvertTo-Json
Write-Host ""
Write-Host ""

Start-Sleep -Seconds 2

# Teste 5: Notificação APENAS para TABLET
Write-Host "📲 Teste 5: Notificação APENAS para TABLET" -ForegroundColor Yellow
Write-Host "-------------------------------------------"
$body5 = @{
    type = "teste_tablet"
    title = "Notificação para Tablet"
    message = "✅ Esta mensagem deve aparecer APENAS no TABLET"
    device_types = @("tablet")
    data = @{ test = "tablet_only" }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$API_URL/broadcast" -Method Post -Body $body5 -ContentType "application/json" | ConvertTo-Json
Write-Host ""
Write-Host ""

Write-Host "=========================================" -ForegroundColor Green
Write-Host "  ✅ TESTES CONCLUÍDOS!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Resumo dos testes:" -ForegroundColor White
Write-Host "  1. Notificação geral (todos os dispositivos)"
Write-Host "  2. Notificação apenas para WEB (computador)"
Write-Host "  3. Notificação apenas para MOBILE (celular)"
Write-Host "  4. Notificação para WEB + MOBILE"
Write-Host "  5. Notificação apenas para TABLET"
Write-Host ""
Write-Host "💡 Dica: Abra http://localhost:4000/test-notifications.html" -ForegroundColor Cyan
Write-Host "   em diferentes dispositivos e observe as notificações!" -ForegroundColor Cyan
Write-Host ""
