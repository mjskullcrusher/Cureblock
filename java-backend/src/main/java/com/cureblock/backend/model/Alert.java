package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "alert")
@Data
public class Alert {
    @Id @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "child_id")
    private Child child;

    @Enumerated(EnumType.STRING)
    private AlertType type;

    @Enumerated(EnumType.STRING)
    private AlertStatus status;

    private String message;
    private String location;
    private LocalDateTime createdAt;
    private LocalDateTime resolvedAt;
}
