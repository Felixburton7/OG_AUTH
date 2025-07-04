import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/settings/domain/repository/user_repository.dart';

@injectable
class ChangeEmailAddressUseCase
    extends UseCase<void, ChangeEmailAddressUseCaseParams> {
  ChangeEmailAddressUseCase(
    this._userRepository,
  );

  final UserRepository _userRepository;

  @override
  Future<Either<Failure, void>> execute(
      ChangeEmailAddressUseCaseParams params) async {
    try {
      await _userRepository.changeEmailAddress(params.email);
      return const Right(null); // Returning success with void
    } catch (error) {
      return Left(Failure()); // Return appropriate failure
    }
  }
}

class ChangeEmailAddressUseCaseParams {
  ChangeEmailAddressUseCaseParams({
    required this.email,
  });

  final String email;
}
