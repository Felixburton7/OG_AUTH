import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/account/profile/domain/repository/profile_repository.dart';

@injectable
class SignUpExtraDetailsUseCase
    extends UseCase<void, SignUpExtraDetailsParams> {
  SignUpExtraDetailsUseCase(this._profileRepository);

  final ProfileRepository _profileRepository;

  @override
  Future<Either<Failure, void>> execute(SignUpExtraDetailsParams params) async {
    try {
      await _profileRepository.updateProfile(params.userProfile);
      return const Right(null); // Return success
    } catch (e) {
      return Left(Failure()); // Handle the failure
    }
  }

  Future<Either<Failure, String>> updateImage(UploadImageParams params) async {
    final imageUrl = await _profileRepository.uploadAvatar(params.image);
    return (imageUrl); // Return the uploaded image URL as success
  }
}

class SignUpExtraDetailsParams extends Equatable {
  const SignUpExtraDetailsParams({
    required this.userProfile,
  });

  final UserProfileDTO userProfile;

  @override
  List<Object?> get props => [userProfile];
}

class UploadImageParams {
  final File image;

  UploadImageParams({
    required this.image,
  });
}
