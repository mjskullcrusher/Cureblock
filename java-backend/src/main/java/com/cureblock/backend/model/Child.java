package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "child")
@Data
public class Child {
    @Id @GeneratedValue
    private UUID id;

    private String name;
    private int age;
    private LocalDate dateOfBirth;

    private String externalSubjectId;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Enumerated(EnumType.STRING)
    private ChildStatus status;

    private String avatarUrl;
    private String currentZone;
    private boolean safe;
    private String lastSeenLabel;

    private LocalDateTime enrolmentDate;
    private String enrolmentCenter;

    @ManyToMany
    @JoinTable(
        name = "child_guardian",
        joinColumns = @JoinColumn(name = "child_id"),
        inverseJoinColumns = @JoinColumn(name = "guardian_id"))
    private List<Guardian> guardians = new ArrayList<>();

    @OneToMany(mappedBy = "child", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BiometricTemplate> biometricTemplates = new ArrayList<>();

    @OneToOne(mappedBy = "child", cascade = CascadeType.ALL, orphanRemoval = true)
    private AadhaarReference aadhaarReference;

    @OneToOne(mappedBy = "child", cascade = CascadeType.ALL, orphanRemoval = true)
    private IoTDevice iotDevice;

    @OneToMany(mappedBy = "child", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Alert> alerts = new ArrayList<>();

    @OneToMany(mappedBy = "child", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BlockchainRecord> blockchainRecords = new ArrayList<>();
}
