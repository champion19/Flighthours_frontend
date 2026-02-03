import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/logbook/data/models/logbook_detail_model.dart';

void main() {
  group('LogbookDetailModel', () {
    test('fromJson should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'id': 'XwdEsEKzC83JFr1zSXL6T8wcvP1Hd4W',
        'uuid': 'FCDE13AF-66B1-431E-AF58-013DBB61E7F2',
        'daily_logbook_id': 'RZDtPJJtD3JCEZ4HDr2fZMxiD8PtQLL',
        'flight_real_date': '2025-12-14T00:00:00-05:00',
        'flight_number': '4043',
        'airline_route_id': 'Z26wt6QYsMY2UZz9ioXoiXktz8NuaJK',
        'route_code': 'MDE-BOG',
        'origin_iata_code': 'MDE',
        'destination_iata_code': 'BOG',
        'airline_code': 'AV',
        'actual_aircraft_registration_id': 'RrydfpW2u8QGhKYoH8LptV3JcJ5NCGQ5',
        'license_plate': 'CC-BAQ',
        'model_name': 'A320-112',
        'passengers': 174,
        'out_time': '21:17:00',
        'takeoff_time': '21:35:00',
        'landing_time': '22:04:00',
        'in_time': '22:07:00',
        'pilot_role': 'PM',
        'companion_name': 'David Ramirez',
        'air_time': '00:29:00',
        'block_time': '00:50:00',
        'duty_time': '10:14:00',
        'approach_type': 'VISUAL',
        'flight_type': 'Comercial',
        'log_date': '2026-01-07T00:00:00-05:00',
      };

      // Act
      final result = LogbookDetailModel.fromJson(json);

      // Assert
      expect(result.id, equals('XwdEsEKzC83JFr1zSXL6T8wcvP1Hd4W'));
      expect(result.uuid, equals('FCDE13AF-66B1-431E-AF58-013DBB61E7F2'));
      expect(result.dailyLogbookId, equals('RZDtPJJtD3JCEZ4HDr2fZMxiD8PtQLL'));
      expect(result.flightNumber, equals('4043'));
      expect(result.routeCode, equals('MDE-BOG'));
      expect(result.originIataCode, equals('MDE'));
      expect(result.destinationIataCode, equals('BOG'));
      expect(result.airlineCode, equals('AV'));
      expect(result.licensePlate, equals('CC-BAQ'));
      expect(result.modelName, equals('A320-112'));
      expect(result.passengers, equals(174));
      expect(result.outTime, equals('21:17:00'));
      expect(result.takeoffTime, equals('21:35:00'));
      expect(result.landingTime, equals('22:04:00'));
      expect(result.inTime, equals('22:07:00'));
      expect(result.pilotRole, equals('PM'));
      expect(result.companionName, equals('David Ramirez'));
      expect(result.airTime, equals('00:29:00'));
      expect(result.blockTime, equals('00:50:00'));
      expect(result.dutyTime, equals('10:14:00'));
      expect(result.approachType, equals('VISUAL'));
      expect(result.flightType, equals('Comercial'));
    });

    test('fromJson should parse dates correctly', () {
      // Arrange
      final json = {
        'id': 'test1',
        'flight_real_date': '2025-12-14T00:00:00-05:00',
        'log_date': '2026-01-07',
      };

      // Act
      final result = LogbookDetailModel.fromJson(json);

      // Assert
      expect(result.flightRealDate, isNotNull);
      expect(result.flightRealDate!.year, equals(2025));
      expect(result.flightRealDate!.month, equals(12));
      expect(result.flightRealDate!.day, equals(14));
      expect(result.logDate, isNotNull);
    });

    test('fromJson should parse passengers as int from various types', () {
      // Arrange - int value
      final jsonInt = {'id': 'test1', 'passengers': 150};
      // Arrange - string value
      final jsonString = {'id': 'test2', 'passengers': '200'};
      // Arrange - double value
      final jsonDouble = {'id': 'test3', 'passengers': 175.0};

      // Act
      final resultInt = LogbookDetailModel.fromJson(jsonInt);
      final resultString = LogbookDetailModel.fromJson(jsonString);
      final resultDouble = LogbookDetailModel.fromJson(jsonDouble);

      // Assert
      expect(resultInt.passengers, equals(150));
      expect(resultString.passengers, equals(200));
      expect(resultDouble.passengers, equals(175));
    });

    test('fromJson should handle null values gracefully', () {
      // Arrange
      final json = {'id': 'test1'};

      // Act
      final result = LogbookDetailModel.fromJson(json);

      // Assert
      expect(result.id, equals('test1'));
      expect(result.uuid, isNull);
      expect(result.flightNumber, isNull);
      expect(result.passengers, isNull);
      expect(result.flightRealDate, isNull);
    });

    test('fromJson should handle empty JSON', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = LogbookDetailModel.fromJson(json);

      // Assert
      expect(result.id, equals(''));
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final model = LogbookDetailModel(
        id: 'test123',
        uuid: 'uuid-1234',
        flightNumber: '4043',
        airlineRouteId: 'route123',
        passengers: 150,
        outTime: '21:17:00',
        takeoffTime: '21:35:00',
        landingTime: '22:04:00',
        inTime: '22:07:00',
        pilotRole: 'PM',
        companionName: 'John Doe',
        airTime: '00:29:00',
        blockTime: '00:50:00',
        dutyTime: '10:14:00',
        approachType: 'VISUAL',
        flightType: 'Comercial',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['id'], equals('test123'));
      expect(result['uuid'], equals('uuid-1234'));
      expect(result['flight_number'], equals('4043'));
      expect(result['passengers'], equals(150));
      expect(result['pilot_role'], equals('PM'));
    });

    test('toJson should exclude null values', () {
      // Arrange
      const model = LogbookDetailModel(id: 'test123');

      // Act
      final result = model.toJson();

      // Assert
      expect(result.containsKey('uuid'), isFalse);
      expect(result.containsKey('flight_number'), isFalse);
      expect(result.containsKey('passengers'), isFalse);
    });

    test('createRequest should build correct request body', () {
      // Act
      final result = LogbookDetailModel.createRequest(
        flightRealDate: '2025-12-14',
        flightNumber: '4043',
        airlineRouteId: 'route123',
        actualAircraftRegistrationId: 'aircraft123',
        passengers: 150,
        outTime: '21:17:00',
        takeoffTime: '21:35:00',
        landingTime: '22:04:00',
        inTime: '22:07:00',
        pilotRole: 'PM',
        companionName: 'John Doe',
        airTime: '00:29:00',
        blockTime: '00:50:00',
        dutyTime: '10:14:00',
        approachType: 'VISUAL',
        flightType: 'Comercial',
      );

      // Assert
      expect(result['flight_real_date'], equals('2025-12-14'));
      expect(result['flight_number'], equals('4043'));
      expect(result['airline_route_id'], equals('route123'));
      expect(result['passengers'], equals(150));
      expect(result['pilot_role'], equals('PM'));
    });
  });
}
