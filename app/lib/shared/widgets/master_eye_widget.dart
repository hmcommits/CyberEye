import 'package:flutter/material.dart';

class MasterEyeWidget extends StatefulWidget {
  const MasterEyeWidget({super.key});

  @override
  State<MasterEyeWidget> createState() => _MasterEyeWidgetState();
}

class _MasterEyeWidgetState extends State<MasterEyeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // 120 FPS capable pulse animation for the "Brutal Judge" eye
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _EyePainter(),
          ),
        );
      },
    );
  }
}

class _EyePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer Glow
    final glowPaint = Paint()
      ..color = const Color(0xFF00FFCC).withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, size.width / 2, glowPaint);

    // Sclera (Outer Ring)
    final scleraPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, size.width / 2.5, scleraPaint);

    // Iris (Inner Ring)
    final irisPaint = Paint()
      ..color = const Color(0xFF00FFCC).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, size.width / 4, irisPaint);

    // Pupil
    final pupilPaint = Paint()
      ..color = const Color(0xFF00FFCC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width / 12, pupilPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
