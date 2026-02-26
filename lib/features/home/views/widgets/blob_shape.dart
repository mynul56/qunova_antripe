import 'package:flutter/material.dart';

class BlobShape extends ShapeBorder {
  const BlobShape();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final w = rect.width;
    final h = rect.height;
    final path = Path();

    // Custom bezier approximations for the squiggly blob provided in the Figma CSS
    // Start at top-left curve
    path.moveTo(w * 0.25, h * 0.15);

    // Curve to top-right
    path.cubicTo(w * 0.55, h * -0.05, w * 0.95, h * 0.15, w * 0.88, h * 0.5);

    // Curve to bottom-right
    path.cubicTo(w * 0.8, h * 0.85, w * 0.5, h * 1.0, w * 0.2, h * 0.85);

    // Curve to bottom-left/top-left connecting back
    path.cubicTo(w * -0.05, h * 0.7, w * -0.05, h * 0.35, w * 0.25, h * 0.15);

    path.close();

    return path.shift(rect.topLeft);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
