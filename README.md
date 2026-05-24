# Cureblock: Child Safety & Identification Platform

Cureblock is a decentralized, end-to-end child safety platform that integrates IoT hardware, biometric template matching, and blockchain technology to provide tamper-proof identification, real-time monitoring, and forensic data anchoring.

## Architecture Overview

The system is composed of three main layers:

1. **Hardware / IoT Layer** *(Mantra Aadhaar Scanners & Wearables)*
   - Captures ISO-19794-2 biometric templates (Fingerprint & Iris) during registration.
   - Wearable devices transmit real-time GPS, heart rate, temperature, and motion data without storing biometric data locally.

2. **Backend Services** `(/backend)`
   - Built with **Python (FastAPI)** and PostgreSQL.
   - Encrypts incoming biometric templates and sensor logs.
   - Handles pinning encrypted forensic evidence to the decentralized **IPFS** network.
   - Interacts with the blockchain via Ethers/Web3 to anchor IPFS CIDs.

3. **Blockchain Infrastructure** `(/blockchain)`
   - Built with **Solidity** and deployed to the **Ethereum Sepolia Testnet**.
   - **IdentityRegistry**: Maps cryptographic DIDs to biometric template hashes (SHA-256).
   - **ForensicBlackBox**: Permanently anchors IPFS CIDs containing court-admissible sensor/evidence logs.
   - **AccessControlRegistry**: Manages strict Role-Based Access Control (Parents, Operators, Authorities).

## Repository Structure

```
Cureblock/
├── backend/          # Python FastAPI backend, database models, and IPFS logic
├── blockchain/       # Hardhat environment, Solidity smart contracts, and deploy scripts
└── README.md         # Project root documentation
```

## Getting Started

To explore or run the specific components of this project, please refer to the dedicated README files located within each subsystem:

- [Blockchain Documentation & Live Demo Instructions](./blockchain/README.md)
- *Backend Documentation (Coming Soon)*

## License
MIT License