import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:panna_app/core/utils/pick_image.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/auth/domain/use_case/user_signup_extra_details_usecase.dart';

part 'signup_extra_details_state.dart';

@injectable
class SignupExtraDetailsCubit extends Cubit<SignupExtraDetailsState> {
  SignupExtraDetailsCubit(
      this._signUpExtraDetailsUseCase, this._imageUploadService)
      //  this.profileRepository
      : super(SignupExtraDetailsState());

  // final SupabaseProfileRepository profileRepository;
  final SignUpExtraDetailsUseCase _signUpExtraDetailsUseCase;
  final ImageUploadService _imageUploadService; // Add the service

  void updateFirstName(String value) {
    emit(state.copyWith(firstName: value));
  }

  void updateSurname(String value) {
    emit(state.copyWith(surname: value));
  }

  void updateDateOfBirth(DateTime value) {
    emit(state.copyWith(dateOfBirth: value));
  }

  void updateUsername(String value) {
    emit(state.copyWith(username: value));
  }

  void updateTeamSupported(String value) {
    emit(state.copyWith(teamSupported: value));
  }

  void updateBio(String value) {
    emit(state.copyWith(bio: value));
  }

  Future<void> selectImage() async {
    try {
      final pickedImage = await _imageUploadService.pickImage();
      if (pickedImage != null) {
        final imageUrl =
            await _imageUploadService.uploadProfileImage(pickedImage);
        if (imageUrl != null) {
          emit(state.copyWith(image: pickedImage, avatarUrl: imageUrl));
        } else {
          throw Exception('Failed to upload image');
        }
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: 'Failed to select image: $error'));
    }
  }

  // The rest of your methods remain the same...

//     void selectImage() async {
//   final pickedImage = await pickImage();
//   if (pickedImage != null) {
//     final imageUrl = await _profileRepository.uploadAvatar(pickedImage);
//     emit(state.copyWith(image: pickedImage, avatarUrl: imageUrl));
//   }
// }
//   }

  void moveToStep(int step) {
    emit(state.copyWith(signUpExtraDetailsStep: step));
  }

  void submitFinalDetails() async {
    // Log the details for debugging
    

    // Create a UserProfile entity using the state data
    final userProfile = UserProfileDTO(
      firstName: state.firstName,
      lastName: state.surname,
      dateOfBirth: state.dateOfBirth,
      username: state.username,
      teamSupported: state.teamSupported,
      bio: state.bio,
      avatarUrl: state.avatarUrl,
    );

    // Pass the UserProfile to the repository for submission
    try {
      await _signUpExtraDetailsUseCase
          .execute(SignUpExtraDetailsParams(userProfile: userProfile));

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }
}
