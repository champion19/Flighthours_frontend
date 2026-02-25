import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/tail_number/data/models/tail_number_model.dart';

void main() {
  group('TailNumberModel', () {
    test('fromJson should create model from full JSON', () {
      final json = {
        'id': 'abc123',
        'tail_number': 'HK-1333',
        'model_name': 'A320-112',
        'airline_name': 'Latam',
        'aircraft_model_id': 'model-id-1',
        'airline_id': 'airline-id-1',
      };

      final model = TailNumberModel.fromJson(json);

      expect(model.id, 'abc123');
      expect(model.tailNumber, 'HK-1333');
      expect(model.modelName, 'A320-112');
      expect(model.airlineName, 'Latam');
      expect(model.aircraftModelId, 'model-id-1');
      expect(model.airlineId, 'airline-id-1');
    });

    test('fromJson should handle missing optional fields', () {
      final json = {'id': 'abc123', 'tail_number': 'HK-1333'};

      final model = TailNumberModel.fromJson(json);

      expect(model.id, 'abc123');
      expect(model.tailNumber, 'HK-1333');
      expect(model.modelName, isNull);
      expect(model.airlineName, isNull);
      expect(model.aircraftModelId, isNull);
      expect(model.airlineId, isNull);
    });

    test('fromJson should default id/tailNumber to empty string on null', () {
      final json = <String, dynamic>{};

      final model = TailNumberModel.fromJson(json);

      expect(model.id, '');
      expect(model.tailNumber, '');
    });

    test('toJson should produce correct map', () {
      const model = TailNumberModel(
        id: 'abc123',
        tailNumber: 'HK-1333',
        modelName: 'A320-112',
        airlineName: 'Latam',
        aircraftModelId: 'model-id-1',
        airlineId: 'airline-id-1',
      );

      final json = model.toJson();

      expect(json['id'], 'abc123');
      expect(json['tail_number'], 'HK-1333');
      expect(json['model_name'], 'A320-112');
      expect(json['airline_name'], 'Latam');
      expect(json['aircraft_model_id'], 'model-id-1');
      expect(json['airline_id'], 'airline-id-1');
    });
  });
}
