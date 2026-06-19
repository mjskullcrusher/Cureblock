package com.cureblock.backend.dto;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public class ChildDetailResponse {
 public UUID id;
 public String name;
 public int age;
 public LocalDate dateOfBirth;
 public String gender;
 public String status;
 public String externalSubjectId;
 public String enrolmentCenter;
 public boolean safe;

 public List<GuardianDto> guardians;
 public List<FingerprintDto> fingerprints;
 public AadhaarDto aadhaar;
 public BlockchainDto blockchain;

 public static class GuardianDto {
 public String name;
 public String relationship;
 public String phone;
 public String accessLevel;
 }
 public static class FingerprintDto {
 public String hand;
 public String finger;
 public String ipfsCid;
 public String sha256Hash;
 public int qualityPercent;
 }
 public static class AadhaarDto {
 public String aadhaarToken;
 public String status;
 }
 public static class BlockchainDto {
 public String transactionId;
 public String anchoredHash;
 public boolean verified;
 }
}
