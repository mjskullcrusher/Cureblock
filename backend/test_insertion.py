import requests

API_URL = "http://127.0.0.1:8000/api/v1/register"

test_data = {
    "did": "did:cureblock:test-child-999",
    "fingerprintTemplate": "mock_fingerprint_minutiae_data_001",
    "leftIrisTemplate": "mock_left_iris_data_001",
    "rightIrisTemplate": "mock_right_iris_data_001",
    "parentWallet": "0x1234567890123456789012345678901234567890"
}

print("Sending Record Insertion request to the blockchain framework...")
response = requests.post(API_URL, json=test_data)

if response.status_code == 200:
    print("SUCCESS! Record inserted.")
    print("Response payload:")
    print(response.json())
else:
    print("FAILED!")
    print(f"Status Code: {response.status_code}")
    print(f"Error: {response.text}")
