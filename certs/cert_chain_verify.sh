#!/bin/bash
# cert_chain_verify.sh — проверка цепочки доверия сертификата
# РАЗОБРАТЬ ПОДРОБНЕЕ: промежуточные CA, bundle файлы

HOST=${1:-"google.com"}
PORT=${2:-443}

echo "=== Проверка цепочки доверия: $HOST ==="

# Забираем полную цепочку от сервера
echo | openssl s_client \
    -connect "$HOST:$PORT" \
    -servername "$HOST" \
    -showcerts 2>/dev/null | \
    grep -E "subject|issuer|BEGIN CERTIFICATE"

echo ""
echo "=== Итог проверки ==="
echo | openssl s_client \
    -connect "$HOST:$PORT" \
    -servername "$HOST" 2>/dev/null | \
    openssl x509 -noout -subject -issuer