package com.cureblock.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "iot_event_log")
@Data
public class IoTEventLog {
    @Id @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "device_id")
    private IoTDevice device;

    private String eventLabel;
    private String lastLocation;
    private String geofenceStatus;   // inside / breached
    private LocalDateTime timestamp;
}
