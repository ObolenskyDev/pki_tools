#!/usr/bin/env python3
# vault_client.py — работа с Vault API через Python requests

import requests
import json

VAULT_ADDR = "https://vault.example.com"  # адрес Vault сервера
VAULT_TOKEN = "mytoken"                    # токен авторизации

# Заголовок для всех запросов к Vault — не Bearer а X-Vault-Token
HEADERS = {
    "X-Vault-Token": VAULT_TOKEN,
    "Content-Type": "application/json"
}

def get_secret(path):
    """Получить секрет по пути"""
    url = f"{VAULT_ADDR}/v1/{path}"
    response = requests.get(url, headers=HEADERS)
    print(f"GET {path} → {response.status_code}")
    if response.status_code == 200:
        print(json.dumps(response.json(), indent=2))
    return response.status_code

def put_secret(path, data):
    """Записать секрет по пути"""
    url = f"{VAULT_ADDR}/v1/{path}"
    # Vault KV v2 требует обернуть данные в {"data": {...}}
    payload = {"data": data}
    response = requests.post(url, headers=HEADERS, json=payload)
    print(f"POST {path} → {response.status_code}")
    return response.status_code

# Пример использования
if __name__ == "__main__":
    try:
        print("=== Запись секрета ===")
        put_secret("secret/data/myapp", {"password": "supersecret", "user": "admin"})

        print("\n=== Чтение секрета ===")
        get_secret("secret/data/myapp")
    except Exception as e:
        print(f"[ERROR] Не удалось подключиться к Vault: {e.__class__.__name__}")
        print("Проверь VAULT_ADDR и доступность сервера")