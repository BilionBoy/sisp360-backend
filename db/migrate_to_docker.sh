#!/bin/bash

# Script de Migração: Banco Remoto → Docker Local
# Este script automatiza a migração completa do banco de dados

set -e  # Para na primeira falha

echo "============================================"
echo "MIGRAÇÃO DO BANCO DE DADOS PARA DOCKER"
echo "============================================"
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configurações do banco REMOTO
REMOTE_HOST="89.116.29.67"
REMOTE_PORT="5433"
REMOTE_USER="postgres"
REMOTE_PASSWORD="oNK65ODeDw5Vq82IGz5CtZhcYDa9DZfvLraPUxXh1avqYLpDGXigcTg4OevrlBvT"
REMOTE_DB="crimes_porto_velho"

# Configurações do banco LOCAL (Docker)
LOCAL_HOST="localhost"
LOCAL_PORT="5432"
LOCAL_USER="postgres"
LOCAL_PASSWORD="sisp360_local_password"
LOCAL_DB="crimes_porto_velho"

# Arquivo de backup
BACKUP_DIR="db/backups"
BACKUP_FILE="$BACKUP_DIR/crimes_porto_velho_$(date +%Y%m%d_%H%M%S).sql"

mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}PASSO 1: Verificando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker não encontrado. Instale Docker Desktop primeiro.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker instalado${NC}"
echo ""

echo -e "${YELLOW}PASSO 2: Iniciando container PostgreSQL...${NC}"
docker-compose up -d postgres
echo -e "${GREEN}✅ Container iniciado${NC}"
echo ""

echo -e "${YELLOW}PASSO 3: Aguardando PostgreSQL ficar pronto...${NC}"
sleep 10
until docker-compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; do
    echo "Aguardando PostgreSQL..."
    sleep 2
done
echo -e "${GREEN}✅ PostgreSQL pronto${NC}"
echo ""

echo -e "${YELLOW}PASSO 4: Fazendo backup do banco REMOTO...${NC}"
echo "Conectando em: $REMOTE_HOST:$REMOTE_PORT"
echo "Banco: $REMOTE_DB"
echo "Arquivo: $BACKUP_FILE"
echo ""

export PGPASSWORD="$REMOTE_PASSWORD"
pg_dump -h "$REMOTE_HOST" \
        -p "$REMOTE_PORT" \
        -U "$REMOTE_USER" \
        -d "$REMOTE_DB" \
        -F p \
        --no-owner \
        --no-acl \
        -f "$BACKUP_FILE"

BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo -e "${GREEN}✅ Backup criado: $BACKUP_FILE ($BACKUP_SIZE)${NC}"
echo ""

echo -e "${YELLOW}PASSO 5: Restaurando no banco LOCAL (Docker)...${NC}"
export PGPASSWORD="$LOCAL_PASSWORD"
psql -h "$LOCAL_HOST" \
     -p "$LOCAL_PORT" \
     -U "$LOCAL_USER" \
     -d "$LOCAL_DB" \
     -f "$BACKUP_FILE"

echo -e "${GREEN}✅ Restauração concluída${NC}"
echo ""

echo -e "${YELLOW}PASSO 6: Verificando migração...${NC}"
REMOTE_COUNT=$(PGPASSWORD="$REMOTE_PASSWORD" psql -h "$REMOTE_HOST" -p "$REMOTE_PORT" -U "$REMOTE_USER" -d "$REMOTE_DB" -t -c "SELECT COUNT(*) FROM ocorrencias;")
LOCAL_COUNT=$(PGPASSWORD="$LOCAL_PASSWORD" psql -h "$LOCAL_HOST" -p "$LOCAL_PORT" -U "$LOCAL_USER" -d "$LOCAL_DB" -t -c "SELECT COUNT(*) FROM ocorrencias;")

echo "Registros no banco REMOTO: $REMOTE_COUNT"
echo "Registros no banco LOCAL:  $LOCAL_COUNT"

if [ "$REMOTE_COUNT" = "$LOCAL_COUNT" ]; then
    echo -e "${GREEN}✅ Migração verificada com sucesso!${NC}"
else
    echo -e "${RED}⚠️  ATENÇÃO: Contagens diferentes!${NC}"
fi
echo ""

echo "============================================"
echo -e "${GREEN}MIGRAÇÃO CONCLUÍDA!${NC}"
echo "============================================"
echo ""
echo "Próximos passos:"
echo "1. Atualizar .env com as novas credenciais"
echo "2. Reiniciar o servidor Rails"
echo "3. Testar a aplicação"
echo ""
echo "Nova DATABASE_URL:"
echo "DATABASE_URL=postgres://postgres:sisp360_local_password@localhost:5432/crimes_porto_velho"
echo ""
