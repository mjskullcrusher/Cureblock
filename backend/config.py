import os
# pyrefly: ignore [missing-import]
from dotenv import load_dotenv
from pathlib import Path

# Load .env from the blockchain directory so we share the same keys
env_path = Path(__file__).parent.parent / "blockchain" / ".env"
load_dotenv(dotenv_path=env_path)

RPC_URL = os.getenv("RPC_URL")
PRIVATE_KEY = os.getenv("PRIVATE_KEY")
PINATA_API_KEY = os.getenv("PINATA_API_KEY")
PINATA_SECRET = os.getenv("PINATA_SECRET")
AES_ENCRYPTION_KEY = os.getenv("AES_ENCRYPTION_KEY")

# This will be updated once the contract redeploys
IDENTITY_REGISTRY_ADDRESS = "0xAf28dD3Fc9297b22866972160E3CF20EC8C13974"
