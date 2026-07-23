import 'package:bloc_test/bloc_test.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_bloc.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';
import 'package:flight_hours_app/features/daily_logbook_detail/presentation/pages/daily_logbook_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogbookBloc extends MockBloc<LogbookEvent, LogbookState>
    implements LogbookBloc {}

class FakeLogbookEvent extends Fake implements LogbookEvent {}

void main() {
  late MockLogbookBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeLogbookEvent());
  });

  setUp(() {
    mockBloc = MockLogbookBloc();
    when(() => mockBloc.state).thenReturn(const LogbookInitial());
  });

  final existingDetail = LogbookDetailEntity(
    id: '1',
    uuid: 'uuid-1',
    dailyLogbookId: 'logbook-1',
    flightNumber: '4043',
    flightRealDate: DateTime(2026, 7, 22),
    originIataCode: 'MDE',
    destinationIataCode: 'BOG',
    routeCode: 'MDE-BOG',
    tailNumber: 'CC-BAQ',
    outTime: '10:00:00',
    takeoffTime: '10:15:00',
    landingTime: '11:15:00',
    inTime: '11:30:00',
    pilotRole: 'PF',
  );

  Widget createWidgetUnderTest() {
    // DailyLogbookDetailPage reads its data from
    // ModalRoute.of(context)?.settings.arguments, so it must be pushed as a
    // route carrying those arguments rather than dropped in via `home:`.
    return MaterialApp(
      home: Navigator(
        onGenerateRoute:
            (settings) => MaterialPageRoute(
              settings: RouteSettings(
                arguments: {'detail': existingDetail},
              ),
              builder:
                  (_) => BlocProvider<LogbookBloc>.value(
                    value: mockBloc,
                    child: const DailyLogbookDetailPage(),
                  ),
            ),
      ),
    );
  }

  testWidgets(
    'Departure/Arrival update live when OUT/IN are edited, without leaving the page',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Simulate reopening an already-saved flight — Departure/Arrival start
      // from the persisted OUT/IN times (10:00 / 11:30).
      Text valueOf(Key key) => tester.widget<Text>(find.byKey(key));
      expect(valueOf(const Key('departureValue')).data, '10:00');
      expect(valueOf(const Key('arrivalValue')).data, '11:30');

      // Edit OUT and IN like a pilot correcting the saved times.
      await tester.enterText(find.widgetWithText(TextField, 'HH:MM').at(0), '0930');
      await tester.pump();
      await tester.enterText(find.widgetWithText(TextField, 'HH:MM').at(3), '1200');
      await tester.pump();

      // Departure/Arrival must reflect the new values immediately — no
      // navigation, no re-fetch — this is the exact bug being fixed.
      expect(valueOf(const Key('departureValue')).data, '09:30');
      expect(valueOf(const Key('arrivalValue')).data, '12:00');
    },
  );

  testWidgets(
    'AppBar title shows flight number + route, and the date from the flight itself '
    '(not from a `logbook` argument, which is absent right after creating a flight)',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final appBarTitle = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(Column),
      );
      expect(
        find.descendant(of: appBarTitle, matching: find.text('Flight 4043')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: appBarTitle, matching: find.text('MDE-BOG')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: appBarTitle,
          matching: find.text('July 22, 2026'),
        ),
        findsOneWidget,
      );
    },
  );
}
