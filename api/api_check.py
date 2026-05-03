import requests
import json

def get_secret(url, token):
    response = requests.get(
        url,
        headers={"Authorization": f"Bearer {token}"}
    )
    print(f"Status: {response.status_code}")
    print(json.dumps(response.json(), indent=2))

# тест на httpbin (имитация запроса к API)
get_secret("https://httpbin.org/get", "mytoken123")