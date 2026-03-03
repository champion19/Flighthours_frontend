import 'package:flight_hours_app/core/responsive/responsive_padding.dart';
import 'package:flutter/material.dart';

/// A convenience wrapper that applies responsive padding and max-width
/// constraints to a scrollable body.
///
/// This extracts the repeated pattern of:
/// ```dart
/// Center(
///   child: ConstrainedBox(
///     constraints: BoxConstraints(maxWidth: ResponsivePadding.maxContentWidth),
///     child: SingleChildScrollView(
///       padding: ...,
///       child: content,
///     ),
///   ),
/// )
/// ```
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.child, this.padding});

  /// The content to display inside the scrollable, constrained area.
  final Widget child;

  /// Optional custom padding. Defaults to `EdgeInsets.all(20)`.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: ResponsivePadding.maxContentWidth,
        ),
        child: SingleChildScrollView(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
