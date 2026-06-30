import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/child_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/light_theme.dart';

class BlockchainIntegrityScreen extends ConsumerStatefulWidget {
  const BlockchainIntegrityScreen({super.key});

  @override
  ConsumerState<BlockchainIntegrityScreen> createState() =>
      _BlockchainIntegrityScreenState();
}

class _BlockchainIntegrityScreenState extends ConsumerState<BlockchainIntegrityScreen> {
  bool _checking = false;
  bool _checked = false;
  final _lastChecked = DateTime.now();

  Future<void> _runCheck() async {
    setState(() {
      _checking = true;
      _checked = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _checking = false;
      _checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(blockchainIntegrityProvider);
    final ext = CureBlockThemeExtension.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Integrity Verification')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Last checked: ${DateFormat.yMMMd().add_Hm().format(_lastChecked)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ...records.map((r) {
            final color = r.verified ? ext.safe : ext.danger;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  r.verified ? Icons.check_circle : Icons.warning_amber,
                  color: color,
                ),
                title: Text(r.childName),
                subtitle: Text(r.recordId, style: AppTextStyles.mono(context, fontSize: 11)),
                trailing: !r.verified
                    ? TextButton(onPressed: () {}, child: const Text('View details'))
                    : null,
              ),
            );
          }),
          const SizedBox(height: 16),
          if (_checking) const LinearProgressIndicator(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _checked
                ? Card(
                    key: const ValueKey('result'),
                    color: ext.safe.withValues(alpha: 0.1),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('2 of 3 records verified · 1 mismatch found'),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _checking ? null : _runCheck,
            child: const Text('Run Full Integrity Check'),
          ),
        ],
      ),
    );
  }
}
