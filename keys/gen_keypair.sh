#!/bin/bash
# gen_keypair.sh — генерация приватного ключа и CSR

NAME=${1:-"myservice"}                        # имя сервиса из аргумента, дефолт "myservice"
OUTDIR="$(dirname "$0")/my_keypairs"          # папка рядом со скриптом
mkdir -p "$OUTDIR"                            # создаём если не существует

echo "=== Генерация приватного ключа ==="
# RSA ключ 2048 бит — стандарт для большинства систем
openssl genrsa -out "$OUTDIR/$NAME.key" 2048

echo "=== Генерация CSR ==="
# req -new — новый запрос на сертификат
# -key — используем только что созданный приватный ключ
# -subj — данные владельца: CN=имя, O=организация, C=страна
openssl req -new \
  -key "$OUTDIR/$NAME.key" \
  -out "$OUTDIR/$NAME.csr" \
  -subj "/CN=$NAME/O=MyOrg/C=RU"

echo "=== Готово ==="
echo "Ключ:  $OUTDIR/$NAME.key"
echo "CSR:   $OUTDIR/$NAME.csr"
echo ""

echo "=== Содержимое CSR ==="
# Показываем что внутри CSR — проверяем что Subject и ключ правильные
openssl req -text -noout -in "$OUTDIR/$NAME.csr"