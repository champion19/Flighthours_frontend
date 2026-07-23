import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_bloc.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';
import 'package:flight_hours_app/features/employee/data/models/employee_airline_routes_model.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_bloc.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_event.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_state.dart';
import 'package:flight_hours_app/features/logbook/presentation/pages/new_flight_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeBloc extends MockBloc<EmployeeEvent, EmployeeState>
    implements EmployeeBloc {}

class MockAirportBloc extends MockBloc<AirportEvent, AirportState>
    implements AirportBloc {}

class MockFlightBloc extends MockBloc<FlightEvent, FlightState>
    implements FlightBloc {}

class FakeEmployeeEvent extends Fake implements EmployeeEvent {}

class FakeAirportEvent extends Fake implements AirportEvent {}

class FakeFlightEvent extends Fake implements FlightEvent {}

void main() {
  late MockEmployeeBloc employeeBloc;
  late MockAirportBloc airportBloc;
  late MockFlightBloc flightBloc;

  setUpAll(() {
    registerFallbackValue(FakeEmployeeEvent());
    registerFallbackValue(FakeAirportEvent());
    registerFallbackValue(FakeFlightEvent());
  });

  setUp(() {
    employeeBloc = MockEmployeeBloc();
    airportBloc = MockAirportBloc();
    flightBloc = MockFlightBloc();
    when(() => employeeBloc.state).thenReturn(EmployeeInitial());
    when(() => airportBloc.state).thenReturn(AirportInitial());
    when(() => flightBloc.state).thenReturn(const FlightInitial());
  });

  Widget createWidgetUnderTest({Map<String, dynamic>? arguments}) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EmployeeBloc>.value(value: employeeBloc),
          BlocProvider<AirportBloc>.value(value: airportBloc),
          BlocProvider<FlightBloc>.value(value: flightBloc),
        ],
        child: Navigator(
          onGenerateRoute:
              (settings) => MaterialPageRoute(
                settings: RouteSettings(arguments: arguments),
                builder: (_) => const NewFlightPage(),
              ),
        ),
      ),
    );
  }

  testWidgets('shows "New Flight" with no route subtitle before typing anything', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('New Flight'), findsOneWidget);
    expect(find.textContaining('→'), findsNothing);
  });

  testWidgets('updates the AppBar title with the flight number as the user types', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, '4043');
    await tester.pump();

    expect(find.text('Flight 4043'), findsOneWidget);
    expect(find.text('New Flight'), findsNothing);
  });

  testWidgets(
    'resolves the route by airport ID when the origin airport has only an '
    'OACI code (no IATA), and falls back to OACI for display',
    (tester) async {
      // Olaya Herrera only has an OACI code — this is the real-world case
      // that used to be unresolvable when matching was done by IATA code.
      final origin = const AirportEntity(
        id: 'ap-1',
        name: 'Olaya Herrera',
        oaciCode: 'SKRG',
      );
      final destination = const AirportEntity(
        id: 'ap-2',
        name: 'El Dorado',
        iataCode: 'BOG',
        oaciCode: 'SKBO',
      );
      final route = const AirlineRouteEntity(
        id: 'r1',
        routeId: 'route-1',
        airlineId: 'airline-1',
        originAirportId: 'ap-1',
        originOaciCode: 'SKRG',
        destinationAirportId: 'ap-2',
        destinationAirportCode: 'BOG',
        airlineName: 'Test Air',
      );

      whenListen(
        airportBloc,
        Stream.value(AirportSuccess([origin, destination])),
        initialState: AirportInitial(),
      );
      whenListen(
        employeeBloc,
        Stream.value(
          EmployeeAirlineRoutesSuccess(
            EmployeeAirlineRoutesResponseModel(
              success: true,
              code: 'OK',
              message: 'ok',
              data: [route],
            ),
          ),
        ),
        initialState: EmployeeInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Search and select the origin by its OACI code.
      await tester.enterText(
        find.widgetWithText(TextField, 'Ingrese origen'),
        'SKRG',
      );
      await tester.pump();

      // The search result's primary label falls back to the OACI code
      // instead of showing a blank/placeholder IATA slot.
      expect(find.text('Olaya Herrera, SKRG'), findsOneWidget);

      await tester.tap(find.textContaining('Olaya Herrera').first);
      await tester.pump();

      // Search and select the destination by its IATA code.
      await tester.enterText(
        find.widgetWithText(TextField, 'Ingrese destino'),
        'BOG',
      );
      await tester.pump();
      await tester.tap(find.textContaining('El Dorado').first);
      await tester.pump();

      // The route resolved (by airport ID) and the card shows the OACI
      // fallback for the origin since it has no IATA code.
      expect(find.text('SKRG → BOG'), findsWidgets);
      expect(find.textContaining('No hay ruta configurada'), findsNothing);
    },
  );

  testWidgets(
    'auto-requests a pending airline_route link when the origin/destination '
    'pair has no active link for the employee\'s airline yet',
    (tester) async {
      final origin = const AirportEntity(id: 'ap-1', name: 'Rionegro', iataCode: 'MDE');
      final destination = const AirportEntity(
        id: 'ap-2',
        name: 'El Dorado',
        iataCode: 'BOG',
      );

      final employeeStates = StreamController<EmployeeState>.broadcast();
      addTearDown(employeeStates.close);
      whenListen(
        employeeBloc,
        employeeStates.stream,
        initialState: EmployeeInitial(),
      );
      whenListen(
        airportBloc,
        Stream.value(AirportSuccess([origin, destination])),
        initialState: AirportInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // No local match: the employee's airline has zero active routes.
      // Pushed only after the widget is mounted — a broadcast stream drops
      // events emitted before anything subscribes.
      employeeStates.add(
        EmployeeAirlineRoutesSuccess(
          EmployeeAirlineRoutesResponseModel(
            success: true,
            code: 'OK',
            message: 'ok',
            data: const [],
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextField, 'Ingrese origen'),
        'MDE',
      );
      await tester.pump();
      await tester.tap(find.textContaining('Rionegro').first);
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextField, 'Ingrese destino'),
        'BOG',
      );
      await tester.pump();
      await tester.tap(find.textContaining('El Dorado').first);
      await tester.pump();

      // Dispatched the resolve request with the raw (non-obfuscated in this
      // test) airport IDs from the selected AirportEntity objects.
      final captured =
          verify(
                () => employeeBloc.add(captureAny(that: isA<ResolveAirlineRoute>())),
              ).captured.single
              as ResolveAirlineRoute;
      expect(captured.originAirportId, 'ap-1');
      expect(captured.destinationAirportId, 'ap-2');

      // Backend auto-created the link as pending — surface that instead of
      // silently blocking or showing the "no route configured" error.
      employeeStates.add(
        const AirlineRouteResolved(
          AirlineRouteEntity(
            id: 'ar-new',
            routeId: 'route-1',
            airlineId: 'airline-1',
            status: 'pending',
            originAirportCode: 'MDE',
            destinationAirportCode: 'BOG',
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('enviada para aprobación'), findsOneWidget);
      expect(find.textContaining('No hay ruta configurada'), findsNothing);
    },
  );

  testWidgets(
    'falls back to the "no route configured" message when resolve 404s '
    '(no physical route exists for that pair at all)',
    (tester) async {
      final origin = const AirportEntity(id: 'ap-1', name: 'Rionegro', iataCode: 'MDE');
      final destination = const AirportEntity(
        id: 'ap-3',
        name: 'Somewhere Else',
        iataCode: 'XYZ',
      );

      final employeeStates = StreamController<EmployeeState>.broadcast();
      addTearDown(employeeStates.close);
      whenListen(
        employeeBloc,
        employeeStates.stream,
        initialState: EmployeeInitial(),
      );
      whenListen(
        airportBloc,
        Stream.value(AirportSuccess([origin, destination])),
        initialState: AirportInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      employeeStates.add(
        EmployeeAirlineRoutesSuccess(
          EmployeeAirlineRoutesResponseModel(
            success: true,
            code: 'OK',
            message: 'ok',
            data: const [],
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextField, 'Ingrese origen'),
        'MDE',
      );
      await tester.pump();
      await tester.tap(find.textContaining('Rionegro').first);
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextField, 'Ingrese destino'),
        'XYZ',
      );
      await tester.pump();
      await tester.tap(find.textContaining('Somewhere Else').first);
      await tester.pump();

      employeeStates.add(
        const EmployeeError(message: 'Route not found', statusCode: 404),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('No hay ruta configurada'), findsOneWidget);
      expect(find.textContaining('enviada para aprobación'), findsNothing);
    },
  );
}
