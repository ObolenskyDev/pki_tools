#!/bin/bash
HOST=$1
PORT=${2:-443}
if [ -z "$HOST" ]; then
	echo "Использование: $0 <host> [port]"
	exit 1
fi
echo "--- Проверка сертификата: $HOST:$PORT ---"
CERT=$(openssl s_client -connect "$HOST:$PORT" -servername "$HOST" </dev/null 2>/dev/null)
echo "$CERT" | openssl x509 -noout -subject -issuer -dates
EXPIRY=$(echo "$CERT" | openssl x509 -noout -enddate | cut -d= -f2)
DAYS=$(( ($(date -d "$EXPIRY" +%s) - $(date +%s)) / 86400))
if [ "$DAYS" -lt 30 ]; then
	echo "[WARN] Истекает через $DAYS дней!"
else
	echo "[OK] Действителен ещё $DAYS дней!"
fi
