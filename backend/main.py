from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from services.ipfs_service import upload_dict_to_ipfs, fetch_dict_from_ipfs
from blockchain.web3_client import hash_biometrics, insert_identity_record, get_identity_record
from config import AES_ENCRYPTION_KEY
from services.encryption_service import encrypt_data, decrypt_data

app = FastAPI(
    title="Cureblock Record Insertion API",
    description="API for securely registering children and anchoring biometric hashes on the blockchain.",
    version="1.0.0"
)

# Allow Frontend React App to communicate
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In production, restrict this to frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the Pydantic schema based on the expected test data parameters
class ChildRegistrationSchema(BaseModel):
    did: str
    fingerprintTemplate: str
    leftIrisTemplate: str
    rightIrisTemplate: str
    parentWallet: str

class RegistrationResponse(BaseModel):
    status: str
    ipfs_cid: str
    transaction_hash: str

@app.post("/api/v1/register", response_model=RegistrationResponse)
def register_child(data: ChildRegistrationSchema):
    try:
        # 1. Package the sensitive data for IPFS (Encrypted with AES-256-GCM)
        ipfs_payload = {
            "did": data.did,
            "fingerprint": encrypt_data(data.fingerprintTemplate, AES_ENCRYPTION_KEY),
            "leftIris": encrypt_data(data.leftIrisTemplate, AES_ENCRYPTION_KEY),
            "rightIris": encrypt_data(data.rightIrisTemplate, AES_ENCRYPTION_KEY)
        }
        
        # 2. Upload to decentralized storage (IPFS via Pinata)
        ipfs_cid = upload_dict_to_ipfs(ipfs_payload, filename=f"{data.did}_registration.json")
        
        # 3. Hash the raw templates (SHA-256 parsing/hashing) for on-chain integrity
        fp_hash = hash_biometrics(data.fingerprintTemplate)
        li_hash = hash_biometrics(data.leftIrisTemplate)
        ri_hash = hash_biometrics(data.rightIrisTemplate)
        
        # 4. Insert the record into the Blockchain Framework
        tx_hash = insert_identity_record(
            did=data.did,
            fingerprint_hash=fp_hash,
            left_iris_hash=li_hash,
            right_iris_hash=ri_hash,
            parent_wallet=data.parentWallet,
            ipfs_cid=ipfs_cid,
            biometric_image_cid=""
        )
        
        return RegistrationResponse(
            status="success",
            ipfs_cid=ipfs_cid,
            transaction_hash=tx_hash
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/v1/record/{did}")
def get_record(did: str):
    try:
        # 1. Check Blockchain for the Record
        record = get_identity_record(did)
        
        if not record:
            raise HTTPException(status_code=404, detail="Identity not found on the blockchain.")
            
        # 2. Extract IPFS CID
        ipfs_cid = record["ipfsCID"]
        
        # 3. Download the actual profile data from IPFS
        ipfs_data = fetch_dict_from_ipfs(ipfs_cid)
        
        # 4. Decrypt the templates retrieved from IPFS
        try:
            if ipfs_data:
                # Decrypt each biometric field if present
                if "fingerprint" in ipfs_data:
                    ipfs_data["fingerprint"] = decrypt_data(ipfs_data["fingerprint"], AES_ENCRYPTION_KEY)
                if "leftIris" in ipfs_data:
                    ipfs_data["leftIris"] = decrypt_data(ipfs_data["leftIris"], AES_ENCRYPTION_KEY)
                if "rightIris" in ipfs_data:
                    ipfs_data["rightIris"] = decrypt_data(ipfs_data["rightIris"], AES_ENCRYPTION_KEY)
        except Exception as decrypt_err:
            print(f"Warning: Biometric decryption failed (record might be unencrypted): {decrypt_err}")
            
        # 5. Return the combined data
        return {
            "status": "success",
            "blockchain_verified": True,
            "on_chain_data": record,
            "off_chain_data": ipfs_data
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
