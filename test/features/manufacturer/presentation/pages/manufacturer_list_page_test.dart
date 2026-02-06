import 'package:bloc_test/bloc_test.dart';
import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_bloc.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_event.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_state.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/pages/manufacturer_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockManufacturerBloc
    extends MockBloc<ManufacturerEvent, ManufacturerState>
    implements ManufacturerBloc {}

class FakeManufacturerEvent extends Fake implements ManufacturerEvent {}

void main() {
  late MockManufacturerBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeManufacturerEvent());
  });

  setUp(() {
    mockBloc = MockManufacturerBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ManufacturerBloc>.value(
        value: mockBloc,
        child: const ManufacturerListPage(),
      ),
    );
  }

  final testManufacturers = [
    const ManufacturerEntity(id: '1', name: 'Embraer', country: 'Brazil'),
    const ManufacturerEntity(id: '2', name: 'Cessna', country: 'USA'),
    const ManufacturerEntity(id: '3', name: 'Bombardier', country: 'Canada'),
  ];

  group('ManufacturerListPage', () {
    testWidgets('should display loading indicator when state is loading', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ManufacturerLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display list of manufacturers when state is success', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(ManufacturerSuccess(manufacturers: testManufacturers));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Embraer'), findsOneWidget);
      expect(find.text('Cessna'), findsOneWidget);
      expect(find.text('Bombardier'), findsOneWidget);
    });

    testWidgets('should display error message when state is error', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const ManufacturerError(message: 'Network error'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should display empty message when no manufacturers', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(ManufacturerSuccess(manufacturers: const []));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No manufacturers available'), findsOneWidget);
    });

    testWidgets('should display AppBar with correct title', (tester) async {
      when(() => mockBloc.state).thenReturn(ManufacturerInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Manufacturers'), findsOneWidget);
    });

    testWidgets('retry button should be visible when error state', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(const ManufacturerError(message: 'Error'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show generic icon for manufacturers without logo', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(ManufacturerSuccess(manufacturers: testManufacturers));

      await tester.pumpWidget(createWidgetUnderTest());

      // Embraer, Cessna, Bombardier should show generic icon
      expect(find.byIcon(Icons.precision_manufacturing), findsNWidgets(3));
    });

    testWidgets('should display manufacturer cards in a list', (tester) async {
      when(
        () => mockBloc.state,
      ).thenReturn(ManufacturerSuccess(manufacturers: testManufacturers));

      await tester.pumpWidget(createWidgetUnderTest());

      // Should find ListView with manufacturer items
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display no manufacturers found for initial state', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ManufacturerInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No manufacturers found.'), findsOneWidget);
    });

    testWidgets('should trigger FetchManufacturers on init', (tester) async {
      when(() => mockBloc.state).thenReturn(ManufacturerInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      verify(
        () => mockBloc.add(any(that: isA<FetchManufacturers>())),
      ).called(1);
    });
  });
}
