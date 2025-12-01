import 'package:flutter/material.dart';

extension ColorWithValues on Color {
  /// Create a new Color by specifying new channel values.
  ///
  /// - `alpha` is a double in range 0.0..1.0 (fractional) and will be
  ///   converted to 0..255. If omitted, the original alpha is preserved.
  /// - `a`, `r`, `g`, `b` allow specifying integer 0..255 channel values.
  ///
  /// Examples:
  /// `color.withValues(alpha: 0.15)`
  /// `Colors.white.withValues(alpha: 0.3)`
  Color withValues({double? alpha, int? a, int? r, int? g, int? b}) {
    final int newA = alpha != null
        ? (alpha * 255).round().clamp(0, 255)
        : (a ?? (((this.a) * 255.0).round() & 0xff));
    final int newR = r ?? ((this.r * 255.0).round() & 0xff);
    final int newG = g ?? ((this.g * 255.0).round() & 0xff);
    final int newB = b ?? ((this.b * 255.0).round() & 0xff);
    return Color.fromARGB(newA, newR, newG, newB);
  }
}
