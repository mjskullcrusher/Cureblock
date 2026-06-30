import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../data/mock_data.dart';

class MapState {
  const MapState({
    required this.childPosition,
    required this.geofenceBreached,
    required this.safeZoneCenter,
    required this.safeZoneRadiusMeters,
    required this.lastUpdated,
  });

  final LatLng childPosition;
  final bool geofenceBreached;
  final LatLng safeZoneCenter;
  final double safeZoneRadiusMeters;
  final DateTime lastUpdated;

  MapState copyWith({
    LatLng? childPosition,
    bool? geofenceBreached,
    LatLng? safeZoneCenter,
    double? safeZoneRadiusMeters,
    DateTime? lastUpdated,
  }) {
    return MapState(
      childPosition: childPosition ?? this.childPosition,
      geofenceBreached: geofenceBreached ?? this.geofenceBreached,
      safeZoneCenter: safeZoneCenter ?? this.safeZoneCenter,
      safeZoneRadiusMeters: safeZoneRadiusMeters ?? this.safeZoneRadiusMeters,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  final notifier = MapNotifier();
  ref.onDispose(notifier.cancelTimer);
  return notifier;
});

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier()
      : super(
          MapState(
            childPosition: LatLng(
              MockData.homeZoneCenter.latitude + 0.0008,
              MockData.homeZoneCenter.longitude + 0.0005,
            ),
            geofenceBreached: false,
            safeZoneCenter: MockData.homeZoneCenter,
            safeZoneRadiusMeters: 350,
            lastUpdated: DateTime.now(),
          ),
        ) {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _tick());
  }

  Timer? _timer;
  final _random = Random();

  void _tick() {
    final deltaLat = (_random.nextDouble() - 0.5) * 0.0004;
    final deltaLng = (_random.nextDouble() - 0.5) * 0.0004;
    final newPos = LatLng(
      state.childPosition.latitude + deltaLat,
      state.childPosition.longitude + deltaLng,
    );

    final distance = const Distance().as(
      LengthUnit.Meter,
      state.safeZoneCenter,
      newPos,
    );
    final breached = distance > state.safeZoneRadiusMeters;

    state = state.copyWith(
      childPosition: newPos,
      geofenceBreached: breached,
      lastUpdated: DateTime.now(),
    );
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}
