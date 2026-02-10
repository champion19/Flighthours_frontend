import 'package:flight_hours_app/features/license_plate/data/datasources/license_plate_remote_data_source.dart';
import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';
import 'package:flight_hours_app/features/license_plate/domain/repositories/license_plate_repository.dart';

/// Implementation of [LicensePlateRepository]
///
/// Delegates to [LicensePlateRemoteDataSource] for API calls
class LicensePlateRepositoryImpl implements LicensePlateRepository {
  final LicensePlateRemoteDataSource _remoteDataSource;

  LicensePlateRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<LicensePlateEntity>> listLicensePlates() {
    return _remoteDataSource.listLicensePlates();
  }

  @override
  Future<LicensePlateEntity> getLicensePlateByPlate(String plate) {
    return _remoteDataSource.getLicensePlateByPlate(plate);
  }
}
