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

Open your terminal (PowerShell, Command Prompt, or VS Code Terminal), navigate to this `blockchain` directory, and run:
```bash
npm install
```
This will install Hardhat, OpenZeppelin Contracts, Ethers.js, and all testing utilities.

---

## 3. Compilation

Compile all Solidity smart contracts into ABI artifacts. This must be done before testing or deploying.
```bash
npx hardhat compile
```
*If successful, you will see "Compiled 7 Solidity files successfully."*

---

## 4. Testing

We have included automated tests to ensure all contracts deploy correctly and access controls function properly.
```bash
npx hardhat test
```
*Expect to see passing checkmarks for the Deployment suite.*

---

## 5. Local Deployment (Hardhat Network)

To interact with the contracts on a fast, local, simulated blockchain (useful for frontend development without paying gas fees):

**Step A:** Start the local Hardhat node. Open a terminal and run:
```bash
npx hardhat node
```
*(Leave this terminal running. It will give you 20 test accounts with 10000 fake ETH each).*

**Step B:** Open a **second terminal** (keep the first one running), navigate to this directory, and run the deployment script targeting the local network:
```bash
npx hardhat run scripts/deploy.js --network localhost
```

---

## 6. Ethereum Sepolia Deployment

Once you are ready to deploy the contracts to the live Sepolia testnet:

1. Ensure your `.env` file is populated with a valid Sepolia RPC URL (from Alchemy or Infura) and a Private Key.
2. Ensure the wallet associated with that Private Key has Sepolia test ETH (you can get this from a Sepolia Faucet).
3. Run the following command:
```bash
npx hardhat run scripts/deploy.js --network sepolia
```
The console will output the live contract addresses for all 7 deployed smart contracts. Save these addresses, as you will need them to connect your frontend/backend.

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
```bash
npx hardhat run scripts/demo.js --network sepolia
```

The script will output the live transaction hash and the IPFS gateway link so your team can view the anchored data in real-time!
