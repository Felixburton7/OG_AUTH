part of 'profile_information_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileDTO profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {
  final UserProfileDTO profile;

  const ProfileUpdated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileAvatarUpdating extends ProfileState {
  final UserProfileDTO profile;

  const ProfileAvatarUpdating(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileAvatarUpdated extends ProfileState {
  final UserProfileDTO profile;

  const ProfileAvatarUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
