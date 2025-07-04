import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/account/profile/domain/repository/profile_repository.dart';

@injectable
class GetProfileUseCase extends UseCase<UserProfileDTO, NoParams> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileDTO>> execute(NoParams params) async {
    final profile = await _repository.getProfile();
    return profile;
  }
}
