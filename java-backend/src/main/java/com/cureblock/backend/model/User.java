package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.UUID;

@Entity
@Table(name = "app_user")
@Data
public class User {
    @Id @GeneratedValue
    private UUID id;

    @Column(unique = true, nullable = false)
    private String username;

    private String passwordHash;

    @Enumerated(EnumType.STRING)
    private UserRole role;

    private boolean mustResetPassword;
}
