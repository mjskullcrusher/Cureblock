package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "guardian")
@Data
public class Guardian {
    @Id @GeneratedValue
    private UUID id;

    private String name;
    private String relationship;
    private String phone;
    private String avatarUrl;

    @Enumerated(EnumType.STRING)
    private GuardianAccessLevel accessLevel;

    // links to the login account created at enrolment (Model 1)
    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToMany(mappedBy = "guardians")
    private List<Child> children = new ArrayList<>();
}
