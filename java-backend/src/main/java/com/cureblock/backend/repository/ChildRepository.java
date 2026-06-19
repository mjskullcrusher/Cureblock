package com.cureblock.backend.repository;

import com.cureblock.backend.model.Child;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface ChildRepository extends JpaRepository<Child, UUID> {
}