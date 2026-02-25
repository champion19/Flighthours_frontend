import 'package:dartz/dartz.dart';
import 'package:flight_hours_app/core/error/failure.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';

/// Repository interface for Tail Number operations
abstract class TailNumberRepository {
  Future<Either<Failure, List<TailNumberEntity>>> listTailNumbers();
  Future<Either<Failure, TailNumberEntity>> getTailNumberByPlate(String plate);
}
