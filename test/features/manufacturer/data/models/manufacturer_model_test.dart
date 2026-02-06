import 'dart:convert';
import 'package:flight_hours_app/features/manufacturer/data/models/manufacturer_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ManufacturerModel', () {
    group('fromJson', () {
      test('should create model from valid JSON with all fields', () {
        final json = {
          'id': 'test-id',
          'uuid': 'uuid-123',
          'name': 'Boeing',
          'country': 'USA',
          'description': 'American manufacturer',
          'status': '1',
        };

        final model = ManufacturerModel.fromJson(json);

        expect(model.id, 'test-id');
        expect(model.uuid, 'uuid-123');
        expect(model.name, 'Boeing');
        expect(model.country, 'USA');
        expect(model.description, 'American manufacturer');
        expect(model.status, 'active');
      });

      test('should parse status "1" as active', () {
        final json = {'id': 'id', 'name': 'Test', 'status': '1'};
        final model = ManufacturerModel.fromJson(json);
        expect(model.status, 'active');
      });

      test('should parse status 1 (int) as active', () {
        final json = {'id': 'id', 'name': 'Test', 'status': 1};
        final model = ManufacturerModel.fromJson(json);
        expect(model.status, 'active');
      });

      test('should parse status true as active', () {
        final json = {'id': 'id', 'name': 'Test', 'status': true};
        final model = ManufacturerModel.fromJson(json);
        expect(model.status, 'active');
      });

      test('should parse status "active" as active', () {
        final json = {'id': 'id', 'name': 'Test', 'status': 'active'};
        final model = ManufacturerModel.fromJson(json);
        expect(model.status, 'active');
      });

      test('should parse status "0" as inactive', () {
        final json = {'id': 'id', 'name': 'Test', 'status': '0'};
        final model = ManufacturerModel.fromJson(json);
        expect(model.status, 'inactive');
      });

      test('should parse status 0 (int) as inactive', () {
        final json = {'id': 'id', 'name': 'Test', 'status': 0};
        final model = ManufacturerModel.fromJson(json);
        expect(model.status, 'inactive');
      });

      test('should use manufacturer_name field if name is missing', () {
        final json = {'id': 'id', 'manufacturer_name': 'Airbus'};
        final model = ManufacturerModel.fromJson(json);
        expect(model.name, 'Airbus');
      });

      test('should default to empty string if id is null', () {
        final json = {'name': 'Test'};
        final model = ManufacturerModel.fromJson(json);
        expect(model.id, '');
      });

      test('should default to empty string if name is null', () {
        final json = {'id': 'test-id'};
        final model = ManufacturerModel.fromJson(json);
        expect(model.name, '');
      });
    });

    group('toJson', () {
      test('should convert model to JSON', () {
        const model = ManufacturerModel(
          id: 'test-id',
          uuid: 'uuid-123',
          name: 'Boeing',
          country: 'USA',
          description: 'Test description',
          status: 'active',
        );

        final json = model.toJson();

        expect(json['id'], 'test-id');
        expect(json['uuid'], 'uuid-123');
        expect(json['name'], 'Boeing');
        expect(json['country'], 'USA');
        expect(json['description'], 'Test description');
        expect(json['status'], '1');
      });

      test('should convert inactive status to "0"', () {
        const model = ManufacturerModel(
          id: 'test-id',
          name: 'Test',
          status: 'inactive',
        );

        final json = model.toJson();
        expect(json['status'], '0');
      });
    });

    group('manufacturerModelFromMap', () {
      test(
        'should parse list from wrapped response with manufacturers key',
        () {
          final jsonStr = json.encode({
            'success': true,
            'data': {
              'manufacturers': [
                {'id': '1', 'name': 'Boeing'},
                {'id': '2', 'name': 'Airbus'},
              ],
              'total': 2,
            },
          });

          final result = manufacturerModelFromMap(jsonStr);

          expect(result.length, 2);
          expect(result[0].name, 'Boeing');
          expect(result[1].name, 'Airbus');
        },
      );

      test('should parse list from data array', () {
        final jsonStr = json.encode({
          'success': true,
          'data': [
            {'id': '1', 'name': 'Boeing'},
          ],
        });

        final result = manufacturerModelFromMap(jsonStr);

        expect(result.length, 1);
        expect(result[0].name, 'Boeing');
      });

      test('should parse direct array response', () {
        final jsonStr = json.encode([
          {'id': '1', 'name': 'Embraer'},
        ]);

        final result = manufacturerModelFromMap(jsonStr);

        expect(result.length, 1);
        expect(result[0].name, 'Embraer');
      });

      test('should return empty list for invalid format', () {
        final jsonStr = json.encode({'invalid': 'data'});

        final result = manufacturerModelFromMap(jsonStr);

        expect(result, isEmpty);
      });

      test('should return empty list for empty manufacturers array', () {
        final jsonStr = json.encode({
          'data': {'manufacturers': []},
        });

        final result = manufacturerModelFromMap(jsonStr);
        expect(result, isEmpty);
      });
    });
  });
}
