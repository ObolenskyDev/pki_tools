#!/bin/bash
# cert_monitor.sh — мониторинг списка хостов, пишет в лог
# Запускается по cron, алертит если сертификат истекает < 30 дней

WARN_DAYS=30
LOG="$(dirname "$0")/../logs/cert_monitor.log"  # лог в папке logs/
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')          # метка времени

# Список хостов для мониторинга — добавляй свои
HOSTS=(
    "google.com:443"
    "github.com:443"
)

# Функция проверки одного хоста
check_host() {
    local HOST=$1
    local PORT=$2

    # Забираем сертификат
    CERT=$(openssl s_client -connect "$HOST:$PORT" \
        -servername "$HOST" </dev/null 2>/dev/null)

    # Считаем дни до истечения
    EXPIRY=$(echo "$CERT" | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    DAYS=$(( ($(date -d "$EXPIRY" +%s) - $(date +%s)) / 86400 ))

    # Пишем в лог и выводим в консоль
    if [[ $DAYS -lt $WARN_DAYS ]]; then
        echo "[$TIMESTAMP] [WARN] $HOST:$PORT — истекает через $DAYS дней" | tee -a "$LOG"
    else
        echo "[$TIMESTAMP] [OK]   $HOST:$PORT — действителен ещё $DAYS дней" | tee -a "$LOG"
    fi
}

echo "[$TIMESTAMP] === Запуск мониторинга ===" | tee -a "$LOG"

# Проходим по всем хостам из списка
for TARGET in "${HOSTS[@]}"; do
    HOST=$(echo "$TARGET" | cut -d: -f1)   # берём хост до двоеточия
    PORT=$(echo "$TARGET" | cut -d: -f2)   # берём порт после двоеточия
    check_host "$HOST" "$PORT"
done

echo "[$TIMESTAMP] === Мониторинг завершён ===" | tee -a "$LOG"