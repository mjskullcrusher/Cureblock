package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "iot_device")
@Data
public class IoTDevice {
    @Id @GeneratedValue
    private UUID id;

    @OneToOne
    @JoinColumn(name = "child_id")
    private Child child;

    private String deviceToken;      // tokenized device id
    private String deviceType;       // RFID / GPS
    private boolean active;
    private int batteryPercent;
    private int gpsSignalStrength;
    private String rfidStatus;
    private String lastLocation;
    private LocalDateTime registeredAt;

    @OneToMany(mappedBy = "device", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<IoTEventLog> events = new ArrayList<>();
}
