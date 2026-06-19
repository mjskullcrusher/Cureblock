package com.cureblock.backend.controller;

import com.cureblock.backend.dto.ChildDetailResponse;
import com.cureblock.backend.dto.ChildSummaryResponse;
import com.cureblock.backend.service.ChildQueryService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/children")
public class ChildController {

 private final ChildQueryService childQueryService;

 public ChildController(ChildQueryService childQueryService) {
 this.childQueryService = childQueryService;
 }

 @GetMapping
 public Page<ChildSummaryResponse> list(Pageable pageable) {
 return childQueryService.listChildren(pageable);
 }

 @GetMapping("/{id}")
 public ResponseEntity<ChildDetailResponse> getOne(@PathVariable UUID id) {
 return childQueryService.getChild(id)
 .map(ResponseEntity::ok)
 .orElse(ResponseEntity.notFound().build());
 }
}
