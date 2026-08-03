import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gizecare/core/theme/app_colors.dart';

/// Vector brand mark for ጊዜCare — crisp at any sidebar / tray size.
///
/// Matches the product logo: open cyan ring, center needle toward the gap,
/// and a short trail of square “pixels” breaking off at ~1–2 o’clock.
class GizeCareLogo extends StatelessWidget {
  const GizeCareLogo({
    super.key,
    this.size = 40,
    this.color = AppColors.brand,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GizeCareLogoPainter(color: color),
      ),
    );
  }
}

class _GizeCareLogoPainter extends CustomPainter {
  _GizeCareLogoPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = Offset(size.width / 2, size.height / 2);
    // Leave margin so the pixel trail isn’t clipped.
    final radius = s * 0.34;
    final stroke = s * 0.155;

    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Gap roughly from 12:30 to 3:00 (-pi/2 is 12 o’clock).
    const start = -math.pi / 2 + 0.55;
    const sweep = math.pi * 2 - 1.35;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: radius),
      start,
      sweep,
      false,
      ringPaint,
    );

    // Soft inner shade on the lower-left arc (depth cue from the raster mark).
    final shadePaint = Paint()
      ..color = Color.lerp(color, const Color(0xFF006BB3), 0.45)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 0.92
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: radius),
      math.pi * 0.55,
      math.pi * 0.85,
      false,
      shadePaint,
    );

    // Needle toward the gap (~2 o’clock).
    final needlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    const needleAngle = -math.pi / 2 + 1.05;
    final tip = Offset(
      c.dx + math.cos(needleAngle) * (radius + stroke * 0.15),
      c.dy + math.sin(needleAngle) * (radius + stroke * 0.15),
    );
    final hubR = s * 0.055;
    final halfW = s * 0.055;

    final dir = tip - c;
    final len = dir.distance;
    final u = dir / len;
    final n = Offset(-u.dy, u.dx);

    final path = Path()
      ..moveTo(c.dx + n.dx * halfW, c.dy + n.dy * halfW)
      ..lineTo(tip.dx + n.dx * (halfW * 0.35), tip.dy + n.dy * (halfW * 0.35))
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - n.dx * (halfW * 0.35), tip.dy - n.dy * (halfW * 0.35))
      ..lineTo(c.dx - n.dx * halfW, c.dy - n.dy * halfW)
      ..close();
    canvas.drawPath(path, needlePaint);
    canvas.drawCircle(c, hubR, needlePaint);

    // Pixel trail — intentional squares, clean geometry (not raster mush).
    final px = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final trail = <(double, double, double)>[
      (0.08, -0.02, 0.09),
      (0.18, 0.04, 0.075),
      (0.28, -0.05, 0.07),
      (0.38, 0.06, 0.065),
      (0.48, -0.02, 0.055),
      (0.58, 0.05, 0.05),
      (0.68, -0.04, 0.045),
      (0.78, 0.03, 0.04),
      (0.88, -0.01, 0.035),
    ];

    final gapPoint = Offset(
      c.dx + math.cos(needleAngle) * (radius + stroke * 0.55),
      c.dy + math.sin(needleAngle) * (radius + stroke * 0.55),
    );
    final trailDir = Offset(math.cos(needleAngle), math.sin(needleAngle));
    final trailN = Offset(-trailDir.dy, trailDir.dx);

    for (final (t, lat, sf) in trail) {
      final center = Offset(
        gapPoint.dx + trailDir.dx * (s * t * 0.42) + trailN.dx * (s * lat),
        gapPoint.dy + trailDir.dy * (s * t * 0.42) + trailN.dy * (s * lat),
      );
      final side = s * sf;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: side, height: side),
          Radius.circular(side * 0.12),
        ),
        px,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GizeCareLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
