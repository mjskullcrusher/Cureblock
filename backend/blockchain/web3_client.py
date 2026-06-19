import hashlib
import json
from pathlib import Path
# pyrefly: ignore [missing-import]
from web3 import Web3
from web3.middleware import ExtraDataToPOAMiddleware
from config import RPC_URL, PRIVATE_KEY, IDENTITY_REGISTRY_ADDRESS

# Initialize Web3
w3 = Web3(Web3.HTTPProvider(RPC_URL))
# Inject middleware for PoA networks (Sepolia)
w3.middleware_onion.inject(ExtraDataToPOAMiddleware, layer=0)

if not w3.is_connected():
    raise Exception("Failed to connect to the Sepolia RPC URL")

# Load Account
account = w3.eth.account.from_key(PRIVATE_KEY)

# Load ABI dynamically from the Hardhat artifacts
artifacts_path = Path(__file__).parent.parent.parent / "blockchain" / "artifacts" / "contracts" / "IdentityRegistry.sol" / "IdentityRegistry.json"
with open(artifacts_path, "r") as f:
    contract_json = json.load(f)
    IDENTITY_ABI = contract_json["abi"]

# Load AccessControlRegistry ABI to grant OPERATOR_ROLE
access_artifacts_path = Path(__file__).parent.parent.parent / "blockchain" / "artifacts" / "contracts" / "AccessControlRegistry.sol" / "AccessControlRegistry.json"
with open(access_artifacts_path, "r") as f:
    access_abi = json.load(f)["abi"]

identity_contract = w3.eth.contract(address=IDENTITY_REGISTRY_ADDRESS, abi=IDENTITY_ABI)

def _ensure_operator_role():
    """Ensure the backend wallet has the OPERATOR_ROLE required for insertion."""
    access_address = identity_contract.functions.accessControl().call()
    access_contract = w3.eth.contract(address=access_address, abi=access_abi)
    
    operator_role = w3.keccak(text="OPERATOR_ROLE")
    has_role = access_contract.functions.hasRole(operator_role, account.address).call()
    
    if not has_role:
        print("Granting OPERATOR_ROLE to backend wallet for the first time...")
        tx = access_contract.functions.grantRole(operator_role, account.address).build_transaction({
            "from": account.address,
            "nonce": w3.eth.get_transaction_count(account.address),
            "gas": 300000,
            "gasPrice": w3.eth.gas_price
        })
        signed_tx = w3.eth.account.sign_transaction(tx, PRIVATE_KEY)
        tx_hash = w3.eth.send_raw_transaction(signed_tx.raw_transaction)
        w3.eth.wait_for_transaction_receipt(tx_hash)
        print(f"OPERATOR_ROLE granted! Tx: {tx_hash.hex()}")

# Run role check on startup
_ensure_operator_role()


def hash_biometrics(template: str) -> bytes:
    """
    Parses the biometric template as a hex-encoded SHA-256 hash if valid,
    otherwise hashes the raw template using SHA-256.
    Returns 32 bytes.
    """
    clean_input = template.strip()
    if clean_input.startswith("0x") or clean_input.startswith("0X"):
        clean_input = clean_input[2:]
        
    if len(clean_input) == 64:
        try:
            return bytes.fromhex(clean_input)
        except ValueError:
            pass
            
    return hashlib.sha256(template.encode('utf-8')).digest()


def insert_identity_record(did: str, fingerprint_hash: bytes, left_iris_hash: bytes, right_iris_hash: bytes, parent_wallet: str, ipfs_cid: str):
    """
    Submits the transaction to IdentityRegistry.sol to insert the record.
    Returns the transaction hash.
    """
    tx = identity_contract.functions.registerIdentity(
        did,
        fingerprint_hash,
        left_iris_hash,
        right_iris_hash,
        w3.to_checksum_address(parent_wallet),
        ipfs_cid
    ).build_transaction({
        "from": account.address,
        "nonce": w3.eth.get_transaction_count(account.address),
        "gas": 500000,
        "gasPrice": w3.eth.gas_price
    })
    
    signed_tx = w3.eth.account.sign_transaction(tx, PRIVATE_KEY)
    tx_hash = w3.eth.send_raw_transaction(signed_tx.raw_transaction)
    
    # Wait for the transaction to be mined
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    
    if receipt.status != 1:
        raise Exception(f"Transaction failed! Tx: {tx_hash.hex()}")
        
    return tx_hash.hex()

def get_identity_record(did: str) -> dict:
    """
    Retrieves the identity record from the blockchain.
    """
    record = identity_contract.functions.identities(did).call()
    
    # Solidity struct returns a tuple. In web3.py:
    # (did, fingerprintHash, leftIrisHash, rightIrisHash, parentWallet, ipfsCID, isActive)
    
    if not record[6]: # isActive
        return None
        
    return {
        "did": record[0],
        "fingerprintHash": record[1].hex(),
        "leftIrisHash": record[2].hex(),
        "rightIrisHash": record[3].hex(),
        "parentWallet": record[4],
        "ipfsCID": record[5],
        "isActive": record[6]
    }
