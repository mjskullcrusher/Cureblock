import 'dart:math' as math;

import 'package:flutter/material.dart';

class ScanRingWidget extends StatefulWidget {
  const ScanRingWidget({
    super.key,
    this.onScanComplete,
    this.size = 160,
    this.simulationDuration = const Duration(seconds: 3),
  });

  final VoidCallback? onScanComplete;
  final double size;
  final Duration simulationDuration;

  @override
  State<ScanRingWidget> createState() => _ScanRingWidgetState();
}

class _ScanRingWidgetState extends State<ScanRingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.delayed(widget.simulationDuration, () {
      if (!mounted || _completed) return;
      _completed = true;
      widget.onScanComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ScanRingPainter(
              progress: _controller.value,
              color: color,
            ),
            child: Center(
              child: Icon(
                Icons.fingerprint,
                size: widget.size * 0.6,
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ScanRingPainter extends CustomPainter {
  _ScanRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, paint);

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final start = -math.pi / 2 + progress * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      math.pi * 1.2,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
