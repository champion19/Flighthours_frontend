import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';
import 'package:flight_hours_app/features/crew_member/domain/usecases/create_crew_member_use_case.dart';
import 'package:flight_hours_app/features/crew_member/domain/usecases/search_crew_members_use_case.dart';
import 'package:flight_hours_app/features/crew_member/presentation/bloc/crew_member_event.dart';
import 'package:flight_hours_app/features/crew_member/presentation/bloc/crew_member_state.dart';

/// BLoC for the authenticated pilot's own crew roster (Tripulación de Mando + cabin crew)
class CrewMemberBloc extends Bloc<CrewMemberEvent, CrewMemberState> {
  final SearchCrewMembersUseCase _searchCrewMembersUseCase;
  final CreateCrewMemberUseCase _createCrewMemberUseCase;

  List<CrewMemberEntity> _cachedMembers = [];

  CrewMemberBloc({
    SearchCrewMembersUseCase? searchCrewMembersUseCase,
    CreateCrewMemberUseCase? createCrewMemberUseCase,
  }) : _searchCrewMembersUseCase =
           searchCrewMembersUseCase ??
           InjectorApp.resolve<SearchCrewMembersUseCase>(),
       _createCrewMemberUseCase =
           createCrewMemberUseCase ??
           InjectorApp.resolve<CreateCrewMemberUseCase>(),
       super(const CrewMemberInitial()) {
    on<FetchCrewMembers>(_onFetchCrewMembers);
    on<CreateCrewMember>(_onCreateCrewMember);
  }

  Future<void> _onFetchCrewMembers(
    FetchCrewMembers event,
    Emitter<CrewMemberState> emit,
  ) async {
    emit(const CrewMemberLoading());

    final result = await _searchCrewMembersUseCase.call(search: event.search);
    result.fold(
      (failure) =>
          emit(CrewMemberError('Failed to load crew roster: ${failure.message}')),
      (members) {
        _cachedMembers = members;
        emit(CrewMembersLoaded(members));
      },
    );
  }

  Future<void> _onCreateCrewMember(
    CreateCrewMember event,
    Emitter<CrewMemberState> emit,
  ) async {
    emit(const CrewMemberLoading());

    final result = await _createCrewMemberUseCase.call(event.name);
    result.fold(
      (failure) =>
          emit(CrewMemberError('Failed to add crew member: ${failure.message}')),
      (member) {
        final alreadyKnown = _cachedMembers.any((m) => m.id == member.id);
        if (!alreadyKnown) {
          _cachedMembers = [..._cachedMembers, member];
        }
        emit(CrewMemberCreated(member, _cachedMembers));
      },
    );
  }
}
