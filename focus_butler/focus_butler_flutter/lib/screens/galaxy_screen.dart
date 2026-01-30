import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme.dart';
import '../widgets/star_node.dart';

/// Mock star data model
class StarData {
  final String id;
  final String title;
  final Offset position;
  final bool isMastered;

  const StarData({
    required this.id,
    required this.title,
    required this.position,
    required this.isMastered,
  });
}

/// Provider for mock galaxy star data
final galaxyStarsProvider = Provider<List<StarData>>((ref) {
  final random = Random(42); // Fixed seed for consistent layout

  return List.generate(30, (index) {
    return StarData(
      id: 'concept-$index',
      title: 'Concept ${index + 1}',
      position: Offset(
        100 + random.nextDouble() * 1800,
        100 + random.nextDouble() * 1800,
      ),
      isMastered: random.nextDouble() > 0.4, // 60% mastered
    );
  });
});

/// Galaxy Screen - Interactive visualization of knowledge
class GalaxyScreen extends ConsumerWidget {
  const GalaxyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = ref.watch(galaxyStarsProvider);
    final colors = Theme.of(context).extension<FocusButlerColors>()!;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.cloudDancer),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go('/');
          },
        ),
        title: Text(
          'Knowledge Galaxy',
          style: TextStyle(
            color: colors.cloudDancer,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          // Legend indicator
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.neonCyan,
                    boxShadow: [
                      BoxShadow(
                        color: colors.neonCyan.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Mastered',
                  style: TextStyle(
                    color: colors.cloudDancer,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.1,
        maxScale: 4.0,
        boundaryMargin: const EdgeInsets.all(500),
        child: SizedBox(
          width: 2000,
          height: 2000,
          child: Stack(
            children: [
              // Background with subtle gradient
              Container(
                width: 2000,
                height: 2000,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Colors.indigo.withValues(alpha: 0.1),
                      Colors.black,
                    ],
                  ),
                ),
              ),

              // Background static dust particles
              ...List.generate(100, (index) {
                final random = Random(index * 7);
                return Positioned(
                  left: random.nextDouble() * 2000,
                  top: random.nextDouble() * 2000,
                  child: Container(
                    width: 1 + random.nextDouble() * 2,
                    height: 1 + random.nextDouble() * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                        alpha: 0.1 + random.nextDouble() * 0.1,
                      ),
                    ),
                  ),
                );
              }),

              // Star nodes
              ...stars.map(
                (star) => StarNode(
                  position: star.position,
                  isMastered: star.isMastered,
                  onTap: () => _onStarTapped(context, star, colors),
                ),
              ),

              // Center indicator (starting point)
              Positioned(
                left: 950,
                top: 950,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.softAmber.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.my_location,
                      color: colors.softAmber.withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Stats FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          final mastered = stars.where((s) => s.isMastered).length;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$mastered/${stars.length} concepts mastered'),
              backgroundColor: colors.matteDark,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: colors.neonCyan.withValues(alpha: 0.9),
        icon: Icon(Icons.analytics_outlined, color: colors.matteDark),
        label: Text(
          'Stats',
          style: TextStyle(
            color: colors.matteDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _onStarTapped(
    BuildContext context,
    StarData star,
    FocusButlerColors colors,
  ) {
    HapticFeedback.lightImpact();

    final message = star.isMastered
        ? 'Playing audio recap for "${star.title}"...'
        : 'Opening flowchart for "${star.title}"...';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              star.isMastered ? Icons.headphones : Icons.account_tree,
              color: star.isMastered ? colors.neonCyan : colors.softAmber,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: colors.matteDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
