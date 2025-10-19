# Script de Migração: Banco Remoto → Docker Local (Windows)
# Execute com: .\db\migrate_to_docker.ps1

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "MIGRAÇÃO DO BANCO DE DADOS PARA DOCKER" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Configurações do banco REMOTO
$REMOTE_HOST = "89.116.29.67"
$REMOTE_PORT = "5433"
$REMOTE_USER = "postgres"
$REMOTE_PASSWORD = "oNK65ODeDw5Vq82IGz5CtZhcYDa9DZfvLraPUxXh1avqYLpDGXigcTg4OevrlBvT"
$REMOTE_DB = "crimes_porto_velho"

# Configurações do banco LOCAL (Docker)
$LOCAL_HOST = "localhost"
$LOCAL_PORT = "5432"
$LOCAL_USER = "postgres"
$LOCAL_PASSWORD = "sisp360_local_password"
$LOCAL_DB = "crimes_porto_velho"

# Arquivo de backup
$BACKUP_DIR = "db\backups"
$TIMESTAMP = Get-Date -Format "yyyyMMdd_HHmmss"
$BACKUP_FILE = "$BACKUP_DIR\crimes_porto_velho_$TIMESTAMP.sql"

# Criar diretório de backup se não existir
if (-not (Test-Path $BACKUP_DIR)) {
    New-Item -ItemType Directory -Path $BACKUP_DIR | Out-Null
}

Write-Host "PASSO 1: Verificando Docker..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker não encontrado. Instale Docker Desktop primeiro." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Docker instalado" -ForegroundColor Green
Write-Host ""

Write-Host "PASSO 2: Iniciando container PostgreSQL..." -ForegroundColor Yellow
docker-compose up -d postgres
Write-Host "✅ Container iniciado" -ForegroundColor Green
Write-Host ""

Write-Host "PASSO 3: Aguardando PostgreSQL ficar pronto..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
$retries = 0
$maxRetries = 30
while ($retries -lt $maxRetries) {
    $result = docker-compose exec -T postgres pg_isready -U postgres 2>&1
    if ($LASTEXITCODE -eq 0) {
        break
    }
    Write-Host "Aguardando PostgreSQL..."
    Start-Sleep -Seconds 2
    $retries++
}
Write-Host "✅ PostgreSQL pronto" -ForegroundColor Green
Write-Host ""

Write-Host "PASSO 4: Fazendo backup do banco REMOTO..." -ForegroundColor Yellow
Write-Host "Conectando em: $REMOTE_HOST`:$REMOTE_PORT"
Write-Host "Banco: $REMOTE_DB"
Write-Host "Arquivo: $BACKUP_FILE"
Write-Host ""

$env:PGPASSWORD = $REMOTE_PASSWORD
& pg_dump -h $REMOTE_HOST `
          -p $REMOTE_PORT `
          -U $REMOTE_USER `
          -d $REMOTE_DB `
          -F p `
          --no-owner `
          --no-acl `
          -f $BACKUP_FILE

if ($LASTEXITCODE -eq 0) {
    $size = (Get-Item $BACKUP_FILE).Length / 1MB
    Write-Host "✅ Backup criado: $BACKUP_FILE ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao criar backup" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "PASSO 5: Restaurando no banco LOCAL (Docker)..." -ForegroundColor Yellow
$env:PGPASSWORD = $LOCAL_PASSWORD
& psql -h $LOCAL_HOST `
       -p $LOCAL_PORT `
       -U $LOCAL_USER `
       -d $LOCAL_DB `
       -f $BACKUP_FILE

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Restauração concluída" -ForegroundColor Green
} else {
    Write-Host "❌ Erro na restauração" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "PASSO 6: Verificando migração..." -ForegroundColor Yellow
$env:PGPASSWORD = $REMOTE_PASSWORD
$REMOTE_COUNT = (& psql -h $REMOTE_HOST -p $REMOTE_PORT -U $REMOTE_USER -d $REMOTE_DB -t -c "SELECT COUNT(*) FROM ocorrencias;").Trim()

$env:PGPASSWORD = $LOCAL_PASSWORD
$LOCAL_COUNT = (& psql -h $LOCAL_HOST -p $LOCAL_PORT -U $LOCAL_USER -d $LOCAL_DB -t -c "SELECT COUNT(*) FROM ocorrencias;").Trim()

Write-Host "Registros no banco REMOTO: $REMOTE_COUNT"
Write-Host "Registros no banco LOCAL:  $LOCAL_COUNT"

if ($REMOTE_COUNT -eq $LOCAL_COUNT) {
    Write-Host "✅ Migração verificada com sucesso!" -ForegroundColor Green
} else {
    Write-Host "⚠️  ATENÇÃO: Contagens diferentes!" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "MIGRAÇÃO CONCLUÍDA!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos passos:"
Write-Host "1. Atualizar .env com as novas credenciais"
Write-Host "2. Reiniciar o servidor Rails"
Write-Host "3. Testar a aplicação"
Write-Host ""
Write-Host "Nova DATABASE_URL:"
Write-Host "DATABASE_URL=postgres://postgres:sisp360_local_password@localhost:5432/crimes_porto_velho" -ForegroundColor Cyan
Write-Host ""
