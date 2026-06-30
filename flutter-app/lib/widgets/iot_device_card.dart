import 'package:flutter/material.dart';

import '../models/iot_device_model.dart';
import '../theme/app_text_styles.dart';
import '../theme/light_theme.dart';

class IoTDeviceCard extends StatelessWidget {
  const IoTDeviceCard({super.key, required this.device});

  final IoTDeviceModel device;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = CureBlockThemeExtension.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('IoT Device', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(
              device.deviceId,
              style: AppTextStyles.mono(context, fontSize: 14),
            ),
            if (device.gpsDeviceName != null) ...[
              const SizedBox(height: 4),
              Text(
                device.gpsDeviceName!,
                style: theme.textTheme.bodySmall?.copyWith(color: ext.textSecondary),
              ),
            ],
            const SizedBox(height: 16),
            Text('Battery', style: theme.textTheme.labelMedium),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: device.batteryPercent / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: theme.dividerColor,
              color: device.batteryPercent > 20 ? ext.safe : ext.danger,
            ),
            const SizedBox(height: 4),
            Text('${device.batteryPercent}%', style: theme.textTheme.labelSmall),
            const SizedBox(height: 16),
            Text('GPS signal', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            Row(
              children: List.generate(4, (i) {
                final active = i < device.gpsSignalStrength;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.circle,
                    size: 14,
                    color: active
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text('RFID: ${device.rfidStatus}'),
              backgroundColor: device.rfidStatus.toLowerCase() == 'active'
                  ? ext.safe.withValues(alpha: 0.12)
                  : ext.warning.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 8),
            Text(
              device.lastLocation,
              style: theme.textTheme.bodySmall?.copyWith(color: ext.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
