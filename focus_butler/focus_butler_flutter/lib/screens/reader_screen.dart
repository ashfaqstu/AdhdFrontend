import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../core/theme.dart';
import '../features/reader/reader_controller.dart';
import '../widgets/analogy_card.dart';
import '../widgets/energy_ribbon.dart';

/// Reader Screen - Immersive PDF reading experience with energy tracking
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({
    super.key,
    required this.bookId,
  });

  final String bookId;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfController = PdfViewerController();

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  void _onPdfTap(PdfGestureDetails details) {
    HapticFeedback.lightImpact();
    ref.read(readerProvider.notifier).confirmBlock();
    ref.read(readerProvider.notifier).setTappedLocation(details.position);
  }

  @override
  Widget build(BuildContext context) {
    final readerState = ref.watch(readerProvider);
    final colors = Theme.of(context).extension<FocusButlerColors>()!;

    return Scaffold(
      backgroundColor: colors.matteDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.cloudDancer),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Reading: ${widget.bookId}',
          style: TextStyle(
            color: colors.cloudDancer,
            fontSize: 16,
          ),
        ),
        actions: [
          // Energy indicator
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.bolt,
                    color: readerState.energyLevel > 0.3
                        ? colors.softAmber
                        : colors.softAmber.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(readerState.energyLevel * 100).toInt()}%',
                    style: TextStyle(
                      color: colors.cloudDancer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Layer 1: PDF Viewer (Full Screen / Immersive)
          Positioned.fill(
            child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
              key: _pdfViewerKey,
              controller: _pdfController,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
              onTap: _onPdfTap,
              pageLayoutMode: PdfPageLayoutMode.continuous,
            ),
          ),

          // Layer 2: Energy Ribbon (Bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: EnergyRibbon(energyLevel: readerState.energyLevel),
          ),

          // Layer 3: Analogy Overlay (Conditional)
          if (readerState.showAnalogyOverlay)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // Dismiss on background tap
                  ref.read(readerProvider.notifier).hideAnalogy();
                },
                child: Container(
                  color: colors.matteDark.withValues(alpha: 0.7),
                  child: AnalogyCard(
                    onClose: () {
                      ref.read(readerProvider.notifier).hideAnalogy();
                    },
                  ),
                ),
              ),
            ),
        ],
      ),

      // Floating Action Button - The Guardrail
      floatingActionButton: _buildGuardrailFAB(readerState, colors),
    );
  }

  Widget _buildGuardrailFAB(ReaderState readerState, FocusButlerColors colors) {
    final isHighImportance = readerState.isHighImportanceBlock;

    return FloatingActionButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        if (isHighImportance) {
          ref.read(readerProvider.notifier).showAnalogy();
        } else {
          // Standard mode - could navigate to next section
          debugPrint('[ReaderScreen] Continue to next section');
        }
      },
      backgroundColor: isHighImportance
          ? colors.softAmber.withValues(alpha: 0.9)
          : colors.neonCyan.withValues(alpha: 0.9),
      elevation: 4,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isHighImportance ? Icons.lightbulb : Icons.arrow_forward,
          key: ValueKey(isHighImportance),
          color: colors.matteDark,
          size: 28,
        ),
      ),
    );
  }
}
