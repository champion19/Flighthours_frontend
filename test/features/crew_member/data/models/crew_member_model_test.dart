import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/features/crew_member/data/models/crew_member_model.dart';

void main() {
  group('CrewMemberModel', () {
    test('fromJson should parse valid JSON correctly', () {
      final json = {'id': 'cm1', 'name': 'Jane Doe'};

      final model = CrewMemberModel.fromJson(json);

      expect(model.id, equals('cm1'));
      expect(model.name, equals('Jane Doe'));
    });

    test('fromJson should default missing fields to empty string', () {
      final model = CrewMemberModel.fromJson(const {});

      expect(model.id, equals(''));
      expect(model.name, equals(''));
    });

    test('toJson should round-trip id and name', () {
      const model = CrewMemberModel(id: 'cm1', name: 'Jane Doe');

      final json = model.toJson();

      expect(json, equals({'id': 'cm1', 'name': 'Jane Doe'}));
    });
  });
}
