import requests
import json
from config import PINATA_API_KEY, PINATA_SECRET

def upload_dict_to_ipfs(data: dict, filename: str = "child_registration.json") -> str:
    """
    Uploads a Python dictionary to IPFS via Pinata.
    Returns the IPFS CID (Hash).
    """
    url = "https://api.pinata.cloud/pinning/pinJSONToIPFS"
    
    headers = {
        "Content-Type": "application/json",
        "pinata_api_key": PINATA_API_KEY,
        "pinata_secret_api_key": PINATA_SECRET
    }
    
    payload = {
        "pinataContent": data,
        "pinataMetadata": {
            "name": filename
        }
    }
    
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    
    if response.status_code == 200:
        return response.json().get("IpfsHash")
    else:
        raise Exception(f"Failed to upload to Pinata: {response.text}")

def fetch_dict_from_ipfs(cid: str) -> dict:
    """
    Retrieves a JSON object from IPFS via Pinata's public gateway.
    """
    url = f"https://gateway.pinata.cloud/ipfs/{cid}"
    
    response = requests.get(url)
    
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Failed to fetch from IPFS (CID: {cid}): {response.text}")
