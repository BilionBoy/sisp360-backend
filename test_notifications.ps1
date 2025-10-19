# Script PowerShell para testes de notificações SISP360
# Uso: .\test_notifications.ps1

$API_URL = "http://localhost:4000"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  SISP360 - Testes de Notificações   " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Teste 1: Status do Action Cable
Write-Host "[1] Verificando status do Action Cable..." -ForegroundColor Blue
try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/v1/notifications/status" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 2: Enviar notificação de teste
Write-Host "[2] Enviando notificação de teste..." -ForegroundColor Blue
try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/v1/notifications/test" -Method Post
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 3: Broadcast customizado
Write-Host "[3] Enviando broadcast customizado..." -ForegroundColor Blue
$broadcastBody = @{
    type = "alerta"
    title = "Alerta de Teste via PowerShell"
    message = "Esta é uma notificação de teste enviada via script PowerShell"
    data = @{
        source = "powershell_script"
        priority = "high"
    }
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/v1/notifications/broadcast" `
        -Method Post `
        -ContentType "application/json" `
        -Body $broadcastBody
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 4: Notificação de sistema
Write-Host "[4] Enviando notificação de sistema (warning)..." -ForegroundColor Blue
$sistemaBody = @{
    message = "Sistema em manutenção programada para 22h"
    level = "warning"
    data = @{
        scheduled_time = "22:00:00"
    }
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/v1/notifications/sistema" `
        -Method Post `
        -ContentType "application/json" `
        -Body $sistemaBody
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 5: Criar ocorrência (dispara notificação automática)
Write-Host "[5] Criando ocorrência de teste (notificação automática)..." -ForegroundColor Blue
$timestamp = [int][double]::Parse((Get-Date -UFormat %s))
$currentDate = Get-Date -Format "yyyy-MM-dd"
$currentTime = Get-Date -Format "HH:mm:ss"

$ocorrenciaBody = @{
    ocorrencia = @{
        numero_bo = "BO-TEST-$timestamp"
        id_tipo_crime = 1
        id_bairro = 1
        data_ocorrencia = $currentDate
        hora_ocorrencia = $currentTime
        status_ocorrencia = "Pendente"
        descricao_ocorrencia = "Ocorrência de teste criada via script PowerShell"
        latitude_ocorrencia = -23.5505
        longitude_ocorrencia = -46.6333
    }
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "$API_URL/api/v1/ocorrencias" `
        -Method Post `
        -ContentType "application/json" `
        -Body $ocorrenciaBody
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "======================================" -ForegroundColor Green
Write-Host "  Testes Concluídos!                  " -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Para ver as notificações em tempo real:" -ForegroundColor Yellow
Write-Host "  Abra: http://localhost:4000/test-notifications.html"
Write-Host ""
Write-Host "Para conectar via WebSocket:" -ForegroundColor Yellow
Write-Host "  URL: ws://localhost:4000/cable"
Write-Host "  Canal: NotificationsChannel"
Write-Host ""
