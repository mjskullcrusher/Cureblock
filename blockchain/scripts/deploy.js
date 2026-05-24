import hre from "hardhat";

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
  console.log(`IdentityRegistry deployed to: ${await identityRegistry.getAddress()}\n`);

  // 3. Deploy ShadowNode
  console.log("Deploying ShadowNode...");
  const ShadowNode = await hre.ethers.getContractFactory("ShadowNode");
  const shadowNode = await ShadowNode.deploy();
  await shadowNode.waitForDeployment();
  console.log(`ShadowNode deployed to: ${await shadowNode.getAddress()}\n`);

  // 4. Deploy HashRegistry
  console.log("Deploying HashRegistry...");
  const HashRegistry = await hre.ethers.getContractFactory("HashRegistry");
  const hashRegistry = await HashRegistry.deploy(accessControlAddress);
  await hashRegistry.waitForDeployment();
  console.log(`HashRegistry deployed to: ${await hashRegistry.getAddress()}\n`);

  // 5. Deploy IoTDataRegistry
  console.log("Deploying IoTDataRegistry...");
  const IoTDataRegistry = await hre.ethers.getContractFactory("IoTDataRegistry");
  const ioTDataRegistry = await IoTDataRegistry.deploy(accessControlAddress);
  await ioTDataRegistry.waitForDeployment();
  console.log(`IoTDataRegistry deployed to: ${await ioTDataRegistry.getAddress()}\n`);

  // 6. Deploy EmergencyAlert
  console.log("Deploying EmergencyAlert...");
  const EmergencyAlert = await hre.ethers.getContractFactory("EmergencyAlert");
  const emergencyAlert = await EmergencyAlert.deploy();
  await emergencyAlert.waitForDeployment();
  console.log(`EmergencyAlert deployed to: ${await emergencyAlert.getAddress()}\n`);

  // 7. Deploy ForensicBlackBox
  console.log("Deploying ForensicBlackBox...");
  const ForensicBlackBox = await hre.ethers.getContractFactory("ForensicBlackBox");
  const forensicBlackBox = await ForensicBlackBox.deploy(accessControlAddress);
  await forensicBlackBox.waitForDeployment();
  console.log(`ForensicBlackBox deployed to: ${await forensicBlackBox.getAddress()}\n`);

  console.log("All contracts deployed successfully!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
