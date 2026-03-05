/// Breakpoint constants and helpers for responsive layouts.
///
/// Mobile  :   0 – 600px
/// Tablet  : 601 – 1024px
/// Desktop : 1025+
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  /// Maximum width considered "mobile" layout
  static const double mobileMaxWidth = 600;

  /// Maximum width considered "tablet" layout
  static const double tabletMaxWidth = 1024;

  /// Returns true if [width] falls within the mobile range (0–600).
  static bool isMobile(double width) => width <= mobileMaxWidth;

  /// Returns true if [width] falls within the tablet range (601–1024).
  static bool isTablet(double width) =>
      width > mobileMaxWidth && width <= tabletMaxWidth;

  /// Returns true if [width] falls within the desktop range (1025+).
  static bool isDesktop(double width) => width > tabletMaxWidth;
}
