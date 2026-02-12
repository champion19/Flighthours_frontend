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

    final result = await _getManufacturers();
    result.fold(
      (failure) => emit(ManufacturerError(message: failure.message)),
      (manufacturers) =>
          emit(ManufacturerSuccess(manufacturers: manufacturers)),
    );
  }

  Future<void> _onGetManufacturerDetail(
    GetManufacturerDetail event,
    Emitter<ManufacturerState> emit,
  ) async {
    emit(ManufacturerLoading());

    final result = await _getManufacturerById(event.manufacturerId);
    result.fold(
      (failure) => emit(ManufacturerError(message: failure.message)),
      (manufacturer) =>
          emit(ManufacturerDetailSuccess(manufacturer: manufacturer)),
    );
  }
}
