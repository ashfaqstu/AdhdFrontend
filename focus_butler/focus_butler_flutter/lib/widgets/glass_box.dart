import 'dart:ui';
import 'package:flutter/material.dart';

/// A reusable glassmorphism container widget.
///
/// Works best on dark backgrounds like #121212.
class GlassBox extends StatelessWidget {
  const GlassBox({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderColor,
    this.padding,
  });

  /// The child widget to display inside the glass container
  final Widget child;

  /// Border radius for the glass container
  final double borderRadius;

  /// Amount of blur to apply (default: 10.0)
  final double blur;

  /// Opacity of the white overlay (default: 0.1 = 10%)
  final double opacity;

  /// Optional border color (defaults to white at 20% opacity)
  final Color? borderColor;

  /// Optional padding inside the glass container
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
