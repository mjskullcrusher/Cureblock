package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "biometric_template")
@Data
public class BiometricTemplate {
    @Id @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "child_id")
    private Child child;

    @Enumerated(EnumType.STRING)
    private Hand hand;

    @Enumerated(EnumType.STRING)
    private Finger finger;

    // IPFS content id pointing to the encrypted fingerprint image (stub until IPFS live)
    private String ipfsCid;

    // SHA-256 of the file, for integrity / blockchain anchoring
    private String sha256Hash;

    @Enumerated(EnumType.STRING)
    private CaptureStage captureStage;

    private int qualityPercent;
    private String algorithmVersion;
    private LocalDateTime capturedAt;
}
