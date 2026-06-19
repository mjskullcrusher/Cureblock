package com.cureblock.backend.controller;

import com.cureblock.backend.dto.EnrolmentRequest;
import com.cureblock.backend.model.Child;
import com.cureblock.backend.service.EnrolmentService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/enrolment")
public class EnrolmentController {

 private final EnrolmentService enrolmentService;

 public EnrolmentController(EnrolmentService enrolmentService) {
 this.enrolmentService = enrolmentService;
 }

 @PostMapping
 public Map<String, Object> enrol(@RequestBody EnrolmentRequest request) {
 Child saved = enrolmentService.enrolChild(request);
 return Map.of(
                 "status", "success",
                 "childId", saved.getId(),
                 "name", saved.getName()
                 );
 }
}