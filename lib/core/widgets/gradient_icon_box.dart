import 'package:flutter/material.dart';

/// A small icon container with a gradient background.
///
/// Used as the trailing widget in [AppPageHeader] and in cards
/// throughout the app. Replaces the repeated pattern of
/// Container + LinearGradient + Icon.
class GradientIconBox extends StatelessWidget {
  const GradientIconBox({
    super.key,
    required this.icon,
    this.gradientColors,
    this.size = 24,
    this.padding = 12,
    this.borderRadius = 12,
  });

  /// The icon to display.
  final IconData icon;

  /// Gradient colors. Defaults to the app's primary blue gradient.
  final List<Color>? gradientColors;

  /// Icon size. Defaults to 24.
  final double size;

  /// Internal padding. Defaults to 12.
  final double padding;

  /// Corner radius. Defaults to 12.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ?? const [Color(0xFF4facfe), Color(0xFF00f2fe)];

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }
}
