package com.cureblock.backend.service;

import com.cureblock.backend.dto.ChildDetailResponse;
import com.cureblock.backend.dto.ChildSummaryResponse;
import com.cureblock.backend.model.*;
import com.cureblock.backend.repository.BlockchainRecordRepository;
import com.cureblock.backend.repository.ChildRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ChildQueryService {

 private final ChildRepository childRepository;
 private final BlockchainRecordRepository blockchainRecordRepository;

 public ChildQueryService(ChildRepository childRepository,
BlockchainRecordRepository blockchainRecordRepository) {
 this.childRepository = childRepository;
 this.blockchainRecordRepository = blockchainRecordRepository;
 }

 // list (paginated) -> summaries
         public Page<ChildSummaryResponse> listChildren(Pageable pageable) {
 return childRepository.findAll(pageable).map(this::toSummary);
 }

 // one child -> full detail
         public Optional<ChildDetailResponse> getChild(UUID id) {
 return childRepository.findById(id).map(this::toDetail);
}

 private ChildSummaryResponse toSummary(Child c) {
 ChildSummaryResponse r = new ChildSummaryResponse();
 r.id = c.getId();
 r.name = c.getName();
 r.age = c.getAge();
 r.gender = c.getGender() != null ? c.getGender().name() : null;
 r.status = c.getStatus() != null ? c.getStatus().name() : null;
 r.externalSubjectId = c.getExternalSubjectId();
 r.enrolmentCenter = c.getEnrolmentCenter();
 return r;
 }

 private ChildDetailResponse toDetail(Child c) {
 ChildDetailResponse r = new ChildDetailResponse();
 r.id = c.getId();
 r.name = c.getName();
 r.age = c.getAge();
 r.dateOfBirth = c.getDateOfBirth();
 r.gender = c.getGender() != null ? c.getGender().name() : null;
 r.status = c.getStatus() != null ? c.getStatus().name() : null;
 r.externalSubjectId = c.getExternalSubjectId();
 r.enrolmentCenter = c.getEnrolmentCenter();
 r.safe = c.isSafe();

 // guardians
 r.guardians = new ArrayList<>();
 if (c.getGuardians() != null) {
 for (Guardian g : c.getGuardians()) {
 ChildDetailResponse.GuardianDto gd = new ChildDetailResponse.GuardianDto();
 gd.name = g.getName();
 gd.relationship = g.getRelationship();
 gd.phone = g.getPhone();
 gd.accessLevel = g.getAccessLevel() != null ? g.getAccessLevel().name() : null;
 r.guardians.add(gd);
 }
 }

 // fingerprints
 r.fingerprints = new ArrayList<>();
 if (c.getBiometricTemplates() != null) {
 for (BiometricTemplate t : c.getBiometricTemplates()) {
 ChildDetailResponse.FingerprintDto fd = new ChildDetailResponse.FingerprintDto();
 fd.hand = t.getHand() != null ? t.getHand().name() : null;
 fd.finger = t.getFinger() != null ? t.getFinger().name() : null;
 fd.ipfsCid = t.getIpfsCid();
 fd.sha256Hash = t.getSha256Hash();
 fd.qualityPercent = t.getQualityPercent();
 r.fingerprints.add(fd);
 }
 }

 // aadhaar
 if (c.getAadhaarReference() != null) {
 ChildDetailResponse.AadhaarDto ad = new ChildDetailResponse.AadhaarDto();
 ad.aadhaarToken = c.getAadhaarReference().getAadhaarToken();
 ad.status = c.getAadhaarReference().getStatus() != null
 ? c.getAadhaarReference().getStatus().name() : null;
 r.aadhaar = ad;
 }

 // blockchain (latest record for this child)
 List<BlockchainRecord> records = blockchainRecordRepository.findAll();
 for (BlockchainRecord br : records) {
 if (br.getChild() != null && br.getChild().getId().equals(c.getId())) {
 ChildDetailResponse.BlockchainDto bd = new ChildDetailResponse.BlockchainDto();
 bd.transactionId = br.getTransactionId();
 bd.anchoredHash = br.getAnchoredHash();
 bd.verified = br.isVerified();
 r.blockchain = bd;
 break;
 }
 }

 return r;
 }
}