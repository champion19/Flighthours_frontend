import 'package:dio/dio.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/crew_member_type/data/models/crew_member_type_model.dart';

/// Interface for crew member type remote data source
abstract class CrewMemberTypeRemoteDataSource {
  /// Fetch crew member types by role from GET /crew-member-types/:role
  Future<List<CrewMemberTypeModel>> getCrewMemberTypes(String role);
}

/// Implementation using Dio HTTP client
class CrewMemberTypeRemoteDataSourceImpl
    implements CrewMemberTypeRemoteDataSource {
  final Dio _dio;

  CrewMemberTypeRemoteDataSourceImpl({Dio? dio})
    : _dio = dio ?? InjectorApp.resolve<Dio>();

  @override
  Future<List<CrewMemberTypeModel>> getCrewMemberTypes(String role) async {
    final response = await _dio.get('/crew-member-types/$role');
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // Handle: { success: true, data: { crew_member_types: [...] } }
      if (data.containsKey('data')) {
        final innerData = data['data'];
        if (innerData is Map<String, dynamic> &&
            innerData.containsKey('crew_member_types')) {
          final types = innerData['crew_member_types'];
          if (types is List) {
            return types
                .map(
                  (e) =>
                      CrewMemberTypeModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          }
        }
        // Direct data array
        if (innerData is List) {
          return innerData
              .map(
                (e) => CrewMemberTypeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      }
    }

    // Direct array response
    if (data is List) {
      return data
          .map((e) => CrewMemberTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
