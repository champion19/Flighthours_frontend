import 'package:bloc_test/bloc_test.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';
import 'package:flight_hours_app/features/airline/presentation/pages/airline_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAirlineBloc extends MockBloc<AirlineEvent, AirlineState>
    implements AirlineBloc {}

class FakeAirlineEvent extends Fake implements AirlineEvent {}

void main() {
  late MockAirlineBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeAirlineEvent());
  });

  setUp(() {
    mockBloc = MockAirlineBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AirlineBloc>.value(
        value: mockBloc,
        child: const AirlineListPage(),
      ),
    );
  }

  final testAirlines = [
    const AirlineEntity(id: '1', name: 'Avianca', code: 'AV', active: true),
    const AirlineEntity(id: '2', name: 'LATAM', code: 'LA', active: false),
  ];

  group('AirlineListPage', () {
    testWidgets('should display loading indicator when state is loading', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display list of airlines when state is success', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess(testAirlines));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Avianca'), findsOneWidget);
      expect(find.text('LATAM'), findsOneWidget);
    });

    testWidgets('should display error message when state is error', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const AirlineError('Network error'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should display AppBar with correct title', (tester) async {
      when(() => mockBloc.state).thenReturn(AirlineInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Airlines'), findsOneWidget);
    });

    testWidgets('should display Active badge for active airlines', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess([testAirlines[0]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('should display Inactive badge for inactive airlines', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess([testAirlines[1]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('should display Deactivate button for active airlines', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess([testAirlines[0]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Deactivate'), findsOneWidget);
    });

    testWidgets('should display Activate button for inactive airlines', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess([testAirlines[1]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Activate'), findsOneWidget);
    });

    testWidgets('tapping Deactivate should show confirmation dialog', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess([testAirlines[0]]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate Airline'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('tapping Activate should show confirmation dialog', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess([testAirlines[1]]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Activate'));
      await tester.pumpAndSettle();

      expect(find.text('Activate Airline'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancel button in dialog should close dialog', (tester) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess([testAirlines[0]]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate Airline'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate Airline'), findsNothing);
    });

    testWidgets('should display flight icon for each airline', (tester) async {
      when(() => mockBloc.state).thenReturn(AirlineSuccess(testAirlines));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.flight), findsNWidgets(2));
    });

    testWidgets('should trigger FetchAirlines on init', (tester) async {
      when(() => mockBloc.state).thenReturn(AirlineInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      verify(() => mockBloc.add(any(that: isA<FetchAirlines>()))).called(1);
    });

    testWidgets('should display no airlines found when initial state', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirlineInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No airlines found.'), findsOneWidget);
    });
  });
}
