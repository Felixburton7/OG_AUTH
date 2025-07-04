import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/settings/domain/exception/update_password_exception.dart';
import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart';

@injectable
class UpdatePasswordUseCase extends UseCase<void, UpdatePasswordUseCaseParams> {
  UpdatePasswordUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<Failure, void>> execute(
      UpdatePasswordUseCaseParams params) async {
    try {
      await _userRepository.updatePassword(params.password);
      return const Right(null);
    } on UpdatePasswordException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('An unknown error occurred.'));
    }
  }
}

class UpdatePasswordUseCaseParams {
  UpdatePasswordUseCaseParams({required this.password});

  final String password;
}
