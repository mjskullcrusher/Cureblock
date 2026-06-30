import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/child_provider.dart';
import '../../providers/map_provider.dart';
import '../../theme/light_theme.dart';
import '../../widgets/parent_scaffold.dart';
import '../../widgets/status_badge.dart';

class ParentMapScreen extends ConsumerWidget {
  const ParentMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final child = ref.watch(selectedChildProvider);
    final ext = CureBlockThemeExtension.of(context);
    final zoneColor = mapState.geofenceBreached ? ext.danger : ext.safe;

    return ParentScaffold(
      currentIndex: 1,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Zone'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: mapState.childPosition,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.cureblock.cureblock',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: mapState.safeZoneCenter,
                    radius: mapState.safeZoneRadiusMeters,
                    useRadiusInMeter: true,
                    color: zoneColor.withValues(alpha: 0.2),
                    borderColor: zoneColor,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: mapState.childPosition,
                    width: 48,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          child.name[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: AppBar(
              leading: BackButton(onPressed: () => context.pop()),
              title: const Text('Live Location'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.22,
            minChildSize: 0.18,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, -2)),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(child.name, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(width: 8),
                        StatusBadge(status: child.isSafe ? 'safe' : 'alert'),
                      ],
                    ),
                    Text(
                      'Last updated ${_secondsAgo(mapState.lastUpdated)}s ago',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Currently in: ${child.currentZone}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _secondsAgo(DateTime time) {
    return DateTime.now().difference(time).inSeconds.clamp(1, 999);
  }
}
