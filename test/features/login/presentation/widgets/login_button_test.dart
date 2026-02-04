import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/login/presentation/widgets/login_button.dart';

void main() {
  group('LoginEnter', () {
    testWidgets('should display the text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoginEnter(text: 'Sign In', onPressed: () {})),
        ),
      );

      // Assert
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginEnter(
              text: 'Login',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Assert
      expect(wasPressed, isTrue);
    });

    testWidgets('should have gradient decoration', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoginEnter(text: 'Login', onPressed: () {})),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('should have fixed height of 60', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoginEnter(text: 'Login', onPressed: () {})),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.minHeight, equals(60));
    });

    testWidgets('should expand to full width', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoginEnter(text: 'Login', onPressed: () {}),
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, equals(double.infinity));
    });
  });
}
