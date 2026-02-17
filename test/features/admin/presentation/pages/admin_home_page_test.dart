import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/admin/presentation/pages/admin_home_page.dart';

void main() {
  Widget buildTestWidget() {
    return const MaterialApp(home: AdminHomePage());
  }

  group('AdminHomePage', () {
    testWidgets('renders AdminHomePage with header', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify header elements
      expect(find.text('Admin Panel'), findsOneWidget);
      expect(find.text('System Administration'), findsOneWidget);
    });

    testWidgets('displays welcome card', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Welcome, Admin!'), findsOneWidget);
    });

    testWidgets('displays route management section', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('ROUTE MANAGEMENT'), findsOneWidget);
      expect(find.text('Airlines'), findsOneWidget);
      expect(find.text('Routes'), findsOneWidget);
      expect(find.text('Airline Routes'), findsOneWidget);
    });

    testWidgets('displays system configuration section', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('SYSTEM CONFIGURATION'), findsOneWidget);
      expect(find.text('Airports'), findsOneWidget);
      expect(find.text('Manufacturers'), findsOneWidget);
      expect(find.text('System Settings'), findsOneWidget);
    });

    testWidgets('has logout button in header', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('has admin icon in header', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.admin_panel_settings), findsWidgets);
    });
  });
}
