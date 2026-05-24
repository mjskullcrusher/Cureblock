import { expect } from "chai";
import hre from "hardhat";

describe("Cureblock Smart Contracts Deployment", function () {
  let accessControl, identityRegistry, shadowNode, hashRegistry, ioTDataRegistry, emergencyAlert, forensicBlackBox;
  let owner, addr1;

  before(async function () {
    [owner, addr1] = await hre.ethers.getSigners();

    // 1. Deploy AccessControlRegistry
    const AccessControlRegistry = await hre.ethers.getContractFactory("AccessControlRegistry");
    accessControl = await AccessControlRegistry.deploy();
    const accessControlAddress = await accessControl.getAddress();

    // 2. Deploy IdentityRegistry
    const IdentityRegistry = await hre.ethers.getContractFactory("IdentityRegistry");
    identityRegistry = await IdentityRegistry.deploy(accessControlAddress);

    // 3. Deploy ShadowNode
    const ShadowNode = await hre.ethers.getContractFactory("ShadowNode");
    shadowNode = await ShadowNode.deploy();

    // 4. Deploy HashRegistry
    const HashRegistry = await hre.ethers.getContractFactory("HashRegistry");
    hashRegistry = await HashRegistry.deploy(accessControlAddress);

    // 5. Deploy IoTDataRegistry
    const IoTDataRegistry = await hre.ethers.getContractFactory("IoTDataRegistry");
    ioTDataRegistry = await IoTDataRegistry.deploy(accessControlAddress);

    // 6. Deploy EmergencyAlert
    const EmergencyAlert = await hre.ethers.getContractFactory("EmergencyAlert");
    emergencyAlert = await EmergencyAlert.deploy();

    // 7. Deploy ForensicBlackBox
    const ForensicBlackBox = await hre.ethers.getContractFactory("ForensicBlackBox");
    forensicBlackBox = await ForensicBlackBox.deploy(accessControlAddress);
  });

  it("Should deploy all contracts successfully", async function () {
    expect(await accessControl.getAddress()).to.be.properAddress;
    expect(await identityRegistry.getAddress()).to.be.properAddress;
    expect(await shadowNode.getAddress()).to.be.properAddress;
    expect(await hashRegistry.getAddress()).to.be.properAddress;
    expect(await ioTDataRegistry.getAddress()).to.be.properAddress;
    expect(await emergencyAlert.getAddress()).to.be.properAddress;
    expect(await forensicBlackBox.getAddress()).to.be.properAddress;
  });

  it("Should assign DEFAULT_ADMIN_ROLE to deployer in AccessControlRegistry", async function () {
    const defaultAdminRole = await accessControl.DEFAULT_ADMIN_ROLE();
    expect(await accessControl.hasRole(defaultAdminRole, owner.address)).to.be.true;
  });
});
