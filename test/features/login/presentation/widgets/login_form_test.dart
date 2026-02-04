import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/login/presentation/widgets/login_form.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

class FakeLoginState extends Fake implements LoginState {}

class FakeLoginEvent extends Fake implements LoginEvent {}

void main() {
  late MockLoginBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
    registerFallbackValue(FakeLoginEvent());
  });

  setUp(() {
    mockBloc = MockLoginBloc();
  });

  Widget createWidgetUnderTest({
    required void Function(String, String) onSubmit,
  }) {
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(LoginInitial()));
    when(() => mockBloc.state).thenReturn(LoginInitial());

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<LoginBloc>.value(
          value: mockBloc,
          child: LoginForm(onSubmit: onSubmit),
        ),
      ),
    );
  }

  group('LoginForm', () {
    testWidgets('should display email and password fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_, __) {}));

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display login button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_, __) {}));

      // Assert
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display forgot password link', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_, __) {}));

      // Assert
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should show validation error when email is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_, __) {}));

      // Act
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show validation error when password is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_, __) {}));

      // Act - Enter email but leave password empty
      await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should call onSubmit when form is valid', (
      WidgetTester tester,
    ) async {
      // Arrange
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onSubmit: (email, password) {
            submittedEmail = email;
            submittedPassword = password;
          },
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Assert
      expect(submittedEmail, equals('test@test.com'));
      expect(submittedPassword, equals('password123'));
    });

    testWidgets('should show loading indicator when state is LoginLoading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(LoginLoading()));
      when(() => mockBloc.state).thenReturn(LoginLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<LoginBloc>.value(
              value: mockBloc,
              child: LoginForm(onSubmit: (_, __) {}),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
