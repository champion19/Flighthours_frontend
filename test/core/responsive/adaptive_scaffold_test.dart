import 'package:flight_hours_app/core/responsive/adaptive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final destinations = [
    const AdaptiveDestination(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    const AdaptiveDestination(
      icon: Icons.book_outlined,
      activeIcon: Icons.book,
      label: 'Logbook',
    ),
    const AdaptiveDestination(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  /// Helper that sets the test surface size, pumps the widget, and restores
  /// the default surface size after the test body runs.
  Future<void> pumpAtSize(
    WidgetTester tester, {
    required double width,
    required double height,
    int selectedIndex = 0,
    ValueChanged<int>? onIndexChanged,
  }) async {
    // Ensure the test surface is large enough for the desired constraints
    await tester.binding.setSurfaceSize(Size(width, height));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: MaterialApp(
          home: AdaptiveScaffold(
            selectedIndex: selectedIndex,
            onIndexChanged: onIndexChanged ?? (_) {},
            destinations: destinations,
            body: const Text('BODY_CONTENT'),
          ),
        ),
      ),
    );
  }

  group('AdaptiveScaffold', () {
    group('mobile layout (width ≤ 600)', () {
      testWidgets('shows body content', (tester) async {
        await pumpAtSize(tester, width: 400, height: 800);
        expect(find.text('BODY_CONTENT'), findsOneWidget);
      });

      testWidgets('does NOT show NavigationRail', (tester) async {
        await pumpAtSize(tester, width: 400, height: 800);
        expect(find.byType(NavigationRail), findsNothing);
      });

      testWidgets('shows navigation labels in bottom bar', (tester) async {
        await pumpAtSize(tester, width: 400, height: 800);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Logbook'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('tapping a bottom nav item calls onIndexChanged', (
        tester,
      ) async {
        int? changedIndex;
        await pumpAtSize(
          tester,
          width: 400,
          height: 800,
          onIndexChanged: (i) => changedIndex = i,
        );
        // Tap the "Logbook" label (index 1)
        await tester.tap(find.text('Logbook'));
        await tester.pumpAndSettle();
        expect(changedIndex, 1);
      });
    });

    group('tablet layout (601 ≤ width ≤ 1024)', () {
      testWidgets('shows body content', (tester) async {
        await pumpAtSize(tester, width: 800, height: 800);
        expect(find.text('BODY_CONTENT'), findsOneWidget);
      });

      testWidgets('shows NavigationRail', (tester) async {
        await pumpAtSize(tester, width: 800, height: 800);
        expect(find.byType(NavigationRail), findsOneWidget);
      });

      testWidgets('NavigationRail is NOT extended on tablet', (tester) async {
        await pumpAtSize(tester, width: 800, height: 800);
        final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
        expect(rail.extended, isFalse);
      });

      testWidgets('tapping NavigationRail item calls onIndexChanged', (
        tester,
      ) async {
        int? changedIndex;
        await pumpAtSize(
          tester,
          width: 800,
          height: 800,
          onIndexChanged: (i) => changedIndex = i,
        );
        final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
        rail.onDestinationSelected?.call(2);
        expect(changedIndex, 2);
      });
    });

    group('desktop layout (width > 1024)', () {
      testWidgets('shows body content', (tester) async {
        await pumpAtSize(tester, width: 1200, height: 900);
        expect(find.text('BODY_CONTENT'), findsOneWidget);
      });

      testWidgets('shows NavigationRail', (tester) async {
        await pumpAtSize(tester, width: 1200, height: 900);
        expect(find.byType(NavigationRail), findsOneWidget);
      });

      testWidgets('NavigationRail is extended on desktop', (tester) async {
        await pumpAtSize(tester, width: 1200, height: 900);
        final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
        expect(rail.extended, isTrue);
      });

      testWidgets('shows FlightHours branding text', (tester) async {
        await pumpAtSize(tester, width: 1200, height: 900);
        expect(find.text('FlightHours'), findsOneWidget);
      });
    });

    group('AdaptiveDestination', () {
      test('stores icon, activeIcon, and label', () {
        const dest = AdaptiveDestination(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
        );
        expect(dest.icon, Icons.home_outlined);
        expect(dest.activeIcon, Icons.home);
        expect(dest.label, 'Home');
      });
    });
  });
}
