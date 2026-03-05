import 'package:flight_hours_app/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveLayout', () {
    Future<void> pumpAtWidth(
      WidgetTester tester, {
      required double width,
      required WidgetBuilder mobile,
      WidgetBuilder? tablet,
      WidgetBuilder? desktop,
    }) async {
      await tester.binding.setSurfaceSize(Size(width, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: MaterialApp(
            home: ResponsiveLayout(
              mobile: mobile,
              tablet: tablet,
              desktop: desktop,
            ),
          ),
        ),
      );
    }

    testWidgets('shows mobile builder at 400px width', (tester) async {
      await pumpAtWidth(
        tester,
        width: 400,
        mobile: (_) => const Text('MOBILE'),
        tablet: (_) => const Text('TABLET'),
        desktop: (_) => const Text('DESKTOP'),
      );
      expect(find.text('MOBILE'), findsOneWidget);
      expect(find.text('TABLET'), findsNothing);
      expect(find.text('DESKTOP'), findsNothing);
    });

    testWidgets('shows tablet builder at 800px width', (tester) async {
      await pumpAtWidth(
        tester,
        width: 800,
        mobile: (_) => const Text('MOBILE'),
        tablet: (_) => const Text('TABLET'),
        desktop: (_) => const Text('DESKTOP'),
      );
      expect(find.text('TABLET'), findsOneWidget);
      expect(find.text('MOBILE'), findsNothing);
      expect(find.text('DESKTOP'), findsNothing);
    });

    testWidgets('shows desktop builder at 1200px width', (tester) async {
      await pumpAtWidth(
        tester,
        width: 1200,
        mobile: (_) => const Text('MOBILE'),
        tablet: (_) => const Text('TABLET'),
        desktop: (_) => const Text('DESKTOP'),
      );
      expect(find.text('DESKTOP'), findsOneWidget);
      expect(find.text('MOBILE'), findsNothing);
      expect(find.text('TABLET'), findsNothing);
    });

    testWidgets('falls back to mobile when tablet is null at 800px', (
      tester,
    ) async {
      await pumpAtWidth(
        tester,
        width: 800,
        mobile: (_) => const Text('MOBILE'),
        desktop: (_) => const Text('DESKTOP'),
      );
      expect(find.text('MOBILE'), findsOneWidget);
    });

    testWidgets('falls back to tablet when desktop is null at 1200px', (
      tester,
    ) async {
      await pumpAtWidth(
        tester,
        width: 1200,
        mobile: (_) => const Text('MOBILE'),
        tablet: (_) => const Text('TABLET'),
      );
      expect(find.text('TABLET'), findsOneWidget);
    });

    testWidgets(
      'falls back to mobile when both tablet and desktop are null at 1200px',
      (tester) async {
        await pumpAtWidth(
          tester,
          width: 1200,
          mobile: (_) => const Text('MOBILE'),
        );
        expect(find.text('MOBILE'), findsOneWidget);
      },
    );

    testWidgets('shows mobile at boundary 600px', (tester) async {
      await pumpAtWidth(
        tester,
        width: 600,
        mobile: (_) => const Text('MOBILE'),
        tablet: (_) => const Text('TABLET'),
        desktop: (_) => const Text('DESKTOP'),
      );
      expect(find.text('MOBILE'), findsOneWidget);
    });

    testWidgets('shows tablet at boundary 601px', (tester) async {
      await pumpAtWidth(
        tester,
        width: 601,
        mobile: (_) => const Text('MOBILE'),
        tablet: (_) => const Text('TABLET'),
        desktop: (_) => const Text('DESKTOP'),
      );
      expect(find.text('TABLET'), findsOneWidget);
    });

    testWidgets('shows desktop at boundary 1025px', (tester) async {
      await pumpAtWidth(
        tester,
        width: 1025,
        mobile: (_) => const Text('MOBILE'),
        tablet: (_) => const Text('TABLET'),
        desktop: (_) => const Text('DESKTOP'),
      );
      expect(find.text('DESKTOP'), findsOneWidget);
    });
  });
}
