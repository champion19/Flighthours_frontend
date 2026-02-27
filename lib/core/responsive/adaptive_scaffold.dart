import 'package:flutter/material.dart';
import 'package:flight_hours_app/core/responsive/responsive_breakpoints.dart';

/// A destination for the [AdaptiveScaffold] navigation.
class AdaptiveDestination {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AdaptiveDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// An adaptive scaffold that switches between [BottomNavigationBar] on mobile
/// and [NavigationRail] on tablet/desktop.
///
/// On **mobile** (≤ 600px):
/// ```
/// ┌──────────────┐
/// │     body     │
/// ├──────────────┤
/// │ BottomNavBar │
/// └──────────────┘
/// ```
///
/// On **tablet/desktop** (> 600px):
/// ```
/// ┌────┬─────────────────┐
/// │Rail│                  │
/// │ 🏠 │      body        │
/// │ 📒 │                  │
/// │ ⚙️ │                  │
/// └────┴─────────────────┘
/// ```
class AdaptiveScaffold extends StatelessWidget {
  /// Currently selected navigation index.
  final int selectedIndex;

  /// Called when a navigation destination is tapped.
  final ValueChanged<int> onIndexChanged;

  /// Navigation destinations (minimum 2).
  final List<AdaptiveDestination> destinations;

  /// The main content body.
  final Widget body;

  /// Background color for the scaffold.
  final Color? backgroundColor;

  const AdaptiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.destinations,
    required this.body,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveBreakpoints.isMobile(constraints.maxWidth);
        final isDesktop = ResponsiveBreakpoints.isDesktop(constraints.maxWidth);

        if (isMobile) {
          return _buildMobileScaffold(context);
        }
        return _buildWideScaffold(context, extended: isDesktop);
      },
    );
  }

  /// Mobile layout: body + bottom navigation bar.
  Widget _buildMobileScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: body,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  /// Tablet/Desktop layout: navigation rail (left) + body.
  Widget _buildWideScaffold(BuildContext context, {required bool extended}) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: Row(
        children: [
          _buildNavigationRail(context, extended: extended),
          // Vertical divider between rail and content
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: Color(0xFFe9ecef),
          ),
          // Main content — takes remaining space
          Expanded(child: body),
        ],
      ),
    );
  }

  /// Bottom navigation bar for mobile.
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(destinations.length, (index) {
              final dest = destinations[index];
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onIndexChanged(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? dest.activeIcon : dest.icon,
                      color:
                          isSelected
                              ? const Color(0xFF4facfe)
                              : const Color(0xFF6c757d),
                      size: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dest.label,
                      style: TextStyle(
                        color:
                            isSelected
                                ? const Color(0xFF4facfe)
                                : const Color(0xFF6c757d),
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  /// Navigation rail for tablet/desktop.
  Widget _buildNavigationRail(BuildContext context, {required bool extended}) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onIndexChanged,
      extended: extended,
      backgroundColor: Colors.white,
      selectedIconTheme: const IconThemeData(color: Color(0xFF4facfe)),
      unselectedIconTheme: const IconThemeData(color: Color(0xFF6c757d)),
      selectedLabelTextStyle: const TextStyle(
        color: Color(0xFF4facfe),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: Color(0xFF6c757d),
        fontSize: 13,
      ),
      // Always show labels on tablet (non-extended mode)
      labelType:
          extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      leading: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: extended ? 16 : 8,
        ),
        child:
            extended
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.flight,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'FlightHours',
                      style: TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
                : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.flight,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
      ),
      destinations:
          destinations
              .map(
                (dest) => NavigationRailDestination(
                  icon: Icon(dest.icon),
                  selectedIcon: Icon(dest.activeIcon),
                  label: Text(dest.label),
                ),
              )
              .toList(),
    );
  }
}
