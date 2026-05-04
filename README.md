# pki_tools

Набор инструментов для работы с PKI, сертификатами и секретами.

## Структура

- `certs/` — проверка и мониторинг сертификатов
- `keys/` — генерация ключей и CSR
- `api/` — работа с Vault API
- `logs/` — ротация логов

## Скрипты

### certs/cert_check.sh
Проверка сертификата хоста — владелец, ЦА, срок истечения.
```bash
bash certs/cert_check.sh google.com
```

### certs/cert_monitor.sh
Мониторинг списка хостов, пишет в logs/cert_monitor.log.
```bash
bash certs/cert_monitor.sh
```

### keys/gen_keypair.sh
Генерация приватного ключа и CSR.
```bash
bash keys/gen_keypair.sh myservice
```

### keys/verify_key_cert.sh
Проверка соответствия ключа и сертификата.
```bash
bash keys/verify_key_cert.sh keys/my_keypairs/myservice.key keys/my_keypairs/myservice.crt
```

### api/vault_client.py
Получение и запись секретов через Vault API.
```bash
python3 api/vault_client.py
```

### api/vault_get.sh
Запрос секрета из Vault через curl.
```bash
bash api/vault_get.sh
```

### logs/rotate_logs.sh
Ротация лог-файлов — архивирует старые, оставляет последние 100 строк.
```bash
bash logs/rotate_logs.sh
```

### certs/cert_chain_verify.sh
Проверка цепочки доверия сертификата.
```bash
bash certs/cert_chain_verify.sh google.com
```

### logs/logrotate_example.conf
Пример конфига системной ротации логов для /etc/logrotate.d/.
```bash
sudo logrotate -d logs/logrotate_example.conf
```