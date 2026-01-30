import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the Reader screen
class ReaderState {
  final double energyLevel;
  final bool isHighImportanceBlock;
  final bool showAnalogyOverlay;
  final Offset? tappedLocation;

  const ReaderState({
    this.energyLevel = 1.0,
    this.isHighImportanceBlock = false,
    this.showAnalogyOverlay = false,
    this.tappedLocation,
  });

  ReaderState copyWith({
    double? energyLevel,
    bool? isHighImportanceBlock,
    bool? showAnalogyOverlay,
    Offset? tappedLocation,
  }) {
    return ReaderState(
      energyLevel: energyLevel ?? this.energyLevel,
      isHighImportanceBlock:
          isHighImportanceBlock ?? this.isHighImportanceBlock,
      showAnalogyOverlay: showAnalogyOverlay ?? this.showAnalogyOverlay,
      tappedLocation: tappedLocation ?? this.tappedLocation,
    );
  }
}

/// Notifier for managing Reader state (using modern Riverpod Notifier)
class ReaderNotifier extends Notifier<ReaderState> {
  Timer? _energyDecayTimer;
  Timer? _highImportanceTimer;

  @override
  ReaderState build() {
    // Start timers when the notifier is created
    _startEnergyDecay();
    _startHighImportanceMock();

    // Dispose timers when the notifier is disposed
    ref.onDispose(() {
      _energyDecayTimer?.cancel();
      _highImportanceTimer?.cancel();
    });

    return const ReaderState();
  }

  /// Start energy decay timer - slowly decreases energy over time
  void _startEnergyDecay() {
    _energyDecayTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (state.energyLevel > 0.0) {
        state = state.copyWith(
          energyLevel: (state.energyLevel - 0.02).clamp(0.0, 1.0),
        );
      }
    });
  }

  /// Mock: Toggle high importance block every 10 seconds
  void _startHighImportanceMock() {
    _highImportanceTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      state = state.copyWith(
        isHighImportanceBlock: !state.isHighImportanceBlock,
      );
      if (state.isHighImportanceBlock) {
        HapticFeedback.mediumImpact();
      }
    });
  }

  /// Called when user confirms reading a block - adds energy
  void confirmBlock() {
    HapticFeedback.lightImpact();
    state = state.copyWith(
      energyLevel: (state.energyLevel + 0.15).clamp(0.0, 1.0),
    );
  }

  /// Toggle difficulty mode - logs summary generation
  void toggleDifficult() {
    HapticFeedback.heavyImpact();
    debugPrint('[ReaderController] Generating Summary...');
  }

  /// Show analogy overlay
  void showAnalogy() {
    HapticFeedback.lightImpact();
    state = state.copyWith(showAnalogyOverlay: true);
  }

  /// Hide analogy overlay
  void hideAnalogy() {
    HapticFeedback.lightImpact();
    state = state.copyWith(showAnalogyOverlay: false);
  }

  /// Update tapped location
  void setTappedLocation(Offset location) {
    state = state.copyWith(tappedLocation: location);
  }
}

/// Provider for the Reader state
final readerProvider = NotifierProvider<ReaderNotifier, ReaderState>(() {
  return ReaderNotifier();
});
