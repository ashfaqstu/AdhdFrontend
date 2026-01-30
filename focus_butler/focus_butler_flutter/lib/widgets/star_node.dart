import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/theme.dart';

/// A reusable animated star node widget for the Galaxy view
class StarNode extends StatelessWidget {
  const StarNode({
    super.key,
    required this.position,
    required this.isMastered,
    this.size,
    this.onTap,
  });

  /// Position of the star in the galaxy
  final Offset position;

  /// Whether this concept has been mastered
  final bool isMastered;

  /// Size of the star (default: random 4-8)
  final double? size;

  /// Callback when star is tapped
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<FocusButlerColors>()!;
    final random = Random(position.dx.toInt() + position.dy.toInt());
    final starSize = size ?? (4.0 + random.nextDouble() * 4.0);
    final twinkleDelay = Duration(milliseconds: random.nextInt(2000));

    final starColor = isMastered
        ? colors.neonCyan
        : Colors.grey.withValues(alpha: 0.3);

    final glowIntensity = isMastered ? 0.8 : 0.1;

    Widget star = GestureDetector(
      onTap: onTap,
      child: Container(
        width: starSize,
        height: starSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: starColor,
          boxShadow: [
            BoxShadow(
              color: starColor.withValues(alpha: glowIntensity),
              blurRadius: isMastered ? 12 : 2,
              spreadRadius: isMastered ? 4 : 0,
            ),
            if (isMastered)
              BoxShadow(
                color: colors.neonCyan.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
      ),
    );

    // Add twinkle animation
    star = star
        .animate(
          delay: twinkleDelay,
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .fade(
          begin: isMastered ? 0.7 : 0.4,
          end: 1.0,
          duration: Duration(milliseconds: 800 + random.nextInt(600)),
        );

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: star,
    );
  }
}
