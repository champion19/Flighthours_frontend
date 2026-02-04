import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/reset_password/presentation/bloc/reset_password_bloc.dart';
import 'package:flight_hours_app/features/reset_password/presentation/widgets/reset_password_form.dart';

class MockResetPasswordBloc extends Mock implements ResetPasswordBloc {}

class FakeResetPasswordState extends Fake implements ResetPasswordState {}

class FakeResetPasswordEvent extends Fake implements ResetPasswordEvent {}

void main() {
  late MockResetPasswordBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeResetPasswordState());
    registerFallbackValue(FakeResetPasswordEvent());
  });

  setUp(() {
    mockBloc = MockResetPasswordBloc();
  });

  Widget createWidgetUnderTest({required void Function(String) onSubmit}) {
    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream.value(ResetPasswordInitial()));
    when(() => mockBloc.state).thenReturn(ResetPasswordInitial());

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: BlocProvider<ResetPasswordBloc>.value(
            value: mockBloc,
            child: ResetPasswordForm(onSubmit: onSubmit),
          ),
        ),
      ),
    );
  }

  group('ResetPasswordForm', () {
    testWidgets('should display email field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should display submit button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      // Assert
      expect(find.text('Send Reset Link'), findsOneWidget);
    });

    testWidgets('should display header text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      // Assert
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should show validation error when email is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      // Act
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      // Act
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should call onSubmit when form is valid', (
      WidgetTester tester,
    ) async {
      // Arrange
      String? submittedEmail;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onSubmit: (email) {
            submittedEmail = email;
          },
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Assert
      expect(submittedEmail, equals('test@example.com'));
    });

    testWidgets('should show loading indicator when state is loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(ResetPasswordLoading()));
      when(() => mockBloc.state).thenReturn(ResetPasswordLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BlocProvider<ResetPasswordBloc>.value(
                value: mockBloc,
                child: ResetPasswordForm(onSubmit: (_) {}),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
