import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flight_hours_app/features/register/presentation/pages/personal_info_page.dart';

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

void main() {
  late MockRegisterBloc mockBloc;
  late PageController pageController;

  setUp(() {
    mockBloc = MockRegisterBloc();
    pageController = PageController();
    when(() => mockBloc.state).thenReturn(RegisterInitial());
  });

  tearDown(() {
    pageController.dispose();
  });

  Widget buildTestWidget({VoidCallback? onSwitchToLogin}) {
    return MaterialApp(
      home: BlocProvider<RegisterBloc>.value(
        value: mockBloc,
        child: Scaffold(
          body: Personalinfo(
            pageController: pageController,
            onSwitchToLogin: onSwitchToLogin,
          ),
        ),
      ),
    );
  }

  group('Personalinfo Page Tests', () {
    testWidgets('should render title text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Personal Information'), findsOneWidget);
    });

    testWidgets('should render subtitle text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Enter your basic details'), findsOneWidget);
    });

    testWidgets('should render RegisterForm', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // RegisterForm contains TextFormFields
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    });

    testWidgets('should show login link when callback provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(onSwitchToLogin: () {}));

      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should not show login link when callback is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(onSwitchToLogin: null));

      expect(find.text('Already have an account?'), findsNothing);
    });

    testWidgets('should call onSwitchToLogin when tapped', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        buildTestWidget(onSwitchToLogin: () => called = true),
      );

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
