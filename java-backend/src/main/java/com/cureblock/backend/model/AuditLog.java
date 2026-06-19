package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "audit_log")
@Data
public class AuditLog {
    @Id @GeneratedValue
    private UUID id;

    @Enumerated(EnumType.STRING)
    private AuditAction action;

    private String userName;     // who performed it
    private String recordId;     // affected record (child id, etc.)
    private String details;
    private LocalDateTime timestamp;
}
