from services.encryption_service import encrypt_data, decrypt_data

def test_aes_gcm_encryption_decryption():
    test_key = "my_super_secret_aes_key_32_bytes_!" # 32 bytes
    test_message = "mock_fingerprint_minutiae_data_001_secret"
    
    print(f"Original Message: {test_message}")
    print(f"Encryption Key: {test_key}")
    
    # Encrypt
    encrypted = encrypt_data(test_message, test_key)
    print(f"Encrypted (Base64): {encrypted}")
    
    # Decrypt
    decrypted = decrypt_data(encrypted, test_key)
    print(f"Decrypted Message: {decrypted}")
    
    # Verify
    assert decrypted == test_message, "Decryption does not match original message!"
    print("SUCCESS: Decrypted message matches the original!")
    
    # Test key derivation fallback
    short_key = "short_key"
    encrypted_short = encrypt_data(test_message, short_key)
    decrypted_short = decrypt_data(encrypted_short, short_key)
    assert decrypted_short == test_message, "Decryption with derived short key failed!"
    print("SUCCESS: Key derivation and fallback verified successfully!")

if __name__ == "__main__":
    test_aes_gcm_encryption_decryption()
