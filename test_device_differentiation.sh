#!/bin/bash

# Script de teste de diferenciação de dispositivos
# SISP360 - Sistema de Notificações em Tempo Real

API_URL="http://localhost:4000/api/v1/notifications"

echo "========================================="
echo "  TESTE DE DIFERENCIAÇÃO DE DISPOSITIVOS"
echo "========================================="
echo ""

# Teste 1: Notificação para TODOS os dispositivos
echo "📢 Teste 1: Notificação para TODOS os dispositivos"
echo "-------------------------------------------"
curl -X POST "$API_URL/broadcast" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "teste_geral",
    "title": "Notificação Geral",
    "message": "Esta mensagem deve aparecer em TODOS os dispositivos (web, mobile, tablet)",
    "data": { "test": "geral" }
  }' | jq
echo ""
echo ""

sleep 2

# Teste 2: Notificação APENAS para WEB
echo "🖥️  Teste 2: Notificação APENAS para WEB"
echo "-------------------------------------------"
curl -X POST "$API_URL/broadcast" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "teste_web",
    "title": "Notificação para Web",
    "message": "✅ Esta mensagem deve aparecer APENAS no COMPUTADOR (Web)",
    "device_types": ["web"],
    "data": { "test": "web_only" }
  }' | jq
echo ""
echo ""

sleep 2

# Teste 3: Notificação APENAS para MOBILE
echo "📱 Teste 3: Notificação APENAS para MOBILE"
echo "-------------------------------------------"
curl -X POST "$API_URL/broadcast" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "teste_mobile",
    "title": "Notificação para Mobile",
    "message": "✅ Esta mensagem deve aparecer APENAS no CELULAR (Mobile)",
    "device_types": ["mobile"],
    "data": { "test": "mobile_only" }
  }' | jq
echo ""
echo ""

sleep 2

# Teste 4: Notificação para WEB e MOBILE (excluindo tablet)
echo "🖥️ 📱 Teste 4: Notificação para WEB e MOBILE"
echo "-------------------------------------------"
curl -X POST "$API_URL/broadcast" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "teste_web_mobile",
    "title": "Notificação para Web e Mobile",
    "message": "✅ Esta mensagem deve aparecer no COMPUTADOR e CELULAR (não em tablet)",
    "device_types": ["web", "mobile"],
    "data": { "test": "web_and_mobile" }
  }' | jq
echo ""
echo ""

sleep 2

# Teste 5: Notificação APENAS para TABLET
echo "📲 Teste 5: Notificação APENAS para TABLET"
echo "-------------------------------------------"
curl -X POST "$API_URL/broadcast" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "teste_tablet",
    "title": "Notificação para Tablet",
    "message": "✅ Esta mensagem deve aparecer APENAS no TABLET",
    "device_types": ["tablet"],
    "data": { "test": "tablet_only" }
  }' | jq
echo ""
echo ""

echo "========================================="
echo "  ✅ TESTES CONCLUÍDOS!"
echo "========================================="
echo ""
echo "📋 Resumo dos testes:"
echo "  1. Notificação geral (todos os dispositivos)"
echo "  2. Notificação apenas para WEB (computador)"
echo "  3. Notificação apenas para MOBILE (celular)"
echo "  4. Notificação para WEB + MOBILE"
echo "  5. Notificação apenas para TABLET"
echo ""
echo "💡 Dica: Abra http://localhost:4000/test-notifications.html"
echo "   em diferentes dispositivos e observe as notificações!"
echo ""
