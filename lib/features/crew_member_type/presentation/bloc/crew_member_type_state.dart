import 'package:equatable/equatable.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';

/// States for crew member type BLoC
abstract class CrewMemberTypeState extends Equatable {
  const CrewMemberTypeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class CrewMemberTypeInitial extends CrewMemberTypeState {
  const CrewMemberTypeInitial();
}

/// Loading state while fetching data
class CrewMemberTypeLoading extends CrewMemberTypeState {
  const CrewMemberTypeLoading();
}

/// State when crew member types are successfully loaded
class CrewMemberTypesLoaded extends CrewMemberTypeState {
  final List<CrewMemberTypeEntity> types;

  const CrewMemberTypesLoaded(this.types);

  @override
  List<Object?> get props => [types];
}

/// Error state
class CrewMemberTypeError extends CrewMemberTypeState {
  final String message;

  const CrewMemberTypeError(this.message);

  @override
  List<Object?> get props => [message];
}
