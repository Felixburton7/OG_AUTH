import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/utils/pick_image.dart';
import 'package:panna_app/features/account/profile/domain/usecases/get_profile_usecase.dart';
import 'package:panna_app/features/account/profile/domain/usecases/update_profile_usecase.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';

part 'profile_information_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ImageUploadService _imageUploadService;

  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase,
      this._imageUploadService)
      : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await _getProfileUseCase.execute(NoParams());

    result.fold(
      (failure) {
        emit(ProfileError(_mapFailureToMessage(failure)));
      },
      (profile) {
        emit(ProfileLoaded(profile));
      },
    );
  }

  void clearProfile() {
    if (state is! ProfileInitial) {
      emit(ProfileInitial());
    }
  }

  Future<void> updateProfile(UserProfileDTO profile) async {
    emit(ProfileUpdating());
    final result = await _updateProfileUseCase.execute(profile);

    result.fold(
      (failure) {
        emit(ProfileError(_mapFailureToMessage(failure)));
      },
      (_) async {
        // Fetch the updated profile
        final fetchResult = await _getProfileUseCase.execute(NoParams());
        fetchResult.fold(
          (failure) {
            emit(ProfileError(_mapFailureToMessage(failure)));
          },
          (updatedProfile) {
            emit(ProfileUpdated(profile: updatedProfile));
          },
        );
      },
    );
  }

  Future<void> selectImage() async {
    try {
      if (state is ProfileLoaded || state is ProfileAvatarUpdated) {
        emit(ProfileAvatarUpdating((state as ProfileLoaded).profile));
      }

      final pickedImage = await _imageUploadService.pickImage();
      if (pickedImage != null) {
        final imageUrl =
            await _imageUploadService.uploadProfileImage(pickedImage);
        if (imageUrl != null) {
          if (state is ProfileAvatarUpdating) {
            final updatedProfile =
                (state as ProfileAvatarUpdating).profile.copyWith(
                      avatarUrl: imageUrl,
                    );

            await updateProfile(updatedProfile);

            emit(ProfileLoaded(updatedProfile));
          }
        } else {
          throw Exception('Failed to upload image');
        }
      }
    } catch (error) {
      emit(ProfileError('Failed to select image: $error'));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    return 'Server Failure';
  }
}
