#!/bin/bash

HOST=$1           # первый аргумент — хост для проверки
PORT=${2:-443}    # второй аргумент — порт, дефолт 443 (HTTPS)

# Если хост не передан — показываем подсказку
if [ -z "$HOST" ]; then
    echo "Использование: $0 <host> [port]"
    exit 1
fi

echo "--- Проверка сертификата: $HOST:$PORT ---"

# Подключаемся к хосту и забираем сертификат
# -servername нужен для SNI — когда на одном IP несколько сайтов
# </dev/null — чтобы openssl не ждал ввода
# 2>/dev/null — скрываем технический мусор в выводе
CERT=$(openssl s_client -connect "$HOST:$PORT" -servername "$HOST" </dev/null 2>/dev/null)

# Выводим основные поля: владелец, кто выдал, даты
echo "$CERT" | openssl x509 -noout -subject -issuer -dates

# Берём дату истечения и считаем сколько дней осталось
EXPIRY=$(echo "$CERT" | openssl x509 -noout -enddate | cut -d= -f2)
DAYS=$(( ($(date -d "$EXPIRY" +%s) - $(date +%s)) / 86400 ))

# Алертим если меньше 30 дней — стандартный порог для ротации
if [ "$DAYS" -lt 30 ]; then
    echo "[WARN] Истекает через $DAYS дней!"
else
    echo "[OK] Действителен ещё $DAYS дней!"
fi