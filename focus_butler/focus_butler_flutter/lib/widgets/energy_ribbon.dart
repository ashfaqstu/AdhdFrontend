import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';

/// Energy Ribbon widget - displays at the bottom of the screen
/// Pulses when energy is low (<0.3)
class EnergyRibbon extends ConsumerWidget {
  const EnergyRibbon({
    super.key,
    required this.energyLevel,
  });

  final double energyLevel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<FocusButlerColors>()!;
    final isLowEnergy = energyLevel < 0.3;

    Widget ribbon = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: MediaQuery.of(context).size.width * energyLevel,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.neonCyan,
            colors.neonCyan.withValues(alpha: 0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.neonCyan.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    // Pulse animation when energy is low
    if (isLowEnergy) {
      ribbon = ribbon
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .fade(
            begin: 0.5,
            end: 1.0,
            duration: const Duration(milliseconds: 800),
          );
    }

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 6,
        width: double.infinity,
        color: colors.cloudDancer.withValues(alpha: 0.1),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ribbon,
        ),
      ),
    );
  }
}
