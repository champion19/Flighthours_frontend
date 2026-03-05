import 'package:flutter/material.dart';

/// A shared page header used across CRUD and detail pages.
///
/// Provides a consistent look: back button + title + optional subtitle
/// + optional trailing widget (typically a [GradientIconBox]).
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onBack,
    this.backButtonColor,
  });

  /// Main title text displayed in the header.
  final String title;

  /// Optional subtitle displayed below the title.
  final String? subtitle;

  /// Optional trailing widget (e.g. [GradientIconBox]).
  /// If null, a 56px SizedBox is used to balance the back button.
  final Widget? trailing;

  /// Callback for the back button. Defaults to `Navigator.pop`.
  final VoidCallback? onBack;

  /// Color for the back button icon and background tint.
  /// Defaults to `Color(0xFF4facfe)`.
  final Color? backButtonColor;

  @override
  Widget build(BuildContext context) {
    final color = backButtonColor ?? const Color(0xFF4facfe);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: color),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                subtitle != null
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF1a1a2e),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: Color(0xFF6c757d),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
          trailing ?? const SizedBox(width: 56),
        ],
      ),
    );
  }
}
