package com.cureblock.backend.config;

import com.cureblock.backend.dto.EnrolmentRequest;
import com.cureblock.backend.repository.ChildRepository;
import com.cureblock.backend.service.EnrolmentService;
import com.opencsv.CSVReader;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.InputStreamReader;
import java.time.LocalDate;
import java.util.*;

@Component
public class DatasetLoader implements CommandLineRunner {

 private final EnrolmentService enrolmentService;
 private final ChildRepository childRepository;

 // ---- change to 200 (or more) once the 10-subject test looks right ----
         private static final int SUBJECT_LIMIT = 200;

 public DatasetLoader(EnrolmentService enrolmentService, ChildRepository childRepository) {
 this.enrolmentService = enrolmentService;
 this.childRepository = childRepository;
 }

 @Override
 public void run(String... args) throws Exception {
 // Skip if children already loaded (so it doesn't duplicate every restart)
 if (childRepository.count() > 0) {
 System.out.println(">> Children already exist (" + childRepository.count()
                     + "). Skipping dataset import.");
 return;
 }

 // 1. Read CSV, group rows by PSN (subject)
 Map<String, List<String[]>> bySubject = new LinkedHashMap<>();
 try (CSVReader reader = new CSVReader(new InputStreamReader(
                 new ClassPathResource("enriched_nfiq2_dataset.csv").getInputStream()))) {
 reader.readNext(); // skip header
 String[] row;
 while ((row = reader.readNext()) != null) {
 if (row.length < 16) continue;  // skip malformed rows
 String psn = row[1];
 bySubject.computeIfAbsent(psn, k -> new ArrayList<>()).add(row);
 }
 }

 // 2. Enrol one child per subject
 int count = 0;
 for (Map.Entry<String, List<String[]>> entry : bySubject.entrySet()) {
 if (count >= SUBJECT_LIMIT) break;
 String psn = entry.getKey();
 List<String[]> rows = entry.getValue();
 String[] first = rows.get(0);

 EnrolmentRequest req = new EnrolmentRequest();
 req.externalSubjectId = psn;
 req.name = "Subject " + psn;  // hybrid: generated name
 req.age = parseIntSafe(first[11], 10);
 req.gender = first[15].trim().toLowerCase(); // "male"/"female"
 req.enrolmentCenter = "Dataset Import";
 req.dateOfBirth = LocalDate.now().minusYears(req.age);
 req.aadhaarToken = "TOK-" + psn.replaceAll("\\s", ""); // hybrid: generated
 req.guardians = generatedGuardian(psn); // hybrid: one fake guardian
 req.fingerprints = new ArrayList<>();

 for (String[] r : rows) {
 String[] hf = parseFinger(r[6]);  // "02_Right_Index" -> [RIGHT, INDEX]
 if (hf == null) continue;
 EnrolmentRequest.FingerprintInput f = new EnrolmentRequest.FingerprintInput();
 f.hand = hf[0];
 f.finger = hf[1];
 f.imageRef = r[0];  // the Image_Path (text)
 f.qualityPercent = parseIntSafe(r[3], 0); // NFIQ2 score
 req.fingerprints.add(f);
 }

 enrolmentService.enrolChild(req);
 count++;
 System.out.println(">> Enrolled subject " + psn + " with "
                     + req.fingerprints.size() + " fingerprints");
 }
 System.out.println(">> DATASET IMPORT DONE. Subjects enrolled: " + count);
 }

 // "02_Right_Index" -> ["RIGHT","INDEX"]
         private String[] parseFinger(String label) {
 if (label == null) return null;
 String up = label.toUpperCase();
 String hand = up.contains("LEFT") ? "LEFT" : up.contains("RIGHT") ? "RIGHT" : null;
 String finger = up.contains("THUMB") ? "THUMB"
 : up.contains("INDEX") ? "INDEX"
 : up.contains("MIDDLE") ? "MIDDLE"
 : up.contains("RING") ? "RING"
 : up.contains("LITTLE") ? "LITTLE" : null;
 if (hand == null || finger == null) return null;
 return new String[]{hand, finger};
 }

 private List<EnrolmentRequest.GuardianInput> generatedGuardian(String psn) {
 EnrolmentRequest.GuardianInput g = new EnrolmentRequest.GuardianInput();
 g.name = "Guardian of " + psn;
 g.relationship = "Parent";
 g.phone = "90000" + Math.abs(psn.hashCode() % 100000);
 g.accessLevel = "full";
 List<EnrolmentRequest.GuardianInput> list = new ArrayList<>();
 list.add(g);
 return list;
 }

 private int parseIntSafe(String s, int fallback) {
 try { return Integer.parseInt(s.trim()); } catch (Exception e) { return fallback; }
 }
}