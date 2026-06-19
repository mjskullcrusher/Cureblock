package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "blockchain_record")
@Data
public class BlockchainRecord {
    @Id @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "child_id")
    private Child child;

    private String transactionId;    // txn hash returned by the chain (stub until live)
    private String anchoredHash;     // the SHA-256 that was anchored
    private String ipfsCid;          // the CID anchored alongside

    @Enumerated(EnumType.STRING)
    private CaptureStage stage;

    private boolean verified;
    private String mismatchReason;
    private LocalDateTime timestamp;
}
