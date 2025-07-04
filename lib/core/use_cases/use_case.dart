import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';

// Base class for asynchronous use cases
abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> execute(Params params);
}

// Base class for use cases that return a stream
abstract class StreamUseCase<SuccessType, Params> {
  Stream<SuccessType> execute(Params params);
}

// Base class for synchronous use cases
abstract class SyncUseCase<SuccessType, Params> {
  Either<Failure, SuccessType> execute(Params params);
}
