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
        'origin_airport_id': 'Z26wt6QYsMY2UZz9ioXoiXktz8NuaJK',
        'destination_airport_id': 'P8vXt9QYsMY2UZz9ioXoiXktz8NuaJK',
        'route_code': 'MDE-BOG',
        'origin_iata_code': 'MDE',
        'destination_iata_code': 'BOG',
        'airline_code': 'AV',
        'tail_number_id': 'RrydfpW2u8QGhKYoH8LptV3JcJ5NCGQ5',
        'tail_number': 'CC-BAQ',
        'model_name': 'A320-112',
        'passengers': 174,
        'out_time': '21:17:00',
        'takeoff_time': '21:35:00',
        'landing_time': '22:04:00',
        'in_time': '22:07:00',
        'pilot_role': 'PM',
        'air_time': '00:29:00',
        'block_time': '00:50:00',
        'duty_time': '10:14:00',
        'approach_category': 'ILS',
        'approach_subtype': 'CAT I',
        'autoland': true,
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
      expect(result.tailNumber, equals('CC-BAQ'));
      expect(result.modelName, equals('A320-112'));
      expect(result.passengers, equals(174));
      expect(result.outTime, equals('21:17:00'));
      expect(result.takeoffTime, equals('21:35:00'));
      expect(result.landingTime, equals('22:04:00'));
      expect(result.inTime, equals('22:07:00'));
      expect(result.pilotRole, equals('PM'));
      expect(result.airTime, equals('00:29:00'));
      expect(result.blockTime, equals('00:50:00'));
      expect(result.dutyTime, equals('10:14:00'));
      expect(result.approachCategory, equals('ILS'));
      expect(result.approachSubtype, equals('CAT I'));
      expect(result.autoland, isTrue);
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
        originAirportId: 'airport-o',
        destinationAirportId: 'airport-d',
        passengers: 150,
        outTime: '21:17:00',
        takeoffTime: '21:35:00',
        landingTime: '22:04:00',
        inTime: '22:07:00',
        pilotRole: 'PM',
        airTime: '00:29:00',
        blockTime: '00:50:00',
        dutyTime: '10:14:00',
        approachCategory: 'ILS',
        approachSubtype: 'CAT I',
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
        originAirportId: 'airport-o',
        destinationAirportId: 'airport-d',
        tailNumberId: 'aircraft123',
        passengers: 150,
        outTime: '21:17:00',
        takeoffTime: '21:35:00',
        landingTime: '22:04:00',
        inTime: '22:07:00',
        pilotRole: 'PM',
        airTime: '00:29:00',
        blockTime: '00:50:00',
        dutyTime: '10:14:00',
        approachCategory: 'VISUAL',
        flightType: 'Comercial',
      );

      // Assert
      expect(result['flight_real_date'], equals('2025-12-14'));
      expect(result['flight_number'], equals('4043'));
      expect(result['origin_airport_id'], equals('airport-o'));
      expect(result['destination_airport_id'], equals('airport-d'));
      expect(result['passengers'], equals(150));
      expect(result['pilot_role'], equals('PM'));
    });
    test('toJson should include formatted flight_real_date', () {
      final model = LogbookDetailModel(
        id: 'test123',
        flightRealDate: DateTime(2025, 12, 14),
      );
      final result = model.toJson();
      expect(result['flight_real_date'], equals('2025-12-14'));
    });

    test('updateRequest should include crewRole when provided', () {
      final result = LogbookDetailModel.updateRequest(
        flightRealDate: '2025-12-14',
        flightNumber: '4043',
        originAirportId: 'o1',
        destinationAirportId: 'd1',
        tailNumberId: 't1',
        crewRole: 'captain',
      );
      expect(result['crew_role'], equals('captain'));
    });

    test('updateRequest should exclude crewRole when empty', () {
      final result = LogbookDetailModel.updateRequest(
        flightRealDate: '2025-12-14',
        flightNumber: '4043',
        originAirportId: 'o1',
        destinationAirportId: 'd1',
        tailNumberId: 't1',
        crewRole: '',
      );
      expect(result.containsKey('crew_role'), isFalse);
    });

    test('fromJson should parse crew array when present', () {
      final json = {
        'id': 'd1',
        'crew': [
          {
            'id': 'a1',
            'crew_member_id': 'cm1',
            'name': 'Jane Doe',
            'role': 'first_officer',
          },
          {
            'id': 'a2',
            'crew_member_id': 'cm2',
            'name': 'John Smith',
            'role': 'purser',
          },
        ],
      };

      final model = LogbookDetailModel.fromJson(json);

      expect(model.crew, isNotNull);
      expect(model.crew!.length, equals(2));
      expect(model.crew![0].crewMemberId, equals('cm1'));
      expect(model.crew![0].name, equals('Jane Doe'));
      expect(model.crew![0].role, equals('first_officer'));
      expect(model.crew![1].role, equals('purser'));
    });

    test('fromJson should leave crew null when absent', () {
      final model = LogbookDetailModel.fromJson({'id': 'd1'});
      expect(model.crew, isNull);
    });

    test('updateRequest should omit crew key when not provided (null)', () {
      final result = LogbookDetailModel.updateRequest(
        flightRealDate: '2025-12-14',
        flightNumber: '4043',
        originAirportId: 'o1',
        destinationAirportId: 'd1',
        tailNumberId: 't1',
      );
      expect(result.containsKey('crew'), isFalse);
    });

    test(
      'updateRequest should send an explicit empty crew list to clear it',
      () {
        final result = LogbookDetailModel.updateRequest(
          flightRealDate: '2025-12-14',
          flightNumber: '4043',
          originAirportId: 'o1',
          destinationAirportId: 'd1',
          tailNumberId: 't1',
          crew: const [],
        );
        expect(result.containsKey('crew'), isTrue);
        expect(result['crew'], isEmpty);
      },
    );

    test('updateRequest should include populated crew list as-is', () {
      final result = LogbookDetailModel.updateRequest(
        flightRealDate: '2025-12-14',
        flightNumber: '4043',
        originAirportId: 'o1',
        destinationAirportId: 'd1',
        tailNumberId: 't1',
        crew: const [
          {'crew_member_id': 'cm1', 'role': 'first_officer'},
        ],
      );
      expect(result['crew'], equals([{'crew_member_id': 'cm1', 'role': 'first_officer'}]));
    });
  });
}
