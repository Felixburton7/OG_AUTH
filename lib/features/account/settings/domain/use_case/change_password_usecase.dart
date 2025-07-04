import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart';

@injectable
class ResetPasswordUseCase extends UseCase<void, ResetPasswordUseCaseParams> {
  ResetPasswordUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<Failure, void>> execute(
      ResetPasswordUseCaseParams params) async {
    try {
      await _userRepository.resetPassword(params.email);
      return const Right(null);
    } catch (error) {
      return Left(Failure());
    }
  }
}

class ResetPasswordUseCaseParams {
  ResetPasswordUseCaseParams({required this.email});

  final String email;
}
