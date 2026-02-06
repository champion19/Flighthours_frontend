import 'package:bloc_test/bloc_test.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_bloc.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';
import 'package:flight_hours_app/features/airport/presentation/pages/airport_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAirportBloc extends MockBloc<AirportEvent, AirportState>
    implements AirportBloc {}

class FakeAirportEvent extends Fake implements AirportEvent {}

void main() {
  late MockAirportBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeAirportEvent());
  });

  setUp(() {
    mockBloc = MockAirportBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AirportBloc>.value(
        value: mockBloc,
        child: const AirportListPage(),
      ),
    );
  }

  final testAirports = [
    const AirportEntity(
      id: '1',
      name: 'El Dorado International',
      iataCode: 'BOG',
      city: 'Bogotá',
      country: 'Colombia',
      status: 'active',
      airportType: 'International',
    ),
    const AirportEntity(
      id: '2',
      name: 'José María Córdova',
      iataCode: 'MDE',
      city: 'Medellín',
      country: 'Colombia',
      status: 'inactive',
    ),
  ];

  group('AirportListPage', () {
    testWidgets('should display loading indicator when state is loading', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display list of airports when state is success', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess(testAirports));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('El Dorado International'), findsOneWidget);
      expect(find.text('José María Córdova'), findsOneWidget);
    });

    testWidgets('should display error message when state is error', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const AirportError('Network error'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should display AppBar with correct title', (tester) async {
      when(() => mockBloc.state).thenReturn(AirportInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Airports'), findsOneWidget);
    });

    testWidgets('should display IATA code chip for airports with code', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess(testAirports));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('BOG'), findsOneWidget);
      expect(find.text('MDE'), findsOneWidget);
    });

    testWidgets('should display city chip for airports with city', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess(testAirports));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Bogotá'), findsOneWidget);
      expect(find.text('Medellín'), findsOneWidget);
    });

    testWidgets('should display country chip for airports with country', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess(testAirports));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Colombia'), findsWidgets);
    });

    testWidgets('should display Active badge for active airports', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[0]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('should display Inactive badge for inactive airports', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[1]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('should display Deactivate button for active airports', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[0]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Deactivate'), findsOneWidget);
    });

    testWidgets('should display Activate button for inactive airports', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[1]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Activate'), findsOneWidget);
    });

    testWidgets('should display airport type when available', (tester) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[0]]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('International'), findsOneWidget);
    });

    testWidgets('tapping Deactivate should show confirmation dialog', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[0]]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate Airport'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('tapping Activate should show confirmation dialog', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[1]]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Activate'));
      await tester.pumpAndSettle();

      expect(find.text('Activate Airport'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancel button in dialog should close dialog', (tester) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess([testAirports[0]]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate Airport'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate Airport'), findsNothing);
    });

    testWidgets('should display no airports message when empty list', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AirportInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No airports found.'), findsOneWidget);
    });

    testWidgets('should display airport icon for each airport', (tester) async {
      when(() => mockBloc.state).thenReturn(AirportSuccess(testAirports));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.local_airport), findsNWidgets(2));
    });

    testWidgets('should trigger FetchAirports on init', (tester) async {
      when(() => mockBloc.state).thenReturn(AirportInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      verify(() => mockBloc.add(any(that: isA<FetchAirports>()))).called(1);
    });
  });
}
