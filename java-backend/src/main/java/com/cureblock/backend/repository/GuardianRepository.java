package com.cureblock.backend.repository;

import com.cureblock.backend.model.Guardian;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface GuardianRepository extends JpaRepository<Guardian, UUID> {
}