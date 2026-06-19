package com.cureblock.backend.repository;
import com.cureblock.backend.model.BiometricTemplate;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;
public interface BiometricTemplateRepository extends JpaRepository<BiometricTemplate, UUID> {}