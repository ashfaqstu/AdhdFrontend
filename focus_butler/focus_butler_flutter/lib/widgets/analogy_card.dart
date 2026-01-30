import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme.dart';
import 'glass_box.dart';

/// Analogy Card overlay - displays analogy/insight for current content
class AnalogyCard extends StatelessWidget {
  const AnalogyCard({
    super.key,
    required this.onClose,
    this.analogyText =
        'This concept is like a water filter that only allows certain particles through, blocking unwanted elements while letting the essentials pass.',
  });

  final VoidCallback onClose;
  final String analogyText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<FocusButlerColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GlassBox(
          borderRadius: 20,
          blur: 20,
          opacity: 0.2,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lightbulb icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.softAmber.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: colors.softAmber,
                  size: 36,
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                'Analogy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.softAmber,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Analogy text
              Text(
                analogyText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.cloudDancer,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.neonCyan.withValues(alpha: 0.2),
                    foregroundColor: colors.neonCyan,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colors.neonCyan.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
