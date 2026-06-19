package com.cureblock.backend.dto;

import java.time.LocalDate;
import java.util.List;

public class EnrolmentRequest {
 public String name;
 public int age;
 public LocalDate dateOfBirth;
 public String gender;
 public String enrolmentCenter;
 public String externalSubjectId;
 public String aadhaarToken;
 public List<GuardianInput> guardians;
 public List<FingerprintInput> fingerprints;

 public static class GuardianInput {
 public String name;
 public String relationship;
 public String phone;
 public String accessLevel;
 }

 public static class FingerprintInput {
 public String hand;
 public String finger;
 public String imageRef;
 public int qualityPercent;
 }
}