import 'dart:math';

import 'package:flutter/material.dart';

class BendableSliderPainter extends CustomPainter {
  final double progress;
  final String? title;
  final bool isTitleFixed;
  final TextStyle? titleTextStyle;
  final List<Color>? foregroundGradiantColor;
  final Color? backgroundTrackColor;
  final double hideThumbProgress;

  BendableSliderPainter({
    required this.progress,
    this.title,
    this.isTitleFixed = true,
    this.titleTextStyle,
    this.foregroundGradiantColor,
    this.backgroundTrackColor,
    this.hideThumbProgress = 0.4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerHeight = size.height * 0.6;

    final basePath = Path();
    basePath.moveTo(0, centerHeight);
    basePath.quadraticBezierTo(size.width / 2, -30, size.width, centerHeight);

    // 1. Draw the base path (black with 20% opacity)
    final basePaint = Paint()
      ..color = backgroundTrackColor ?? Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50
      ..strokeCap = StrokeCap.square;
    canvas.drawPath(basePath, basePaint);

    // 2. Clip path to draw gradient only up to progress
    final progressPath = Path();
    final steps = 100; // Higher = smoother
    for (int i = 0; i <= (progress * steps).toInt(); i++) {
      final t = i / steps;
      final x = t * size.width;
      final y = _quadraticBezierY(t, size.width, centerHeight);
      if (i == 0) {
        progressPath.moveTo(x, y);
      } else {
        progressPath.lineTo(x, y);
      }
    }

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: foregroundGradiantColor ?? const [Color(0xFF2FD0DE), Color(0xFF7684ED), Color(0xFFCA24FD)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 56
      ..strokeCap = progress >= 0.98 ? StrokeCap.square : StrokeCap.round;
    canvas.drawPath(progressPath, gradientPaint);

    // 1. Draw thumb circle
    final thumbPaint = Paint()..color = progress < hideThumbProgress ? const Color(0x33000000) : Colors.transparent;
    final thumbX = progress * size.width;
    final thumbY = _quadraticBezierY(progress, size.width, centerHeight);
    final thumbPos = Offset(thumbX, thumbY);
    canvas.drawCircle(thumbPos, 20, thumbPaint);

    // 2. Calculate tangent direction
    /// isCenter use for center send text only
    final tangent = _calculateBezierTangent(progress, size.width, centerHeight, isCenter: progress < hideThumbProgress);
    final angle = atan2(tangent.dy, tangent.dx);

    // 3. Save canvas to rotate content
    canvas.save();
    canvas.translate(thumbPos.dx, thumbPos.dy);
    canvas.rotate(angle);

    // SEND Text Fade Logic
    if (!isTitleFixed && title != null) {
      // final double calculatedOpacity = (1 - (progress * 2)).clamp(0.0, 1.0);
      final double calculatedOpacity = progress < 0.5 ? 1.0 : 0.0;

      // 4. Draw background text behind arrow
      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: title,
        style: (titleTextStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.6)).copyWith(
          color: (titleTextStyle?.color ?? Colors.white).withValues(alpha: calculatedOpacity),
        ), // 👈 fade out at 50%
        // style: titleTextStyle ?? TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.6),
      );
      textPainter.layout();
      final textOffset = Offset(-(textPainter.width / 2) - (progress < hideThumbProgress ? 50 : 4), -(textPainter.height / 2));
      textPainter.paint(canvas, textOffset);
    }

    debugPrint("progress ::$progress");
    // 5. Draw arrow icon on top of text
    const icon = Icons.arrow_forward;
    final arrowPainter = TextPainter(textDirection: TextDirection.ltr);
    arrowPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 20,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: progress < hideThumbProgress ? Colors.white : Colors.transparent,
      ),
    );
    arrowPainter.layout();
    final arrowOffset = Offset((-arrowPainter.width / 2), -arrowPainter.height / 2);
    arrowPainter.paint(canvas, arrowOffset);

    // 6. Restore canvas
    canvas.restore();
  }

  double _quadraticBezierY(double t, double width, double height) {
    // P0 = (0, h), P1 = (w/2, 0), P2 = (w, h)
    return pow(1 - t, 2) * height + 2 * (1 - t) * t * (-30) + pow(t, 2) * height;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Offset _calculateBezierTangent(double t, double width, double height, {bool isCenter = false}) {
  // Derivative of a quadratic Bézier curve
  final dx = 2 * (1 - t) * (width / 2 - 0) + (isCenter ? -2 : 2) * t * (width - width / 2);
  final dy = 2 * (1 - t) * (0 - height) + 2 * t * (height - 0);
  return Offset(dx, dy);
}
