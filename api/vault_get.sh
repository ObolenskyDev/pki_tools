#!/bin/bash

VAULT_ADDR="https://vault.example.com"
VAULT_TOKEN="mytoken"
SECRET_PATH="secret/data/myapp"

echo "=== Запрос секрета из Vault ==="
curl -s \
  -H "X-Vault-Token: $VAULT_TOKEN" \
  "$VAULT_ADDR/v1/$SECRET_PATH" | python3 -m json.tool

echo "=== Статус запроса ==="
curl -s -o /dev/null -w "HTTP код: %{http_code}\n" \
  -H "X-Vault-Token: $VAULT_TOKEN" \
  "$VAULT_ADDR/v1/$SECRET_PATH"