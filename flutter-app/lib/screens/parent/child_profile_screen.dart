import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/child_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/biometric_timeline.dart';
import '../../widgets/iot_device_card.dart';
import '../../widgets/parent_scaffold.dart';
import '../../widgets/sign_out_button.dart';
import '../../widgets/theme_toggle.dart';

class ChildProfileScreen extends ConsumerWidget {
  const ChildProfileScreen({super.key, required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(childByIdProvider(childId));
    if (child == null) {
      return const Scaffold(body: Center(child: Text('Child not found')));
    }

    return ParentScaffold(
      currentIndex: 3,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ThemeToggle(), SignOutButton()],
            ),
            Column(
            children: [
              CircleAvatar(radius: 48, child: Text(child.name[0], style: const TextStyle(fontSize: 32))),
              const SizedBox(height: 12),
              Text(child.name, style: Theme.of(context).textTheme.headlineMedium),
              Text('Age ${child.age}', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Chip(
                label: const Text('Blockchain Verified ✓'),
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 24),
              _sectionTitle(context, 'Identity'),
              ListTile(
                title: const Text('Aadhaar linkage'),
                trailing: Chip(label: Text(child.aadhaarStatus.label)),
              ),
              ListTile(
                title: const Text('Blockchain ID'),
                subtitle: Text(
                  child.blockchainId,
                  style: AppTextStyles.mono(context, fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: child.blockchainId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Biometric Milestones'),
              BiometricTimeline(milestones: child.biometricMilestones),
              const SizedBox(height: 16),
              IoTDeviceCard(device: child.iotDevice),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Trusted Contacts'),
              ...child.trustedContacts.map(
                (c) => ListTile(
                  leading: CircleAvatar(child: Text(c.name[0])),
                  title: Text(c.name),
                  subtitle: Text(c.relationship),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push('/parent/guardians'),
                child: const Text('Manage guardians'),
              ),
            ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
