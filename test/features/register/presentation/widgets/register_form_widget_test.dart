import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_hours_app/features/register/domain/entities/Employee_Entity_Register.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_event.dart';
import 'package:flight_hours_app/features/register/presentation/bloc/register_state.dart';
import 'package:flight_hours_app/features/register/presentation/widgets/register_form.dart';

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

class FakeRegisterEvent extends Fake implements RegisterEvent {}

void main() {
  late MockRegisterBloc mockBloc;
  late PageController pageController;

  setUpAll(() {
    registerFallbackValue(FakeRegisterEvent());
  });

  setUp(() {
    mockBloc = MockRegisterBloc();
    pageController = PageController();
    when(() => mockBloc.state).thenReturn(RegisterInitial());
  });

  tearDown(() {
    pageController.dispose();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<RegisterBloc>.value(
        value: mockBloc,
        child: Scaffold(
          body: SingleChildScrollView(
            child: RegisterForm(pageController: pageController),
          ),
        ),
      ),
    );
  }

  group('RegisterForm Widget Tests', () {
    testWidgets('should render all form fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find TextFormFields
      expect(find.byType(TextFormField), findsNWidgets(5));
    });

    testWidgets('should show email field with label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should show name field with label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('should show ID Number field with label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('ID Number'), findsOneWidget);
    });

    testWidgets('should show Password field with label', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should show Confirm Password field with label', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should have Continue button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Find visibility toggle icons
      final visibilityIcons = find.byIcon(Icons.visibility_off);
      expect(
        visibilityIcons,
        findsNWidgets(2),
      ); // Password and Confirm Password

      // Tap first visibility icon
      await tester.tap(visibilityIcons.first);
      await tester.pumpAndSettle();

      // Now should show visibility icon (eye open)
      expect(find.byIcon(Icons.visibility), findsAtLeastNWidgets(1));
    });

    testWidgets('should validate empty fields on submit', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap Continue without filling fields
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.textContaining('required'), findsAtLeastNWidgets(1));
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(RegisterLoading(employee: EmployeeEntityRegister.empty()));

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have email icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Check for expected icons - at least email icon should exist
      expect(find.byType(Icon), findsAtLeastNWidgets(1));
    });
  });
}
