import { expect } from "chai";
import hre from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";

describe("Cureblock Identity Registry & Access Control Tests", function () {
  let accessControl, identityRegistry, shadowNode;
  let owner, operator, parent, stranger;
  let operatorRole, parentRole;

  beforeEach(async function () {
    [owner, operator, parent, stranger] = await hre.ethers.getSigners();

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

    // Get role hashes
    operatorRole = await accessControl.OPERATOR_ROLE();
    parentRole = await accessControl.PARENT_ROLE();

    // Grant OPERATOR_ROLE to operator account
    await accessControl.grantRole(operatorRole, operator.address);
    // Grant PARENT_ROLE to parent account
    await accessControl.grantRole(parentRole, parent.address);
  });

  describe("AccessControlRegistry", function () {
    it("Should assign ADMIN role to deployer/owner", async function () {
      const defaultAdminRole = await accessControl.DEFAULT_ADMIN_ROLE();
      expect(await accessControl.hasRole(defaultAdminRole, owner.address)).to.be.true;
    });

    it("Should correctly grant and check roles", async function () {
      expect(await accessControl.hasRole(operatorRole, operator.address)).to.be.true;
      expect(await accessControl.hasRole(parentRole, parent.address)).to.be.true;
      expect(await accessControl.hasRole(operatorRole, stranger.address)).to.be.false;
    });

    it("Should allow admin to revoke roles", async function () {
      await accessControl.revokeRole(operatorRole, operator.address);
      expect(await accessControl.hasRole(operatorRole, operator.address)).to.be.false;
    });

    it("Should grant AUTHORITY_ROLE with a 24-hour expiration", async function () {
      const authorityRole = await accessControl.AUTHORITY_ROLE();
      
      // Grant authority
      await accessControl.grantAuthority(stranger.address);
      
      // Verify role is active initially
      expect(await accessControl.hasRole(authorityRole, stranger.address)).to.be.true;

      // Fast forward time by 23 hours and 59 minutes
      await time.increase(23 * 60 * 60 + 59 * 60);
      expect(await accessControl.hasRole(authorityRole, stranger.address)).to.be.true;

      // Fast forward time to strictly greater than 24 hours (1 more minute)
      await time.increase(2 * 60);
      
      // Verify role is now expired
      expect(await accessControl.hasRole(authorityRole, stranger.address)).to.be.false;
    });

    it("Should restrict grantAuthority to admin only", async function () {
      await expect(
        accessControl.connect(operator).grantAuthority(stranger.address)
      ).to.be.revertedWithCustomError(accessControl, "AccessControlUnauthorizedAccount");
    });
  });

  describe("IdentityRegistry", function () {
    const did = "did:cureblock:child-123";
    const fingerprintHash = hre.ethers.keccak256(hre.ethers.toUtf8Bytes("fingerprint_template_hash_123"));
    const leftIrisHash = hre.ethers.keccak256(hre.ethers.toUtf8Bytes("left_iris_hash_123"));
    const rightIrisHash = hre.ethers.keccak256(hre.ethers.toUtf8Bytes("right_iris_hash_123"));
    const ipfsCID = "QmXoypizjW3WknFiJnKLwHCnL72vedxjQkDDP1mXWo6uco";
    const biometricImageCID = "QmBiometricFaceImageCID123456789";

    it("Should allow operator to register child identity", async function () {
      await expect(identityRegistry.connect(operator).registerIdentity(
        did,
        fingerprintHash,
        leftIrisHash,
        rightIrisHash,
        parent.address,
        ipfsCID,
        biometricImageCID
      ))
      .to.emit(identityRegistry, "IdentityRegistered")
      .withArgs(did, parent.address);

      // Verify stored data
      const record = await identityRegistry.identities(did);
      expect(record.did).to.equal(did);
      expect(record.fingerprintHash).to.equal(fingerprintHash);
      expect(record.leftIrisHash).to.equal(leftIrisHash);
      expect(record.rightIrisHash).to.equal(rightIrisHash);
      expect(record.parentWallet).to.equal(parent.address);
      expect(record.ipfsCID).to.equal(ipfsCID);
      expect(record.biometricImageCID).to.equal(biometricImageCID);
      expect(record.isActive).to.be.true;
    });

    it("Should revert if non-operator tries to register identity", async function () {
      await expect(identityRegistry.connect(stranger).registerIdentity(
        did,
        fingerprintHash,
        leftIrisHash,
        rightIrisHash,
        parent.address,
        ipfsCID,
        biometricImageCID
      )).to.be.revertedWith("IdentityRegistry: Must have OPERATOR_ROLE");
    });

    it("Should revert when trying to register duplicate DID", async function () {
      // First registration
      await identityRegistry.connect(operator).registerIdentity(
        did,
        fingerprintHash,
        leftIrisHash,
        rightIrisHash,
        parent.address,
        ipfsCID,
        biometricImageCID
      );

      // Second registration of same DID should revert
      await expect(identityRegistry.connect(operator).registerIdentity(
        did,
        fingerprintHash,
        leftIrisHash,
        rightIrisHash,
        parent.address,
        ipfsCID,
        biometricImageCID
      )).to.be.revertedWith("IdentityRegistry: Identity already exists");
    });
  });

  describe("ShadowNode", function () {
    const did = "did:cureblock:child-456";

    it("Should generate unique Shadow ID", async function () {
      const tx = await shadowNode.generateShadowID(did);
      const receipt = await tx.wait();
      
      // Get shadow ID from getter
      const shadowID = await shadowNode.getShadowID(did);
      expect(shadowID).to.not.equal(hre.ethers.ZeroHash);

      // Check event
      const event = receipt.logs.find(log => log.fragment && log.fragment.name === "ShadowIDGenerated");
      expect(event).to.not.be.undefined;
      expect(event.args[0]).to.equal(did);
      expect(event.args[1]).to.equal(shadowID);
    });

    it("Should revert on generating duplicate Shadow ID for same DID", async function () {
      await shadowNode.generateShadowID(did);
      await expect(shadowNode.generateShadowID(did))
        .to.be.revertedWith("ShadowNode: Shadow ID already exists for this DID");
    });
  });
});
