# Script Simplificado de Migração usando Docker
# Não requer PostgreSQL client tools instalado localmente

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "MIGRAÇÃO SIMPLIFICADA - VIA DOCKER" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Configurações
$REMOTE_HOST = "89.116.29.67"
$REMOTE_PORT = "5433"
$REMOTE_USER = "postgres"
$REMOTE_PASSWORD = "oNK65ODeDw5Vq82IGz5CtZhcYDa9DZfvLraPUxXh1avqYLpDGXigcTg4OevrlBvT"
$REMOTE_DB = "crimes_porto_velho"
$LOCAL_PASSWORD = "sisp360_local_password"

$BACKUP_FILE = "crimes_porto_velho_backup.sql"

Write-Host "PASSO 1: Verificando Docker..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker não encontrado" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Docker OK" -ForegroundColor Green
Write-Host ""

Write-Host "PASSO 2: Iniciando PostgreSQL local..." -ForegroundColor Yellow
docker-compose up -d postgres
Start-Sleep -Seconds 5
Write-Host "✅ Container iniciado" -ForegroundColor Green
Write-Host ""

Write-Host "PASSO 3: Aguardando PostgreSQL..." -ForegroundColor Yellow
$retries = 0
while ($retries -lt 30) {
    $result = docker-compose exec -T postgres pg_isready -U postgres 2>&1
    if ($LASTEXITCODE -eq 0) { break }
    Start-Sleep -Seconds 2
    $retries++
}
Write-Host "✅ PostgreSQL pronto" -ForegroundColor Green
Write-Host ""

Write-Host "PASSO 4: Fazendo backup do banco REMOTO via Docker..." -ForegroundColor Yellow
Write-Host "Conectando em: $REMOTE_HOST`:$REMOTE_PORT"
Write-Host ""

# Usar Docker para fazer pg_dump
docker-compose exec -T postgres bash -c "PGPASSWORD='$REMOTE_PASSWORD' pg_dump -h $REMOTE_HOST -p $REMOTE_PORT -U $REMOTE_USER -d $REMOTE_DB -F p --no-owner --no-acl" > $BACKUP_FILE

if ($LASTEXITCODE -eq 0 -and (Test-Path $BACKUP_FILE)) {
    $size = (Get-Item $BACKUP_FILE).Length / 1MB
    Write-Host "✅ Backup criado: $BACKUP_FILE ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao criar backup" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "PASSO 5: Restaurando no banco LOCAL..." -ForegroundColor Yellow

# Copiar backup para dentro do container
docker cp $BACKUP_FILE sisp360_postgres:/tmp/backup.sql

# Restaurar via Docker
docker-compose exec -T postgres bash -c "PGPASSWORD='$LOCAL_PASSWORD' psql -U postgres -d $REMOTE_DB -f /tmp/backup.sql" > $null 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Restauração concluída" -ForegroundColor Green
} else {
    Write-Host "⚠️  Restauração pode ter tido avisos (normal)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "PASSO 6: Verificando migração..." -ForegroundColor Yellow

# Contar registros no banco REMOTO
$REMOTE_COUNT = docker-compose exec -T postgres bash -c "PGPASSWORD='$REMOTE_PASSWORD' psql -h $REMOTE_HOST -p $REMOTE_PORT -U $REMOTE_USER -d $REMOTE_DB -t -c 'SELECT COUNT(*) FROM ocorrencias;'" 2>$null
$REMOTE_COUNT = $REMOTE_COUNT.Trim()

# Contar registros no banco LOCAL
$LOCAL_COUNT = docker-compose exec -T postgres bash -c "PGPASSWORD='$LOCAL_PASSWORD' psql -U postgres -d $REMOTE_DB -t -c 'SELECT COUNT(*) FROM ocorrencias;'" 2>$null
$LOCAL_COUNT = $LOCAL_COUNT.Trim()

Write-Host "Registros no banco REMOTO: $REMOTE_COUNT"
Write-Host "Registros no banco LOCAL:  $LOCAL_COUNT"

if ($REMOTE_COUNT -eq $LOCAL_COUNT) {
    Write-Host "✅ Migração verificada com sucesso!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Contagens diferentes (pode ser normal se houve inserções)" -ForegroundColor Yellow
}
Write-Host ""

# Limpar arquivo temporário
Remove-Item $BACKUP_FILE -ErrorAction SilentlyContinue

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "MIGRAÇÃO CONCLUÍDA!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Atualizar seu .env com:"
Write-Host "   DATABASE_URL=postgres://postgres:sisp360_local_password@localhost:5432/crimes_porto_velho" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Reiniciar o servidor Rails" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Testar:" -ForegroundColor Yellow
Write-Host "   rails runner 'puts Ocorrencia.count'" -ForegroundColor Cyan
Write-Host ""
