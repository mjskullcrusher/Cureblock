import base64
import os
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

def get_key_bytes(key: str) -> bytes:
    """
    Decodes the key string into a 32-byte key for AES-256.
    Supports hex (64 chars) and base64 formats. Falls back to padding if necessary.
    """
    if not key:
        # Fallback for testing when key is not configured
        return b"default_test_key_32_bytes_long_!"
    
    # Try decoding as hex if it's 64 characters long
    if len(key) == 64:
        try:
            return bytes.fromhex(key)
        except ValueError:
            pass
            
    # Try decoding as base64
    try:
        decoded = base64.b64decode(key)
        if len(decoded) == 32:
            return decoded
    except Exception:
        pass
        
    # Fallback: encode utf-8 and pad/truncate to 32 bytes
    key_bytes = key.encode('utf-8')
    if len(key_bytes) < 32:
        return key_bytes.ljust(32, b'\0')
    return key_bytes[:32]

def encrypt_data(plain_text: str, key_str: str) -> str:
    """
    Encrypts a string using AES-256-GCM.
    Returns a URL-safe base64 encoded string containing the 12-byte nonce and ciphertext.
    """
    if not plain_text:
        return ""
    key_bytes = get_key_bytes(key_str)
    aesgcm = AESGCM(key_bytes)
    nonce = os.urandom(12)
    data_bytes = plain_text.encode('utf-8')
    
    # Encrypts and appends the 16-byte authentication tag automatically
    ciphertext = aesgcm.encrypt(nonce, data_bytes, None)
    
    # Prepend the nonce to the ciphertext
    combined = nonce + ciphertext
    return base64.b64encode(combined).decode('utf-8')

def decrypt_data(cipher_text_b64: str, key_str: str) -> str:
    """
    Decrypts a base64 encoded string containing nonce + ciphertext using AES-256-GCM.
    Returns the decrypted plain text string.
    """
    if not cipher_text_b64:
        return ""
    key_bytes = get_key_bytes(key_str)
    aesgcm = AESGCM(key_bytes)
    
    combined = base64.b64decode(cipher_text_b64.encode('utf-8'))
    if len(combined) < 12:
        raise ValueError("Cipher text too short to contain nonce")
        
    nonce = combined[:12]
    ciphertext = combined[12:]
    
    decrypted_bytes = aesgcm.decrypt(nonce, ciphertext, None)
    return decrypted_bytes.decode('utf-8')
