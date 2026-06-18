# Cureblock Blockchain Infrastructure

This directory contains the smart contracts, Hardhat configuration, test scripts, and deployment logic for the Cureblock platform, targeted for the Ethereum Sepolia testnet.

## Table of Contents
1. [Prerequisites & Environment Setup](#1-prerequisites--environment-setup)
2. [Installation](#2-installation)
3. [Compilation](#3-compilation)
4. [Testing](#4-testing)
5. [Local Deployment (Hardhat Network)](#5-local-deployment-hardhat-network)
6. [Ethereum Sepolia Deployment](#6-ethereum-sepolia-deployment)
7. [Contracts Overview](#7-contracts-overview)
8. [Team Presentation (Live Demo)](#8-team-presentation-live-demo)

---

## 1. Prerequisites & Environment Setup

Ensure you have the following installed on your system:
- **Node.js** (v18.x or higher)
- **npm** (Node Package Manager)

To securely manage your private keys and RPC URLs, a `.env` file is required. We have provided a template. Open the `.env` file in this directory and replace the placeholders:
```env
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_API_KEY
PRIVATE_KEY=your_metamask_private_key_here
```
> **Warning**: Never commit your `.env` file to GitHub. It is already included in `.gitignore`.

---

## 2. Installation

Navigate to the `blockchain` directory and install all required smart contract dependencies.

### For Linux & macOS
```bash
npm install
```

### For Windows (PowerShell)
> [!NOTE]
> By default, Windows PowerShell disables the execution of custom scripts. If you run into an `UnauthorizedAccess` or execution policy error, use one of the following commands:
> 
> **Direct CMD Bypass (Simplest):**
> ```powershell
> npm.cmd install
> ```
> 
> **Process-level Bypass (Allows standard commands):**
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
> npm install
> ```

---

## 3. Compilation

Compile all Solidity smart contracts to generate the ABI artifacts. This must be done before testing or deploying.

### For Linux & macOS
```bash
npx hardhat compile
```

### For Windows (PowerShell)
```powershell
npx.cmd hardhat compile
# OR (if execution policy was bypassed)
npx hardhat compile
```

---

## 4. Testing

Run the automated test suite to verify contract compilation, smart contract deployment, and Access Control assignments.

### For Linux & macOS
```bash
npx hardhat test
```

### For Windows (PowerShell)
```powershell
npx.cmd hardhat test
# OR (if execution policy was bypassed)
npx hardhat test
```

---

## 5. Local Deployment (Hardhat Network)

To interact with the contracts on a fast, local, simulated blockchain:

### Step A: Start the local Hardhat Node
Run the simulated local blockchain network and leave this terminal running in the background.

**For Linux & macOS:**
```bash
npx hardhat node
```

**For Windows (PowerShell):**
```powershell
npx.cmd hardhat node
```

### Step B: Run the Deployment Script
Open a **second terminal** window, navigate to the `blockchain` directory, and deploy the contracts locally:

**For Linux & macOS:**
```bash
npx hardhat run scripts/deploy.js --network localhost
```

**For Windows (PowerShell):**
```powershell
npx.cmd hardhat run scripts/deploy.js --network localhost
```

---

## 6. Ethereum Sepolia Deployment

Once you are ready to deploy the contracts to the live Sepolia testnet:

1. Ensure your `.env` file is populated with a valid Sepolia RPC URL (e.g. from Alchemy or Infura) and your wallet's `PRIVATE_KEY`.
2. Ensure your wallet has some Sepolia test ETH (obtainable from a Sepolia faucet).
3. Run the following command:

**For Linux & macOS:**
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

**For Windows (PowerShell):**
```powershell
npx.cmd hardhat run scripts/deploy.js --network sepolia
```

> [!TIP]
> The console will output live smart contract addresses for all 7 deployed contracts. Save these addresses, as you will need them to connect your backend/frontend services.

---

## 7. Contracts Overview

- **AccessControlRegistry.sol**: Manages Role-Based Access Control (`PARENT_ROLE`, `OPERATOR_ROLE`, `AUTHORITY_ROLE`, `RECOVERY_CENTRE_ROLE`).
- **IdentityRegistry.sol**: Maps child DIDs to biometric template hashes (Fingerprint & Iris) and metadata. *(Note: Face image processing is excluded in the current phase).*
- **ShadowNode.sol**: Generates privacy-preserving aliases (Shadow IDs) using block entropy.
- **HashRegistry.sol**: Verifies the integrity of off-chain payloads.
- **IoTDataRegistry.sol**: Anchors Merkle roots of 5-minute IoT telemetry batches.
- **EmergencyAlert.sol**: Handles priority SOS triggers, logging GPS and vitals.
- **ForensicBlackBox.sol**: Archives tamper-proof sensor evidence on IPFS with on-chain anchoring.

---

## 8. Demo Presentation 

To present a live demonstration of the core architecture to your team, we have included an end-to-end integration script (`scripts/demo.js`).

**What the demo does:**
1. Uploads a mock JSON file (representing encrypted biometric data or sensor logs) to the decentralized IPFS network via Pinata.
2. Retrieves the newly generated cryptographic IPFS CID.
3. Automatically requests and grants the `AUTHORITY_ROLE` permissions from the `AccessControlRegistry` smart contract.
4. Submits the IPFS CID to the `ForensicBlackBox` smart contract on the live Ethereum Sepolia Testnet to permanently anchor the proof on-chain.

**How to run it:**
1. Ensure your `.env` file is populated with your Sepolia RPC URL, your wallet's Private Key, and your Pinata API keys.
2. Open your terminal in this `blockchain` directory.
3. Run the following command:

**For Linux & macOS:**
```bash
npx hardhat run scripts/demo.js --network sepolia
```

**For Windows (PowerShell):**
```powershell
npx.cmd hardhat run scripts/demo.js --network sepolia
```

The script will output the live transaction hash and the IPFS gateway link so your team can view the anchored data in real-time!
