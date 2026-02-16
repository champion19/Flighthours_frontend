import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/usecases/list_crew_member_types_use_case.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_event.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_state.dart';

/// BLoC for managing crew member type state
class CrewMemberTypeBloc
    extends Bloc<CrewMemberTypeEvent, CrewMemberTypeState> {
  final ListCrewMemberTypesUseCase _listCrewMemberTypesUseCase;

  CrewMemberTypeBloc({ListCrewMemberTypesUseCase? listCrewMemberTypesUseCase})
    : _listCrewMemberTypesUseCase =
          listCrewMemberTypesUseCase ??
          InjectorApp.resolve<ListCrewMemberTypesUseCase>(),
      super(const CrewMemberTypeInitial()) {
    on<FetchCrewMemberTypes>(_onFetchCrewMemberTypes);
  }

  Future<void> _onFetchCrewMemberTypes(
    FetchCrewMemberTypes event,
    Emitter<CrewMemberTypeState> emit,
  ) async {
    emit(const CrewMemberTypeLoading());

    final result = await _listCrewMemberTypesUseCase.call(event.role);
    result.fold(
      (failure) => emit(
        CrewMemberTypeError(
          'Failed to load crew member types: ${failure.message}',
        ),
      ),
      (types) => emit(CrewMemberTypesLoaded(types)),
    );
  }
}
