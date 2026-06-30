import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/child_provider.dart';
import '../../widgets/confidence_score_card.dart';
import '../../widgets/scan_ring_widget.dart';

class BiometricIdentificationScreen extends ConsumerStatefulWidget {
  const BiometricIdentificationScreen({super.key});

  @override
  ConsumerState<BiometricIdentificationScreen> createState() =>
      _BiometricIdentificationScreenState();
}

class _BiometricIdentificationScreenState
    extends ConsumerState<BiometricIdentificationScreen> {
  bool _scanned = false;
  String? _confirmedName;
  int? _confirmedAge;

  @override
  Widget build(BuildContext context) {
    final candidates = ref.watch(rescueMatchCandidatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rescue Identification')),
      body: Column(
        children: [
          MaterialBanner(
            content: const Text('Rescue Identification Mode'),
            backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.2),
            leading: const Icon(Icons.warning_amber, color: Color(0xFFF59E0B)),
            actions: [TextButton(onPressed: () {}, child: const Text('DISMISS'))],
          ),
          const SizedBox(height: 16),
          if (!_scanned)
            ScanRingWidget(onScanComplete: () => setState(() => _scanned = true))
          else if (_confirmedName != null)
            Expanded(child: _buildConfirmed())
          else
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...candidates.map(
                    (c) => ConfidenceScoreCard(
                      score: c.score,
                      name: c.name,
                      age: c.age,
                      dateOfBirth: c.dateOfBirth,
                      onTap: c.score >= 0.95
                          ? () => setState(() {
                                _confirmedName = c.name;
                                _confirmedAge = c.age;
                              })
                          : null,
                    ),
                  ),
                  if (candidates.every((c) => c.score < 0.95)) ...[
                    const SizedBox(height: 16),
                    const Center(child: Text('No confident match found')),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Store as New Template'),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfirmed() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 80),
          const SizedBox(height: 16),
          Text(
            'Identity Confirmed · $_confirmedName · Age $_confirmedAge',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
