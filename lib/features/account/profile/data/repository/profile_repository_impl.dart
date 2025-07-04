import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/network/connection_checker.dart';
import 'package:panna_app/features/account/profile/data/datasource/profile_sql_database.dart/sql_profile_database.dart';
import 'package:panna_app/features/account/profile/data/datasource/profile_remote_data_source.dart';
import 'package:panna_app/features/account/profile/domain/repository/profile_repository.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final SQLProfileDataSource profileLocalDataSource;
  final ConnectionChecker connectionChecker;

  ProfileRepositoryImpl(
    this.profileRemoteDataSource,
    this.profileLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, UserProfileDTO>> getProfile() async {
    try {
      final isConnected = await connectionChecker.isConnected;

      if (!isConnected) {
        // Replace 'user_id' with the actual user ID logic here
        final localProfile = await profileLocalDataSource.fetchProfile();
        if (localProfile != null) {
          return Right(localProfile);
        } else {
          return Left(Failure('No profile found in local storage'));
        }
      }

      // Otherwise, fetch from remote and cache the result locally
      final remoteProfile = await profileRemoteDataSource.getProfile();
      await profileLocalDataSource
          .insertProfile(remoteProfile); // Cache the profile locally
      return Right(remoteProfile);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(UserProfileDTO profile) async {
    try {
      final isConnected = await connectionChecker.isConnected;

      // If online, update the remote profile and sync with local storage
      await profileRemoteDataSource.updateProfile(profile);
      await profileLocalDataSource
          .insertProfile(profile); // Cache updated profile locally
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(File image) async {
    try {
      // Ensure the user is connected before attempting avatar upload
      final isConnected = await connectionChecker.isConnected;

      if (!isConnected) {
        return Left(
            Failure('No internet connection. Unable to upload avatar.'));
      }

      final avatarUrl = await profileRemoteDataSource.uploadAvatar(image);
      return Right(avatarUrl);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
