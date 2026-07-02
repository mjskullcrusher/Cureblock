import hre from "hardhat";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function main() {
  console.log("Starting deployment of Cureblock Smart Contracts...\n");

  // 1. Deploy AccessControlRegistry
  console.log("Deploying AccessControlRegistry...");
  const AccessControlRegistry = await hre.ethers.getContractFactory("AccessControlRegistry");
  const accessControl = await AccessControlRegistry.deploy();
  await accessControl.waitForDeployment();
  const accessControlAddress = await accessControl.getAddress();
  console.log(`AccessControlRegistry deployed to: ${accessControlAddress}\n`);

  // 2. Deploy IdentityRegistry
  console.log("Deploying IdentityRegistry...");
  const IdentityRegistry = await hre.ethers.getContractFactory("IdentityRegistry");
  const identityRegistry = await IdentityRegistry.deploy(accessControlAddress);
  await identityRegistry.waitForDeployment();
  const identityRegistryAddress = await identityRegistry.getAddress();
  console.log(`IdentityRegistry deployed to: ${identityRegistryAddress}\n`);

  // 3. Deploy ShadowNode
  console.log("Deploying ShadowNode...");
  const ShadowNode = await hre.ethers.getContractFactory("ShadowNode");
  const shadowNode = await ShadowNode.deploy();
  await shadowNode.waitForDeployment();
  const shadowNodeAddress = await shadowNode.getAddress();
  console.log(`ShadowNode deployed to: ${shadowNodeAddress}\n`);

  // 4. Deploy HashRegistry
  console.log("Deploying HashRegistry...");
  const HashRegistry = await hre.ethers.getContractFactory("HashRegistry");
  const hashRegistry = await HashRegistry.deploy(accessControlAddress);
  await hashRegistry.waitForDeployment();
  const hashRegistryAddress = await hashRegistry.getAddress();
  console.log(`HashRegistry deployed to: ${hashRegistryAddress}\n`);

  // 5. Deploy IoTDataRegistry
  console.log("Deploying IoTDataRegistry...");
  const IoTDataRegistry = await hre.ethers.getContractFactory("IoTDataRegistry");
  const ioTDataRegistry = await IoTDataRegistry.deploy(accessControlAddress);
  await ioTDataRegistry.waitForDeployment();
  const ioTDataRegistryAddress = await ioTDataRegistry.getAddress();
  console.log(`IoTDataRegistry deployed to: ${ioTDataRegistryAddress}\n`);

  // 6. Deploy EmergencyAlert
  console.log("Deploying EmergencyAlert...");
  const EmergencyAlert = await hre.ethers.getContractFactory("EmergencyAlert");
  const emergencyAlert = await EmergencyAlert.deploy();
  await emergencyAlert.waitForDeployment();
  const emergencyAlertAddress = await emergencyAlert.getAddress();
  console.log(`EmergencyAlert deployed to: ${emergencyAlertAddress}\n`);

  // 7. Deploy ForensicBlackBox
  console.log("Deploying ForensicBlackBox...");
  const ForensicBlackBox = await hre.ethers.getContractFactory("ForensicBlackBox");
  const forensicBlackBox = await ForensicBlackBox.deploy(accessControlAddress);
  await forensicBlackBox.waitForDeployment();
  const forensicBlackBoxAddress = await forensicBlackBox.getAddress();
  console.log(`ForensicBlackBox deployed to: ${forensicBlackBoxAddress}\n`);

  console.log("All contracts deployed successfully!");

  // Save all addresses to deployments.json for the backend to consume
  const deployments = {
    network: hre.network.name,
    deployedAt: new Date().toISOString(),
    AccessControlRegistry: accessControlAddress,
    IdentityRegistry: identityRegistryAddress,
    ShadowNode: shadowNodeAddress,
    HashRegistry: hashRegistryAddress,
    IoTDataRegistry: ioTDataRegistryAddress,
    EmergencyAlert: emergencyAlertAddress,
    ForensicBlackBox: forensicBlackBoxAddress,
  };

  const outPath = path.join(__dirname, "..", "deployments.json");
  fs.writeFileSync(outPath, JSON.stringify(deployments, null, 2));
  console.log(`\nAddresses saved to: ${outPath}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
