import 'dart:math' as math;
import 'package:flutter/material.dart';

class ZigzagBackground extends StatelessWidget {
  final Widget child;
  const ZigzagBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomPaint(
        painter: ZigzagPainter(),
        child: child,
      ),
    );
  }
}

class ZigzagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 2.1
      ..style = PaintingStyle.stroke;

    const double stepX = 30;
    const double stepY = 12;

   
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    canvas.rotate(-math.pi / 4);

    canvas.translate(-size.width / 1.5, -size.height / 1.5);

    //  diagonal zigzag lines
    for (double y = 0; y < size.height * 2; y += stepY * 3) {
      final Path path = Path();
      path.moveTo(0, y + stepY);
      for (double x = 0; x < size.width * 2; x += stepX) {
        path.lineTo(x + stepX / 2, y);
        path.lineTo(x + stepX, y + stepY);
      }
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
