import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/license_plate/data/models/license_plate_model.dart';

void main() {
  group('LicensePlateModel', () {
    test('fromJson should create model from full JSON', () {
      final json = {
        'id': 'abc123',
        'license_plate': 'HK-1333',
        'model_name': 'A320-112',
        'airline_name': 'Latam',
        'aircraft_model_id': 'model-id-1',
        'airline_id': 'airline-id-1',
      };

      final model = LicensePlateModel.fromJson(json);

      expect(model.id, 'abc123');
      expect(model.licensePlate, 'HK-1333');
      expect(model.modelName, 'A320-112');
      expect(model.airlineName, 'Latam');
      expect(model.aircraftModelId, 'model-id-1');
      expect(model.airlineId, 'airline-id-1');
    });

    test('fromJson should handle missing optional fields', () {
      final json = {'id': 'abc123', 'license_plate': 'HK-1333'};

      final model = LicensePlateModel.fromJson(json);

      expect(model.id, 'abc123');
      expect(model.licensePlate, 'HK-1333');
      expect(model.modelName, isNull);
      expect(model.airlineName, isNull);
      expect(model.aircraftModelId, isNull);
      expect(model.airlineId, isNull);
    });

    test('fromJson should default id/licensePlate to empty string on null', () {
      final json = <String, dynamic>{};

      final model = LicensePlateModel.fromJson(json);

      expect(model.id, '');
      expect(model.licensePlate, '');
    });

    test('toJson should produce correct map', () {
      const model = LicensePlateModel(
        id: 'abc123',
        licensePlate: 'HK-1333',
        modelName: 'A320-112',
        airlineName: 'Latam',
        aircraftModelId: 'model-id-1',
        airlineId: 'airline-id-1',
      );

      final json = model.toJson();

      expect(json['id'], 'abc123');
      expect(json['license_plate'], 'HK-1333');
      expect(json['model_name'], 'A320-112');
      expect(json['airline_name'], 'Latam');
      expect(json['aircraft_model_id'], 'model-id-1');
      expect(json['airline_id'], 'airline-id-1');
    });
  });
}
