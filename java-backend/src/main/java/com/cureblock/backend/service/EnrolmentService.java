package com.cureblock.backend.service;

import com.cureblock.backend.blockchain.BlockchainService;
import com.cureblock.backend.dto.EnrolmentRequest;
import com.cureblock.backend.model.*;
import com.cureblock.backend.repository.*;
import com.cureblock.backend.util.HashUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class EnrolmentService {

 private final ChildRepository childRepository;
 private final GuardianRepository guardianRepository;
 private final BlockchainRecordRepository blockchainRecordRepository;
 private final AuditLogRepository auditLogRepository;
 private final BlockchainService blockchainService;

 public EnrolmentService(ChildRepository childRepository,
 GuardianRepository guardianRepository,
 BlockchainRecordRepository blockchainRecordRepository,
 AuditLogRepository auditLogRepository,
 BlockchainService blockchainService) {
 this.childRepository = childRepository;
 this.guardianRepository = guardianRepository;
 this.blockchainRecordRepository = blockchainRecordRepository;
 this.auditLogRepository = auditLogRepository;
 this.blockchainService = blockchainService;
 }

 @Transactional
 public Child enrolChild(EnrolmentRequest req) {

 // 1. Child demographics
 Child child = new Child();
 child.setName(req.name);
 child.setAge(req.age);
 child.setDateOfBirth(req.dateOfBirth);
 child.setGender(Gender.valueOf(req.gender));
 child.setStatus(ChildStatus.active);
 child.setEnrolmentCenter(req.enrolmentCenter);
 child.setEnrolmentDate(LocalDateTime.now());
 child.setSafe(true);
 child.setExternalSubjectId(req.externalSubjectId);

 // 2. Guardians
 List<Guardian> guardians = new ArrayList<>();
 if (req.guardians != null) {
 for (EnrolmentRequest.GuardianInput g : req.guardians) {
 Guardian guardian = new Guardian();
 guardian.setName(g.name);
 guardian.setRelationship(g.relationship);
 guardian.setPhone(g.phone);
 guardian.setAccessLevel(GuardianAccessLevel.valueOf(g.accessLevel));
 guardians.add(guardian);
 }
 }
 guardianRepository.saveAll(guardians);
 child.setGuardians(guardians);

 // 3. Aadhaar reference (tokenized)
 if (req.aadhaarToken != null) {
 AadhaarReference aadhaar = new AadhaarReference();
 aadhaar.setAadhaarToken(req.aadhaarToken);
 aadhaar.setStatus(AadhaarStatus.linked);
 aadhaar.setLinkedAt(LocalDateTime.now());
 aadhaar.setChild(child);
 child.setAadhaarReference(aadhaar);
 }

 // 4. Biometric templates (one per finger)
 List<BiometricTemplate> templates = new ArrayList<>();
 StringBuilder hashSource = new StringBuilder(child.getName());
 if (req.fingerprints != null) {
 for (EnrolmentRequest.FingerprintInput f : req.fingerprints) {
 BiometricTemplate t = new BiometricTemplate();
 t.setHand(Hand.valueOf(f.hand));
 t.setFinger(Finger.valueOf(f.finger));
 t.setIpfsCid("STUB-CID-" + f.imageRef);
 t.setSha256Hash(HashUtil.sha256(f.imageRef));
 t.setCaptureStage(CaptureStage.BIRTH);
 t.setQualityPercent(f.qualityPercent);
 t.setAlgorithmVersion("v1-stub");
 t.setCapturedAt(LocalDateTime.now());
 t.setChild(child);
 templates.add(t);
 hashSource.append(f.imageRef);
 }
 }
 child.setBiometricTemplates(templates);

 // 5. Save child (cascades guardians link, aadhaar, biometrics)
 Child saved = childRepository.save(child);

 // 6. Blockchain anchor (STUB)
 String recordHash = HashUtil.sha256(hashSource.toString());
 Map<String, String> chain = blockchainService.anchorToChain(
           saved.getId().toString(), "STUB-CID", recordHash);

 BlockchainRecord br = new BlockchainRecord();
 br.setChild(saved);
 br.setTransactionId(chain.get("txnId"));
 br.setAnchoredHash(recordHash);
 br.setIpfsCid(chain.getOrDefault("ipfsCid", "STUB-CID"));
 br.setStage(CaptureStage.BIRTH);
 br.setVerified(true);
 br.setTimestamp(LocalDateTime.now());
 blockchainRecordRepository.save(br);

 // 7. Audit log
 AuditLog log = new AuditLog();
 log.setAction(AuditAction.ENROLMENT);
 log.setUserName("operator1");
 log.setRecordId(saved.getId().toString());
 log.setDetails("Child enrolled: " + saved.getName());
 log.setTimestamp(LocalDateTime.now());
 auditLogRepository.save(log);

 return saved;
 }
}