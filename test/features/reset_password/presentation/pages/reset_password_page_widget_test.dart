import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';
import 'package:flight_hours_app/features/reset_password/presentation/widgets/reset_password_form.dart';

class MockResetPasswordBloc
    extends MockBloc<ResetPasswordEvent, ResetPasswordState>
    implements ResetPasswordBloc {}

void main() {
  late MockResetPasswordBloc mockBloc;

  setUp(() {
    mockBloc = MockResetPasswordBloc();
    // Default to initial state
    when(() => mockBloc.state).thenReturn(ResetPasswordInitial());
  });

  Widget buildTestWidget({void Function(String)? onSubmit}) {
    return MaterialApp(
      home: BlocProvider<ResetPasswordBloc>.value(
        value: mockBloc,
        child: Scaffold(
          body: SingleChildScrollView(
            child: ResetPasswordForm(onSubmit: onSubmit ?? (email) {}),
          ),
        ),
      ),
    );
  }

  group('ResetPasswordForm Widget Tests', () {
    testWidgets('should render form with all elements', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.byIcon(Icons.lock_reset_rounded), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should show email label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should validate empty email', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should validate invalid email format', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.enterText(find.byType(TextFormField), 'invalidemail');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should call onSubmit with valid email', (tester) async {
      String? submittedEmail;

      await tester.pumpWidget(
        buildTestWidget(onSubmit: (email) => submittedEmail = email),
      );

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(submittedEmail, equals('test@example.com'));
    });

    testWidgets('should accept email with hyphen in domain', (tester) async {
      String? submittedEmail;

      await tester.pumpWidget(
        buildTestWidget(onSubmit: (email) => submittedEmail = email),
      );

      await tester.enterText(find.byType(TextFormField), 'user@my-domain.com');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(submittedEmail, equals('user@my-domain.com'));
    });

    testWidgets('should show loading indicator when loading state', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ResetPasswordLoading());

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('should show button when initial state', (tester) async {
      when(() => mockBloc.state).thenReturn(ResetPasswordInitial());

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
    });

    testWidgets('should accept various valid email formats', (tester) async {
      String? submittedEmail;

      await tester.pumpWidget(
        buildTestWidget(onSubmit: (email) => submittedEmail = email),
      );

      // Test with subdomain email
      await tester.enterText(
        find.byType(TextFormField),
        'user@mail.example.com',
      );
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(submittedEmail, equals('user@mail.example.com'));
    });

    testWidgets('should have email icon in text field', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });
  });
}
