import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';

abstract class ProfileRepository {
  /// Fetch the profile data for the user.
  /// Returns [UserProfileDTO] on success or [Failure] on error.
  Future<Either<Failure, UserProfileDTO>> getProfile();  /// Update the profile with new data.
  /// Takes [UserProfileDTO] and updates it in the data source.
  /// Returns [void] on success or [Failure] on error.
  Future<Either<Failure, void>> updateProfile(UserProfileDTO profile);

  /// Upload the avatar image for the user.
  /// Takes [File] and uploads it, returning the URL of the uploaded avatar.
  /// Returns [String] (URL) on success or [Failure] on error.
  Future<Either<Failure, String>> uploadAvatar(File image);
}
