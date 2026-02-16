import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/crew_member_type/data/models/crew_member_type_model.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';

void main() {
  group('CrewMemberTypeModel', () {
    test('fromJson should parse all fields', () {
      final json = {
        'id': 'cmt1',
        'uuid': 'uuid-123',
        'name': 'Pilot',
        'description': 'Pilot role',
        'status': 'active',
      };

      final model = CrewMemberTypeModel.fromJson(json);

      expect(model.id, 'cmt1');
      expect(model.uuid, 'uuid-123');
      expect(model.name, 'Pilot');
      expect(model.description, 'Pilot role');
      expect(model.status, 'active');
      expect(model, isA<CrewMemberTypeEntity>());
    });

    test('fromJson should handle crew_member_type_name', () {
      final json = {'id': 'cmt2', 'crew_member_type_name': 'Co-Pilot'};

      final model = CrewMemberTypeModel.fromJson(json);
      expect(model.name, 'Co-Pilot');
    });

    test('fromJson should handle missing fields', () {
      final json = <String, dynamic>{'id': 'cmt3'};

      final model = CrewMemberTypeModel.fromJson(json);
      expect(model.id, 'cmt3');
      expect(model.uuid, isNull);
      expect(model.name, isNull);
    });

    test('toJson should produce correct map', () {
      const model = CrewMemberTypeModel(
        id: 'cmt1',
        uuid: 'uuid-123',
        name: 'Pilot',
        description: 'Pilot role',
        status: 'active',
      );

      final json = model.toJson();

      expect(json['id'], 'cmt1');
      expect(json['uuid'], 'uuid-123');
      expect(json['name'], 'Pilot');
      expect(json['description'], 'Pilot role');
      expect(json['status'], 'active');
    });
  });

  group('crewMemberTypeModelFromMap', () {
    test('should parse nested data.crew_member_types structure', () {
      const jsonStr =
          '{"data": {"crew_member_types": [{"id": "1", "name": "Pilot"}, {"id": "2", "name": "Co-Pilot"}]}}';
      final result = crewMemberTypeModelFromMap(jsonStr);
      expect(result.length, 2);
      expect(result[0].name, 'Pilot');
      expect(result[1].name, 'Co-Pilot');
    });

    test('should parse data as direct array', () {
      const jsonStr = '{"data": [{"id": "1", "name": "Pilot"}]}';
      final result = crewMemberTypeModelFromMap(jsonStr);
      expect(result.length, 1);
      expect(result[0].name, 'Pilot');
    });

    test('should parse top-level array', () {
      const jsonStr = '[{"id": "1", "name": "Pilot"}]';
      final result = crewMemberTypeModelFromMap(jsonStr);
      expect(result.length, 1);
      expect(result[0].name, 'Pilot');
    });

    test('should return empty list for unrecognized format', () {
      const jsonStr = '{"unknown": "data"}';
      final result = crewMemberTypeModelFromMap(jsonStr);
      expect(result, isEmpty);
    });
  });
}
