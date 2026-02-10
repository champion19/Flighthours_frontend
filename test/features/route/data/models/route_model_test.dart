import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/route/data/models/route_model.dart';

void main() {
  group('RouteModel', () {
    test('fromJson creates model with all fields', () {
      final json = {
        'id': 'rt-001',
        'uuid': 'uuid-123',
        'origin_airport_id': 'ap-001',
        'destination_airport_id': 'ap-002',
        'origin_airport_name': 'El Dorado International',
        'origin_airport_code': 'BOG',
        'origin_country': 'Colombia',
        'destination_airport_name': 'London Heathrow',
        'destination_airport_code': 'LHR',
        'destination_country': 'United Kingdom',
        'route_type': 'Internacional',
        'estimated_flight_time': '07:30:00',
        'status': 'active',
      };

      final model = RouteModel.fromJson(json);

      expect(model.id, 'rt-001');
      expect(model.uuid, 'uuid-123');
      expect(model.originAirportId, 'ap-001');
      expect(model.destinationAirportId, 'ap-002');
      expect(model.originAirportName, 'El Dorado International');
      expect(model.originAirportCode, 'BOG');
      expect(model.originCountry, 'Colombia');
      expect(model.destinationAirportName, 'London Heathrow');
      expect(model.destinationAirportCode, 'LHR');
      expect(model.destinationCountry, 'United Kingdom');
      expect(model.routeType, 'Internacional');
      expect(model.estimatedFlightTime, '07:30:00');
      expect(model.status, 'active');
    });

    test('fromJson handles alternative field names', () {
      final json = {
        'id': '1',
        'origin_airport_id': 'ap-001',
        'destination_airport_id': 'ap-002',
        'origin_iata_code': 'BOG',
        'destination_iata_code': 'LHR',
        'airport_type': 'Nacional',
      };

      final model = RouteModel.fromJson(json);

      expect(model.originAirportCode, 'BOG');
      expect(model.destinationAirportCode, 'LHR');
      expect(model.routeType, 'Nacional');
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final model = RouteModel.fromJson(json);

      expect(model.id, '');
      expect(model.originAirportId, '');
      expect(model.destinationAirportId, '');
      expect(model.uuid, isNull);
      expect(model.originAirportName, isNull);
      expect(model.status, isNull);
    });

    test('fromJson converts non-string id to string', () {
      final json = {
        'id': 42,
        'origin_airport_id': 10,
        'destination_airport_id': 20,
      };

      final model = RouteModel.fromJson(json);

      expect(model.id, '42');
      expect(model.originAirportId, '10');
      expect(model.destinationAirportId, '20');
    });

    test('toJson serializes all fields correctly', () {
      const model = RouteModel(
        id: 'rt-001',
        uuid: 'uuid-123',
        originAirportId: 'ap-001',
        destinationAirportId: 'ap-002',
        originAirportName: 'El Dorado',
        originAirportCode: 'BOG',
        originCountry: 'Colombia',
        destinationAirportName: 'Heathrow',
        destinationAirportCode: 'LHR',
        destinationCountry: 'UK',
        routeType: 'Internacional',
        estimatedFlightTime: '07:30:00',
        status: 'active',
      );

      final json = model.toJson();

      expect(json['id'], 'rt-001');
      expect(json['uuid'], 'uuid-123');
      expect(json['origin_airport_id'], 'ap-001');
      expect(json['destination_airport_id'], 'ap-002');
      expect(json['origin_airport_name'], 'El Dorado');
      expect(json['origin_airport_code'], 'BOG');
      expect(json['origin_country'], 'Colombia');
      expect(json['destination_airport_name'], 'Heathrow');
      expect(json['destination_airport_code'], 'LHR');
      expect(json['destination_country'], 'UK');
      expect(json['route_type'], 'Internacional');
      expect(json['estimated_flight_time'], '07:30:00');
      expect(json['status'], 'active');
    });
  });
}
