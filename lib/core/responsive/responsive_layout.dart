import 'package:flutter/material.dart';
import 'package:flight_hours_app/core/responsive/responsive_breakpoints.dart';

/// A widget that renders different layouts based on the available width.
///
/// Uses [LayoutBuilder] internally to determine which builder to use:
/// - [mobile] is required and used for widths ≤ 600px.
/// - [tablet] is optional; if omitted, [mobile] is used for 601–1024px.
/// - [desktop] is optional; if omitted, [tablet] (or [mobile]) is used for 1025+.
///
/// Example:
/// ```dart
/// ResponsiveLayout(
///   mobile: (context) => MobileView(),
///   tablet: (context) => TabletView(),
///   desktop: (context) => DesktopView(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  /// Builder for mobile layout (≤ 600px). Required.
  final WidgetBuilder mobile;

  /// Builder for tablet layout (601–1024px). Falls back to [mobile].
  final WidgetBuilder? tablet;

  /// Builder for desktop layout (1025+). Falls back to [tablet], then [mobile].
  final WidgetBuilder? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (ResponsiveBreakpoints.isDesktop(width)) {
          return (desktop ?? tablet ?? mobile)(context);
        }

        if (ResponsiveBreakpoints.isTablet(width)) {
          return (tablet ?? mobile)(context);
        }

        return mobile(context);
      },
    );
  }
}
