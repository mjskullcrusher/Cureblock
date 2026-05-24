import hre from "hardhat";
import * as dotenv from "dotenv";
dotenv.config();

// Contract addresses from the recent deployment
const ACCESS_CONTROL_ADDR = "0xf7730b4F50ffc719341adB8f38bF0D671E01C53F";
const FORENSIC_BOX_ADDR = "0xea4dEF8d1b7FBFb5a3390b4aFddD500132606EdC";

async function uploadToPinata(jsonData) {
    console.log("Uploading encrypted biometric data to IPFS via Pinata...");
    const url = `https://api.pinata.cloud/pinning/pinJSONToIPFS`;
    
    const response = await fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            pinata_api_key: process.env.PINATA_API_KEY,
            pinata_secret_api_key: process.env.PINATA_SECRET,
        },
        body: JSON.stringify({
            pinataContent: jsonData,
            pinataMetadata: { name: "Cureblock_Demo_Data.json" }
        })
    });
    
    const data = await response.json();
    if (!data.IpfsHash) {
        throw new Error("Failed to upload to Pinata: " + JSON.stringify(data));
    }
    console.log(`Success! File pinned to IPFS with CID: ${data.IpfsHash}`);
    return data.IpfsHash;
}

async function main() {
    console.log("==========================================");
    console.log("  CUREBLOCK DEMONSTRATION SCRIPT");
    console.log("==========================================\n");

    const [deployer] = await hre.ethers.getSigners();
    console.log(`Connected with wallet: ${deployer.address}\n`);

    // 1. Upload mock data to IPFS
    const mockData = {
        shadowID: "SHADOW-84920",
        encryptedMinutiae: "0x18485a9bc3... (encrypted payload)",
        timestamp: new Date().toISOString()
    };
    
    let cid;
    try {
        cid = await uploadToPinata(mockData);
    } catch (error) {
         console.error("\n❌ IPFS Upload Failed!");
         console.error("Please ensure your PINATA_API_KEY and PINATA_SECRET in the .env file are valid.");
         console.error(error.message);
         console.log("\n(We will use a mock CID to continue the blockchain portion of the demo...)");
         cid = "QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG"; // Mock CID fallback
    }

    // 2. Grant AUTHORITY_ROLE to our wallet so we can write to ForensicBlackBox
    console.log("\nGranting AUTHORITY_ROLE to our wallet (so we can interact with ForensicBlackBox)...");
    const AccessControl = await hre.ethers.getContractAt("AccessControlRegistry", ACCESS_CONTROL_ADDR);
    const AUTHORITY_ROLE = await AccessControl.AUTHORITY_ROLE();
    
    const hasRole = await AccessControl.hasRole(AUTHORITY_ROLE, deployer.address);
    if (!hasRole) {
        const txGrant = await AccessControl.grantRole(AUTHORITY_ROLE, deployer.address);
        await txGrant.wait();
        console.log("✅ Role granted!");
    } else {
        console.log("✅ Wallet already has AUTHORITY_ROLE.");
    }

    // 3. Anchor the IPFS CID onto the Sepolia Blockchain
    console.log(`\nAnchoring IPFS CID (${cid}) to Sepolia Blockchain...`);
    const ForensicBox = await hre.ethers.getContractAt("ForensicBlackBox", FORENSIC_BOX_ADDR);
    
    // Create a dummy Merkle root (32 bytes) for the demo
    const dummyMerkleRoot = hre.ethers.id("mock_merkle_root");
    
    const tx = await ForensicBox.storeEvidenceBundle("SHADOW-84920", cid, dummyMerkleRoot);
    console.log(`Transaction submitted! Waiting for confirmation...`);
    console.log(`Tx Hash: ${tx.hash}`);
    
    await tx.wait();
    console.log(`\n🎉 Demonstration Complete!`);
    console.log(`------------------------------------------`);
    console.log(`🔗 View Transaction on Etherscan: https://sepolia.etherscan.io/tx/${tx.hash}`);
    console.log(`📂 View IPFS Data: https://gateway.pinata.cloud/ipfs/${cid}`);
    console.log(`------------------------------------------\n`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
