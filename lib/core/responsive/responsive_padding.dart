import 'package:flutter/material.dart';
import 'package:flight_hours_app/core/responsive/responsive_breakpoints.dart';

/// Provides adaptive padding values based on screen width.
class ResponsivePadding {
  ResponsivePadding._();

  /// Maximum content width — prevents UI from stretching infinitely on wide screens.
  static const double maxContentWidth = 1200;

  /// General page padding that increases with screen width.
  ///
  /// - Mobile:  16px all
  /// - Tablet:  32px horizontal, 20px vertical
  /// - Desktop: 48px horizontal, 24px vertical
  static EdgeInsets page(double width) {
    if (ResponsiveBreakpoints.isDesktop(width)) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    }
    if (ResponsiveBreakpoints.isTablet(width)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
    return const EdgeInsets.all(16);
  }

  /// Horizontal-only padding that scales with width.
  ///
  /// - Mobile:  16px
  /// - Tablet:  32px
  /// - Desktop: 48px
  static EdgeInsets horizontal(double width) {
    if (ResponsiveBreakpoints.isDesktop(width)) {
      return const EdgeInsets.symmetric(horizontal: 48);
    }
    if (ResponsiveBreakpoints.isTablet(width)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  /// Wraps a child in a centered [ConstrainedBox] with [maxContentWidth].
  ///
  /// Use this to prevent content from stretching on very wide screens.
  static Widget constrainedContent({required Widget child}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }
}
