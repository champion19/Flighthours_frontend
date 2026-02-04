import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/login/presentation/pages/login_page.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
  });

  Widget buildTestWidget({VoidCallback? onSwitchToRegister}) {
    return MaterialApp(
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: LoginPage(onSwitchToRegister: onSwitchToRegister),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('renders LoginPage with sign in text', (tester) async {
      when(() => mockLoginBloc.state).thenReturn(LoginInitial());

      await tester.pumpWidget(buildTestWidget());

      // Verify key elements are present
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows Sign up text when onSwitchToRegister is provided', (
      tester,
    ) async {
      when(() => mockLoginBloc.state).thenReturn(LoginInitial());

      await tester.pumpWidget(buildTestWidget(onSwitchToRegister: () {}));

      // The text should exist even if off-screen
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('hides Sign up when onSwitchToRegister is null', (
      tester,
    ) async {
      when(() => mockLoginBloc.state).thenReturn(LoginInitial());

      await tester.pumpWidget(buildTestWidget(onSwitchToRegister: null));

      expect(find.text("Don't have an account?"), findsNothing);
    });

    testWidgets('shows loading text when state is LoginLoading', (
      tester,
    ) async {
      when(() => mockLoginBloc.state).thenReturn(LoginLoading());

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Signing in...'), findsOneWidget);
    });

    testWidgets('shows syncing text when state is LoginSyncingPilotData', (
      tester,
    ) async {
      when(() => mockLoginBloc.state).thenReturn(LoginSyncingPilotData());

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Syncing your pilot profile...'), findsOneWidget);
    });

    testWidgets('shows error snackbar when LoginError state is emitted', (
      tester,
    ) async {
      when(() => mockLoginBloc.state).thenReturn(LoginInitial());
      whenListen(
        mockLoginBloc,
        Stream<LoginState>.fromIterable([
          LoginLoading(),
          const LoginError(message: 'Invalid credentials', code: 'ERR001'),
        ]),
        initialState: LoginInitial(),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('shows email not verified dialog on LoginEmailNotVerified', (
      tester,
    ) async {
      when(() => mockLoginBloc.state).thenReturn(LoginInitial());
      whenListen(
        mockLoginBloc,
        Stream<LoginState>.fromIterable([
          const LoginEmailNotVerified(
            message: 'Please verify your email',
            code: 'EMAIL_NOT_VERIFIED',
          ),
        ]),
        initialState: LoginInitial(),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Email Not Verified'), findsOneWidget);
      expect(find.text('Please verify your email'), findsOneWidget);
    });
  });
}
