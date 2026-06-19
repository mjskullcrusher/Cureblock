package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "aadhaar_reference")
@Data
public class AadhaarReference {
    @Id @GeneratedValue
    private UUID id;

    @OneToOne
    @JoinColumn(name = "child_id")
    private Child child;

    // tokenized / hashed reference only — never the raw Aadhaar number
    private String aadhaarToken;

    @Enumerated(EnumType.STRING)
    private AadhaarStatus status;

    private LocalDateTime linkedAt;
}
