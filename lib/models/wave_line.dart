import 'dart:math' as math;

import 'package:flutter/material.dart';

class StaticWaveformLine extends StatelessWidget {
  final double fillFraction;

  final double height;

  final Color activeColor;

  final Color inactiveColor;

  const StaticWaveformLine({
    super.key,
    required this.fillFraction,
    this.height = 20,
    this.activeColor = const Color(0xFF9196FF),
    this.inactiveColor = const Color(0xFF2A2A2A),
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: StaticWavePainter(
            fillFraction: fillFraction.clamp(0.0, 1.0),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),
      ),
    );
  }
}

// -------------------------- Painter --------------------------
class StaticWavePainter extends CustomPainter {
  final double fillFraction;
  final Color activeColor;
  final Color inactiveColor;

  StaticWavePainter({
    required this.fillFraction,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Paint inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const amplitude = 3.0;
    const wavelength = 24.0;

    final double splitX = size.width * fillFraction;

     // filled part
    final Path activePath = Path();
    for (double x = 0; x <= splitX; x++) {
      final y =
          math.sin((x / wavelength) * 2 * math.pi) * amplitude +
          size.height / 2;
      if (x == 0) {
        activePath.moveTo(x, y);
      } else {
        activePath.lineTo(x, y);
      }
    }
    canvas.drawPath(activePath, activePaint);

    //  remaining part
    final Path inactivePath = Path();
    for (double x = splitX; x <= size.width; x++) {
      final y =
          math.sin((x / wavelength) * 2 * math.pi) * amplitude +
          size.height / 2;
      if (x == splitX) {
        inactivePath.moveTo(x, y);
      } else {
        inactivePath.lineTo(x, y);
      }
    }
    canvas.drawPath(inactivePath, inactivePaint);
  }

  @override
  bool shouldRepaint(covariant StaticWavePainter oldDelegate) {
    return oldDelegate.fillFraction != fillFraction ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
