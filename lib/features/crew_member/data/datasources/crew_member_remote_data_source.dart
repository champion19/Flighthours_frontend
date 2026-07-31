import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/crew_member/data/models/crew_member_model.dart';

/// Interface for crew member (roster) remote data source
abstract class CrewMemberRemoteDataSource {
  /// GET /crew-members?search= — the pilot's own roster, optionally filtered by name
  Future<List<CrewMemberModel>> getCrewMembers({String? search});

  /// POST /crew-members — adds a person, or returns the existing match by name
  Future<CrewMemberModel> createCrewMember(String name);
}

/// Implementation using Dio HTTP client
class CrewMemberRemoteDataSourceImpl implements CrewMemberRemoteDataSource {
  final Dio _dio;

  CrewMemberRemoteDataSourceImpl({Dio? dio})
    : _dio = dio ?? InjectorApp.resolve<Dio>();

  @override
  Future<List<CrewMemberModel>> getCrewMembers({String? search}) async {
    final response = await _dio.get(
      '/crew-members',
      queryParameters:
          (search != null && search.isNotEmpty) ? {'search': search} : null,
    );
    final data = response.data;

    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => CrewMemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  @override
  Future<CrewMemberModel> createCrewMember(String name) async {
    final response = await _dio.post('/crew-members', data: {'name': name});
    final data = response.data;

    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return CrewMemberModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    throw Exception('Unexpected response format');
  }
}
