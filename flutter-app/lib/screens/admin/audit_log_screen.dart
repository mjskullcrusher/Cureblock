import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/audit_log_model.dart';
import '../../providers/child_provider.dart';
import '../../theme/app_text_styles.dart';

class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  AuditAction? _actionFilter;
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    var logs = ref.watch(auditLogsProvider);
    if (_actionFilter != null) {
      logs = logs.where((l) => l.action == _actionFilter).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Log'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon')),
              );
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<AuditAction?>(
                    initialValue: _actionFilter,
                    decoration: const InputDecoration(labelText: 'Action type'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...AuditAction.values.map(
                        (a) => DropdownMenuItem(value: a, child: Text(a.label)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _actionFilter = v),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (range != null) setState(() => _dateRange = range);
                  },
                  child: Text(
                    _dateRange == null
                        ? 'Date range'
                        : DateFormat.MMMd().format(_dateRange!.start),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (_, i) {
                final log = logs[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(log.userName[0])),
                  title: Text(log.userName),
                  subtitle: Text(
                    log.recordId,
                    style: AppTextStyles.mono(context, fontSize: 11),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Chip(label: Text(log.action.label), visualDensity: VisualDensity.compact),
                      Text(
                        DateFormat.yMMMd().add_Hm().format(log.timestamp),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
