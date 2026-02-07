import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/aircraft_model/data/models/aircraft_model_model.dart';

void main() {
  group('AircraftModelModel', () {
    test('fromJson creates model with all fields', () {
      final json = {
        'id': 'am-001',
        'name': 'A320-200',
        'aircraft_type_name': 'Passenger',
        'family': 'A320',
        'manufacturer_name': 'Airbus',
        'engine_name': 'CFM56',
        'status': 'active',
      };

      final model = AircraftModelModel.fromJson(json);

      expect(model.id, 'am-001');
      expect(model.name, 'A320-200');
      expect(model.aircraftTypeName, 'Passenger');
      expect(model.family, 'A320');
      expect(model.manufacturerName, 'Airbus');
      expect(model.engineName, 'CFM56');
      expect(model.status, 'active');
    });

    test('fromJson handles bool status true', () {
      final json = {'id': '1', 'name': 'Test', 'status': true};
      final model = AircraftModelModel.fromJson(json);
      expect(model.status, 'active');
    });

    test('fromJson handles bool status false', () {
      final json = {'id': '1', 'name': 'Test', 'status': false};
      final model = AircraftModelModel.fromJson(json);
      expect(model.status, 'inactive');
    });

    test('fromJson handles alternative field names', () {
      final json = {
        'id': '1',
        'model_name': 'B737-800',
        'manufacturer': 'Boeing',
        'engine_type_name': 'CFM LEAP',
      };
      final model = AircraftModelModel.fromJson(json);
      expect(model.name, 'B737-800');
      expect(model.manufacturerName, 'Boeing');
      expect(model.engineName, 'CFM LEAP');
    });

    test('fromJson uses aircraft_model_name fallback', () {
      final json = {'id': '1', 'aircraft_model_name': 'E190'};
      final model = AircraftModelModel.fromJson(json);
      expect(model.name, 'E190');
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};
      final model = AircraftModelModel.fromJson(json);
      expect(model.id, '');
      expect(model.name, '');
      expect(model.aircraftTypeName, isNull);
      expect(model.status, isNull);
    });

    test('toJson returns correct map', () {
      const model = AircraftModelModel(
        id: 'am-001',
        name: 'A320-200',
        aircraftTypeName: 'Passenger',
        family: 'A320',
        manufacturerName: 'Airbus',
        engineName: 'CFM56',
        status: 'active',
      );

      final json = model.toJson();

      expect(json['id'], 'am-001');
      expect(json['name'], 'A320-200');
      expect(json['aircraft_type_name'], 'Passenger');
      expect(json['family'], 'A320');
      expect(json['manufacturer_name'], 'Airbus');
      expect(json['engine_name'], 'CFM56');
      expect(json['status'], 'active');
    });
  });

  group('aircraftModelModelFromMap', () {
    test('parses standard response format', () {
      final jsonStr = jsonEncode({
        'success': true,
        'data': {
          'aircraftModels': [
            {'id': '1', 'name': 'A320', 'status': 'active'},
            {'id': '2', 'name': 'B737', 'status': 'inactive'},
          ],
          'total': 2,
        },
      });

      final models = aircraftModelModelFromMap(jsonStr);
      expect(models.length, 2);
      expect(models[0].name, 'A320');
      expect(models[1].name, 'B737');
    });

    test('parses data as direct array', () {
      final jsonStr = jsonEncode({
        'success': true,
        'data': [
          {'id': '1', 'name': 'E190'},
        ],
      });

      final models = aircraftModelModelFromMap(jsonStr);
      expect(models.length, 1);
      expect(models[0].name, 'E190');
    });

    test('parses direct array response', () {
      final jsonStr = jsonEncode([
        {'id': '1', 'name': 'CRJ-900'},
      ]);

      final models = aircraftModelModelFromMap(jsonStr);
      expect(models.length, 1);
      expect(models[0].name, 'CRJ-900');
    });

    test('returns empty list for empty data', () {
      final jsonStr = jsonEncode({'success': true, 'data': {}});
      final models = aircraftModelModelFromMap(jsonStr);
      expect(models, isEmpty);
    });

    test('returns empty list for invalid format', () {
      final jsonStr = jsonEncode({'success': true});
      final models = aircraftModelModelFromMap(jsonStr);
      expect(models, isEmpty);
    });
  });

  group('aircraftModelModelToMap', () {
    test('serializes list of models', () {
      final models = [
        const AircraftModelModel(id: '1', name: 'A320', status: 'active'),
        const AircraftModelModel(id: '2', name: 'B737', status: 'inactive'),
      ];

      final jsonStr = aircraftModelModelToMap(models);
      final decoded = jsonDecode(jsonStr) as List;
      expect(decoded.length, 2);
      expect(decoded[0]['name'], 'A320');
    });
  });
}
