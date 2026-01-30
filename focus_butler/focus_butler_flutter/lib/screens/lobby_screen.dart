import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../core/theme.dart';
import '../widgets/glass_box.dart';

/// Mock book data model
class BookOrb {
  final String id;
  final String title;
  final String coverUrl;
  final double progress;

  const BookOrb({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.progress,
  });
}

/// Mock data provider for knowledge state
final knowledgeStateProvider = Provider<List<BookOrb>>((ref) {
  return const [
    BookOrb(
      id: 'book-1',
      title: 'Deep Work',
      coverUrl:
          'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
      progress: 0.72,
    ),
    BookOrb(
      id: 'book-2',
      title: 'Atomic Habits',
      coverUrl:
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400',
      progress: 0.35,
    ),
    BookOrb(
      id: 'book-3',
      title: 'The ADHD Advantage',
      coverUrl:
          'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=400',
      progress: 0.88,
    ),
    BookOrb(
      id: 'book-4',
      title: 'Flow State',
      coverUrl:
          'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=400',
      progress: 0.15,
    ),
    BookOrb(
      id: 'book-5',
      title: 'Mindful Focus',
      coverUrl:
          'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?w=400',
      progress: 0.50,
    ),
  ];
});

/// The Lobby Screen - Main screen with Book Orbs carousel
class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: _currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentPage = index;
    });
  }

  void _showButlerSheet() {
    final colors = Theme.of(context).extension<FocusButlerColors>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.matteDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.smart_toy_outlined,
                  color: colors.neonCyan,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Focus Butler',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.cloudDancer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Active Interventions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.softAmber,
              ),
            ),
            const SizedBox(height: 16),
            _InterventionTile(
              icon: Icons.timer_outlined,
              title: 'Pomodoro Timer',
              subtitle: 'Next break in 12 minutes',
              colors: colors,
            ),
            const SizedBox(height: 12),
            _InterventionTile(
              icon: Icons.lightbulb_outline,
              title: 'Insight Reminder',
              subtitle: 'Review pending analogies',
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadBook() async {
    final colors = Theme.of(context).extension<FocusButlerColors>()!;
    HapticFeedback.lightImpact();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        debugPrint('Uploading ${file.name}...');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.neonCyan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Uploading ${file.name}...'),
                  ),
                ],
              ),
              backgroundColor: colors.matteDark,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(knowledgeStateProvider);
    final colors = Theme.of(context).extension<FocusButlerColors>()!;
    final currentBook = books[_currentPage];

    return Scaffold(
      backgroundColor: colors.matteDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                const SizedBox(height: 60),

                // Book Orbs Carousel
                SizedBox(
                  height: 320,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final isActive = index == _currentPage;

                      return AnimatedScale(
                        scale: isActive ? 1.0 : 0.9,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: _BookOrbWidget(
                          book: book,
                          isActive: isActive,
                          colors: colors,
                          onTap: isActive
                              ? () => context.go('/reader/${book.id}')
                              : null,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Current Book Title
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    currentBook.title,
                    key: ValueKey(currentBook.id),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colors.cloudDancer,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 8),

                // Progress text
                Text(
                  '${(currentBook.progress * 100).toInt()}% Complete',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.softAmber,
                  ),
                ),

                const SizedBox(height: 16),

                // Page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    books.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? colors.neonCyan
                            : colors.cloudDancer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Butler Avatar - Top Right
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: _showButlerSheet,
                child: Stack(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.cloudDancer.withValues(alpha: 0.1),
                        border: Border.all(
                          color: colors.cloudDancer.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        color: colors.cloudDancer,
                        size: 28,
                      ),
                    ),
                    // Notification dot
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors.neonCyan,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.neonCyan.withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Upload Button - Top Left (Glassmorphism)
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: _uploadBook,
                child: GlassBox(
                  borderRadius: 26,
                  blur: 10,
                  opacity: 0.1,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.neonCyan.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: colors.neonCyan,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            // Galaxy Button - Bottom Center
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.go('/galaxy');
                  },
                  child: GlassBox(
                    borderRadius: 25,
                    blur: 15,
                    opacity: 0.15,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars_outlined,
                          color: colors.softAmber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Knowledge Galaxy',
                          style: TextStyle(
                            color: colors.cloudDancer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual Book Orb widget with progress ring
class _BookOrbWidget extends StatelessWidget {
  const _BookOrbWidget({
    required this.book,
    required this.isActive,
    required this.colors,
    this.onTap,
  });

  final BookOrb book;
  final bool isActive;
  final FocusButlerColors colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress Ring (outer)
              SizedBox(
                width: 240,
                height: 240,
                child: CircularProgressIndicator(
                  value: book.progress,
                  strokeWidth: 6,
                  backgroundColor: colors.cloudDancer.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isActive
                        ? colors.neonCyan
                        : colors.softAmber.withValues(alpha: 0.5),
                  ),
                ),
              ),

              // Book Orb (inner)
              ClipOval(
                child: GlassBox(
                  borderRadius: 110,
                  blur: 15,
                  opacity: 0.15,
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.network(
                        book.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colors.matteDark,
                          child: Icon(
                            Icons.menu_book,
                            size: 64,
                            color: colors.cloudDancer.withValues(alpha: 0.5),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: colors.matteDark,
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: colors.neonCyan,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
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

/// Intervention tile for the Butler sheet
class _InterventionTile extends StatelessWidget {
  const _InterventionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final FocusButlerColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cloudDancer.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.cloudDancer.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.neonCyan, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colors.cloudDancer,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: colors.cloudDancer.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
