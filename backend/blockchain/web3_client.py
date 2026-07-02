import hashlib
import json
import warnings
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

# ---------------------------------------------------------------------------
# Auto-load contract address from deployments.json (written by deploy.js).
# Falls back to the hardcoded value in config.py if the file is missing.
# ---------------------------------------------------------------------------
_deployments_path = Path(__file__).parent.parent.parent / "blockchain" / "deployments.json"
if _deployments_path.exists():
    with open(_deployments_path, "r") as _f:
        _deps = json.load(_f)
    _identity_address = _deps.get("IdentityRegistry", IDENTITY_REGISTRY_ADDRESS)
    print(f"[web3_client] Loaded IdentityRegistry address from deployments.json: {_identity_address}")
else:
    _identity_address = IDENTITY_REGISTRY_ADDRESS
    print(f"[web3_client] deployments.json not found — using hardcoded address: {_identity_address}")

# Load ABI dynamically from the Hardhat artifacts
artifacts_path = Path(__file__).parent.parent.parent / "blockchain" / "artifacts" / "contracts" / "IdentityRegistry.sol" / "IdentityRegistry.json"
with open(artifacts_path, "r") as f:
    contract_json = json.load(f)
    IDENTITY_ABI = contract_json["abi"]

# Load AccessControlRegistry ABI to grant OPERATOR_ROLE
access_artifacts_path = Path(__file__).parent.parent.parent / "blockchain" / "artifacts" / "contracts" / "AccessControlRegistry.sol" / "AccessControlRegistry.json"
with open(access_artifacts_path, "r") as f:
    access_abi = json.load(f)["abi"]

identity_contract = w3.eth.contract(address=_identity_address, abi=IDENTITY_ABI)

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
    else:
        print("[web3_client] Backend wallet already has OPERATOR_ROLE.")

# Run role check on startup — wrapped so a bad address is a warning, not a crash.
try:
    _ensure_operator_role()
except Exception as _e:
    warnings.warn(
        f"[web3_client] Startup role-check failed: {_e}\n"
        "The server will start, but blockchain writes may fail until contracts are redeployed "
        "and the address in deployments.json (or config.py) is updated.",
        stacklevel=1,
    )


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


def insert_identity_record(did: str, fingerprint_hash: bytes, left_iris_hash: bytes, right_iris_hash: bytes, parent_wallet: str, ipfs_cid: str, biometric_image_cid: str):
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
        ipfs_cid,
        biometric_image_cid
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
    # (did, fingerprintHash, leftIrisHash, rightIrisHash, parentWallet, ipfsCID, biometricImageCID, isActive)
    
    if not record[7]: # isActive
        return None
        
    return {
        "did": record[0],
        "fingerprintHash": record[1].hex(),
        "leftIrisHash": record[2].hex(),
        "rightIrisHash": record[3].hex(),
        "parentWallet": record[4],
        "ipfsCID": record[5],
        "biometricImageCID": record[6],
        "isActive": record[7]
    }
