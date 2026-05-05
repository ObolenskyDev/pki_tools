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
**Пример вывода:**
```
--- Проверка сертификата: google.com:443 ---
subject=CN = *.google.com
issuer=C = US, O = Google Trust Services, CN = WR2
notBefore=Apr  8 05:17:21 2026 GMT
notAfter=Jul  1 05:17:20 2026 GMT
[OK] Действителен ещё 56 дней!
```

---

### certs/cert_monitor.sh
Мониторинг списка хостов, пишет в logs/cert_monitor.log.
```bash
bash certs/cert_monitor.sh
```
**Пример вывода:**
```
[2026-05-05 15:01:13] === Запуск мониторинга ===
[2026-05-05 15:01:13] [OK]   google.com:443 — действителен ещё 56 дней
[2026-05-05 15:01:13] [OK]   github.com:443 — действителен ещё 88 дней
[2026-05-05 15:01:13] === Мониторинг завершён ===
```

---

### certs/cert_chain_verify.sh
Проверка цепочки доверия сертификата.
```bash
bash certs/cert_chain_verify.sh google.com
```
**Пример вывода:**
```
=== Проверка цепочки доверия: google.com ===
-----BEGIN CERTIFICATE-----
-----BEGIN CERTIFICATE-----
-----BEGIN CERTIFICATE-----
subject=CN = *.google.com
issuer=C = US, O = Google Trust Services, CN = WR2

=== Итог проверки ===
subject=CN = *.google.com
issuer=C = US, O = Google Trust Services, CN = WR2
```

---

### keys/gen_keypair.sh
Генерация приватного ключа и CSR.
```bash
bash keys/gen_keypair.sh myservice
```
**Пример вывода:**
```
=== Генерация приватного ключа ===
=== Генерация CSR ===
=== Готово ===
Ключ:  keys/my_keypairs/myservice.key
CSR:   keys/my_keypairs/myservice.csr

=== Содержимое CSR ===
Certificate Request:
    Data:
        Version: 1 (0x0)
        Subject: CN = myservice, O = MyOrg, C = RU
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
```

---

### keys/verify_key_cert.sh
Проверка соответствия ключа и сертификата.
```bash
bash keys/verify_key_cert.sh keys/my_keypairs/myservice.key keys/my_keypairs/myservice.crt
```
**Пример вывода:**
```
=== Проверка соответствия ключа и сертификата ===
Ключ:        5582413747f95cf95e2d728bb0294389  -
Сертификат:  5582413747f95cf95e2d728bb0294389  -
[OK] Ключ и сертификат совпадают
```

---

### api/vault_client.py
Получение и запись секретов через Vault API.
```bash
python3 api/vault_client.py
```
**Пример вывода** (без реального Vault):
```
=== Запись секрета ===
[ERROR] Не удалось подключиться к Vault: ConnectionError
Проверь VAULT_ADDR и доступность сервера
```
> В боевом окружении заменить `VAULT_ADDR` на реальный адрес Vault сервера.

---

### api/vault_get.sh
Запрос секрета из Vault через curl.
```bash
bash api/vault_get.sh
```
**Пример вывода** (без реального Vault):
```
=== Запрос секрета из Vault ===
=== Статус запроса ===
HTTP код: 000
```
> HTTP 000 означает что сервер недоступен. В боевом окружении заменить `VAULT_ADDR` на реальный адрес.

---

### logs/rotate_logs.sh
Ротация лог-файлов — архивирует старые, оставляет последние 100 строк.
```bash
bash logs/rotate_logs.sh
```
**Пример вывода:**
```
[SKIP] logs/cert_monitor.log: 12 строк — ротация не нужна
```
> При превышении 100 строк скрипт архивирует старые записи в `.gz` файл.

---

### logs/logrotate_example.conf
Пример конфига системной ротации логов для `/etc/logrotate.d/`.
```bash
sudo logrotate -d logs/logrotate_example.conf
```
> В продакшне конфиг кладётся в `/etc/logrotate.d/` под root. Файл демонстрирует понимание механики ротации.
