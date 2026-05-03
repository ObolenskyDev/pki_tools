#!/bin/bash
# rotate_logs.sh — ротация логов операций
# Оставляет последние N строк, архивирует остальное

LOG_DIR="$(dirname "$0")"   # папка logs/
MAX_LINES=100                # сколько строк оставить в живом логе
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')  # метка для архива

# Проходим по всем .log файлам в папке
for LOG_FILE in "$LOG_DIR"/*.log; do
    # Если файлов нет — пропускаем
    [[ -f "$LOG_FILE" ]] || continue

    LINES=$(wc -l < "$LOG_FILE")  # считаем строки в файле

    # Ротируем только если строк больше MAX_LINES
    if [[ $LINES -gt $MAX_LINES ]]; then
        ARCHIVE="${LOG_FILE%.log}_$TIMESTAMP.log.gz"  # имя архива
        # Архивируем старые строки
        head -n $(( LINES - MAX_LINES )) "$LOG_FILE" | gzip > "$ARCHIVE"
        # Оставляем только последние MAX_LINES строк
        tail -n $MAX_LINES "$LOG_FILE" > "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
        echo "[OK] $LOG_FILE: было $LINES строк → оставлено $MAX_LINES, архив: $ARCHIVE"
    else
        echo "[SKIP] $LOG_FILE: $LINES строк — ротация не нужна"
    fi
done