package com.cureblock.backend.repository;
import com.cureblock.backend.model.BlockchainRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;
public interface BlockchainRecordRepository extends JpaRepository<BlockchainRecord, UUID> {}