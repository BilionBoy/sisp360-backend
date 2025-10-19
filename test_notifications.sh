#!/bin/bash

# Script de testes para o sistema de notificações SISP360
# Uso: bash test_notifications.sh

API_URL="http://localhost:4000"

echo "======================================"
echo "  SISP360 - Testes de Notificações   "
echo "======================================"
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Teste 1: Status do Action Cable
echo -e "${BLUE}[1] Verificando status do Action Cable...${NC}"
curl -s "${API_URL}/api/v1/notifications/status" | json_pp 2>/dev/null || curl -s "${API_URL}/api/v1/notifications/status"
echo ""
echo ""

# Teste 2: Enviar notificação de teste
echo -e "${BLUE}[2] Enviando notificação de teste...${NC}"
curl -s -X POST "${API_URL}/api/v1/notifications/test" | json_pp 2>/dev/null || curl -s -X POST "${API_URL}/api/v1/notifications/test"
echo ""
echo ""

# Teste 3: Broadcast customizado
echo -e "${BLUE}[3] Enviando broadcast customizado...${NC}"
curl -s -X POST "${API_URL}/api/v1/notifications/broadcast" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "alerta",
    "title": "Alerta de Teste via Script",
    "message": "Esta é uma notificação de teste enviada via script bash",
    "data": {
      "source": "test_script",
      "priority": "high"
    }
  }' | json_pp 2>/dev/null || curl -s -X POST "${API_URL}/api/v1/notifications/broadcast" \
  -H "Content-Type: application/json" \
  -d '{"type":"alerta","title":"Alerta de Teste via Script","message":"Esta é uma notificação de teste enviada via script bash","data":{"source":"test_script","priority":"high"}}'
echo ""
echo ""

# Teste 4: Notificação de sistema
echo -e "${BLUE}[4] Enviando notificação de sistema (warning)...${NC}"
curl -s -X POST "${API_URL}/api/v1/notifications/sistema" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Sistema em manutenção programada para 22h",
    "level": "warning",
    "data": {
      "scheduled_time": "22:00:00"
    }
  }' | json_pp 2>/dev/null || curl -s -X POST "${API_URL}/api/v1/notifications/sistema" \
  -H "Content-Type: application/json" \
  -d '{"message":"Sistema em manutenção programada para 22h","level":"warning","data":{"scheduled_time":"22:00:00"}}'
echo ""
echo ""

# Teste 5: Criar ocorrência (dispara notificação automática)
echo -e "${BLUE}[5] Criando ocorrência de teste (notificação automática)...${NC}"
TIMESTAMP=$(date +%s)
curl -s -X POST "${API_URL}/api/v1/ocorrencias" \
  -H "Content-Type: application/json" \
  -d "{
    \"ocorrencia\": {
      \"numero_bo\": \"BO-TEST-${TIMESTAMP}\",
      \"id_tipo_crime\": 1,
      \"id_bairro\": 1,
      \"data_ocorrencia\": \"$(date +%Y-%m-%d)\",
      \"hora_ocorrencia\": \"$(date +%H:%M:%S)\",
      \"status_ocorrencia\": \"Pendente\",
      \"descricao_ocorrencia\": \"Ocorrência de teste criada via script\",
      \"latitude_ocorrencia\": -23.5505,
      \"longitude_ocorrencia\": -46.6333
    }
  }" | json_pp 2>/dev/null || curl -s -X POST "${API_URL}/api/v1/ocorrencias" \
  -H "Content-Type: application/json" \
  -d "{\"ocorrencia\":{\"numero_bo\":\"BO-TEST-${TIMESTAMP}\",\"id_tipo_crime\":1,\"id_bairro\":1,\"data_ocorrencia\":\"$(date +%Y-%m-%d)\",\"status_ocorrencia\":\"Pendente\"}}"
echo ""
echo ""

echo -e "${GREEN}======================================"
echo "  Testes Concluídos!                  "
echo "======================================${NC}"
echo ""
echo -e "${YELLOW}Para ver as notificações em tempo real:${NC}"
echo "  Abra: http://localhost:4000/test-notifications.html"
echo ""
echo -e "${YELLOW}Para conectar via WebSocket:${NC}"
echo "  URL: ws://localhost:4000/cable"
echo "  Canal: NotificationsChannel"
echo ""
