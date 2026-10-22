#!/bin/bash
set -e

CONNECT_URL="http://kafka-connect:8083"
CONNECTOR_NAME="pg-connector"
JSON_FILE="/config/pg-connector.json"

echo "⏳ Ожидание доступности Kafka Connect..."
# Цикл ждёт, пока REST API Connect не начнёт отвечать
until curl -s -o /dev/null -w "%{http_code}" "$CONNECT_URL/connectors" | grep -q "200"; do
  echo "   Kafka Connect ещё не готов, повтор через 5 секунд..."
  sleep 5
done
echo "✅ Kafka Connect доступен."

echo "🔍 Проверка существования коннектора '$CONNECTOR_NAME'..."
if curl -s -o /dev/null -w "%{http_code}" "$CONNECT_URL/connectors/$CONNECTOR_NAME" | grep -q "200"; then
  echo "⚠️  Коннектор уже существует. Обновляем конфигурацию (PUT)..."
  # Используем PUT для идемпотентного обновления конфигурации
  curl -X PUT -H "Content-Type: application/json" \
       --data @<(/usr/bin/env python3 -c "import json,sys; print(json.dumps(json.load(open('$JSON_FILE'))['config']))") \
       "$CONNECT_URL/connectors/$CONNECTOR_NAME/config"
else
  echo "🚀 Регистрация нового коннектора (POST)..."
  curl -X POST -H "Content-Type: application/json" \
       --data @"$JSON_FILE" \
       "$CONNECT_URL/connectors"
fi

echo ""
echo "🎉 Готово. Статус коннектора:"
curl -s "$CONNECT_URL/connectors/$CONNECTOR_NAME/status" | python3 -m json.tool