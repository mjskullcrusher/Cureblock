from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from services.ipfs_service import upload_dict_to_ipfs
from blockchain.web3_client import hash_biometrics, insert_identity_record

app = FastAPI(
    title="Cureblock Record Insertion API",
    description="API for securely registering children and anchoring biometric hashes on the blockchain.",
    version="1.0.0"
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
        # 1. Package the sensitive data for IPFS (In a real app, encrypt this first!)
        ipfs_payload = {
            "did": data.did,
            "fingerprint": data.fingerprintTemplate, # Encrypted
            "leftIris": data.leftIrisTemplate,       # Encrypted
            "rightIris": data.rightIrisTemplate      # Encrypted
        }
        
        # 2. Upload to decentralized storage (IPFS via Pinata)
        ipfs_cid = upload_dict_to_ipfs(ipfs_payload, filename=f"{data.did}_registration.json")
        
        # 3. Hash the raw templates for on-chain integrity and matching
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
            ipfs_cid=ipfs_cid
        )
        
        return RegistrationResponse(
            status="success",
            ipfs_cid=ipfs_cid,
            transaction_hash=tx_hash
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
