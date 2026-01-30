import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom color palette for The Focus Butler app
class FocusButlerColors extends ThemeExtension<FocusButlerColors> {
  const FocusButlerColors({
    required this.neonCyan,
    required this.softAmber,
    required this.cloudDancer,
    required this.matteDark,
  });

  final Color neonCyan;
  final Color softAmber;
  final Color cloudDancer;
  final Color matteDark;

  static const FocusButlerColors deepSpace = FocusButlerColors(
    neonCyan: Color(0xFF00FFFF),
    softAmber: Color(0xFFFFBF00),
    cloudDancer: Color(0xFFF0F2F5),
    matteDark: Color(0xFF121212),
  );

  @override
  FocusButlerColors copyWith({
    Color? neonCyan,
    Color? softAmber,
    Color? cloudDancer,
    Color? matteDark,
  }) {
    return FocusButlerColors(
      neonCyan: neonCyan ?? this.neonCyan,
      softAmber: softAmber ?? this.softAmber,
      cloudDancer: cloudDancer ?? this.cloudDancer,
      matteDark: matteDark ?? this.matteDark,
    );
  }

  @override
  FocusButlerColors lerp(FocusButlerColors? other, double t) {
    if (other is! FocusButlerColors) return this;
    return FocusButlerColors(
      neonCyan: Color.lerp(neonCyan, other.neonCyan, t)!,
      softAmber: Color.lerp(softAmber, other.softAmber, t)!,
      cloudDancer: Color.lerp(cloudDancer, other.cloudDancer, t)!,
      matteDark: Color.lerp(matteDark, other.matteDark, t)!,
    );
  }
}

/// Deep Space Focus Theme for The Focus Butler
class FocusButlerTheme {
  static ThemeData get darkTheme {
    const colors = FocusButlerColors.deepSpace;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.matteDark,
      colorScheme: ColorScheme.dark(
        surface: colors.matteDark,
        primary: colors.neonCyan,
        secondary: colors.softAmber,
        onSurface: colors.cloudDancer,
        onPrimary: colors.matteDark,
        onSecondary: colors.matteDark,
      ),
      textTheme:
          GoogleFonts.atkinsonHyperlegibleTextTheme(
            ThemeData.dark().textTheme,
          ).apply(
            bodyColor: colors.cloudDancer,
            displayColor: colors.cloudDancer,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.matteDark,
        foregroundColor: colors.cloudDancer,
        elevation: 0,
      ),
      extensions: const [colors],
    );
  }
}
