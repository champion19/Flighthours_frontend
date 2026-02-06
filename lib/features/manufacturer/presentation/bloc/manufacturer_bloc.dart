import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/features/manufacturer/data/datasources/manufacturer_remote_data_source.dart';
import 'package:flight_hours_app/features/manufacturer/data/repositories/manufacturer_repository_impl.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturers.dart';
import 'package:flight_hours_app/features/manufacturer/domain/usecases/get_manufacturer_by_id.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_event.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_state.dart';

class ManufacturerBloc extends Bloc<ManufacturerEvent, ManufacturerState> {
  final GetManufacturers _getManufacturers;
  final GetManufacturerById _getManufacturerById;

  ManufacturerBloc({
    GetManufacturers? getManufacturers,
    GetManufacturerById? getManufacturerById,
  }) : _getManufacturers = getManufacturers ?? _createDefaultGetManufacturers(),
       _getManufacturerById =
           getManufacturerById ?? _createDefaultGetManufacturerById(),
       super(ManufacturerInitial()) {
    on<FetchManufacturers>(_onFetchManufacturers);
    on<GetManufacturerDetail>(_onGetManufacturerDetail);
  }

  static GetManufacturers _createDefaultGetManufacturers() {
    final dataSource = ManufacturerRemoteDataSourceImpl();
    final repository = ManufacturerRepositoryImpl(remoteDataSource: dataSource);
    return GetManufacturers(repository);
  }

  static GetManufacturerById _createDefaultGetManufacturerById() {
    final dataSource = ManufacturerRemoteDataSourceImpl();
    final repository = ManufacturerRepositoryImpl(remoteDataSource: dataSource);
    return GetManufacturerById(repository);
  }

  Future<void> _onFetchManufacturers(
    FetchManufacturers event,
    Emitter<ManufacturerState> emit,
  ) async {
    emit(ManufacturerLoading());
    try {
      final manufacturers = await _getManufacturers();
      emit(ManufacturerSuccess(manufacturers: manufacturers));
    } catch (e) {
      emit(
        ManufacturerError(
          message: 'Failed to load manufacturers: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGetManufacturerDetail(
    GetManufacturerDetail event,
    Emitter<ManufacturerState> emit,
  ) async {
    emit(ManufacturerLoading());
    try {
      final manufacturer = await _getManufacturerById(event.manufacturerId);
      if (manufacturer != null) {
        emit(ManufacturerDetailSuccess(manufacturer: manufacturer));
      } else {
        emit(const ManufacturerError(message: 'Manufacturer not found'));
      }
    } catch (e) {
      emit(
        ManufacturerError(
          message: 'Failed to load manufacturer: ${e.toString()}',
        ),
      );
    }
  }
}
