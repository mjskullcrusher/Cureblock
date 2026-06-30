import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  bool _sent = false;
  late final AnimationController _ripple;

  @override
  void initState() {
    super.initState();
    _ripple = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _ripple.dispose();
    super.dispose();
  }

  void _activate() {
    HapticFeedback.heavyImpact();
    _ripple.forward(from: 0);
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF4444),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('SOS Emergency'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _sent ? _buildConfirmation() : _buildTrigger(),
      ),
    );
  }

  Widget _buildTrigger() {
    return Center(
      key: const ValueKey('trigger'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onLongPress: _activate,
            child: AnimatedBuilder(
              animation: _ripple,
              builder: (context, child) {
                final scale = 1 + _ripple.value * 0.3;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Press and hold for 2 seconds to send emergency alert',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    const contacts = ['Raj Sharma', 'Sunita Sharma', 'Meera Sharma'];
    return Padding(
      key: const ValueKey('confirm'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 72),
          const SizedBox(height: 16),
          const Text(
            '✓ Alert sent to 3 guardians',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...contacts.map(
            (c) => ListTile(
              leading: const Icon(Icons.check, color: Colors.white),
              title: Text(c, style: const TextStyle(color: Colors.white)),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel false alarm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
