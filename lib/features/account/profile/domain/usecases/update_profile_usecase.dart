import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/profile/domain/repository/profile_repository.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';

@injectable
class UpdateProfileUseCase extends UseCase<void, UserProfileDTO> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, void>> execute(UserProfileDTO profile) async {
    try {
      await _repository.updateProfile(profile);
      return const Right(null); // Returning Right with void as success
    } catch (error) {
      return Left(Failure()); // Handle any errors with a Failure type
    }
  }
}
