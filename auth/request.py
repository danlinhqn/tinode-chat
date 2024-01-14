import base64

def generate_secret(username, password):
    credentials = f"{username}:{password}"
    secret = base64.b64encode(credentials.encode()).decode()
    return secret

# Sử dụng hàm để tạo secret
username = "linh5"
password = "linh123456"
secret = generate_secret(username, password)
print(secret)
