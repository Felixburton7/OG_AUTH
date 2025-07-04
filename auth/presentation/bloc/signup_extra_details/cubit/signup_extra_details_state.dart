part of 'signup_extra_details_cubit.dart';

@immutable
class SignupExtraDetailsState extends Equatable {
  final String firstName;
  final String surname;
  final DateTime dateOfBirth;
  final String username;
  final String teamSupported;
  final String bio;
  final int signUpExtraDetailsStep;
  final String? avatarUrl;
  final File? image;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  SignupExtraDetailsState(
      {this.firstName = '',
      this.surname = '',
      DateTime? dateOfBirth,
      this.username = '',
      this.teamSupported = '',
      this.bio = '',
      this.avatarUrl,
      this.image,
      this.signUpExtraDetailsStep = 1,
      this.status = FormzSubmissionStatus.initial,
      this.errorMessage})
      : dateOfBirth =
            dateOfBirth ?? DateTime(2000, 1, 1); // Default date of birth

  SignupExtraDetailsState copyWith({
    String? firstName,
    String? surname,
    DateTime? dateOfBirth,
    String? username,
    String? teamSupported,
    String? bio,
    String? avatarUrl,
    File? image,
    int? signUpExtraDetailsStep,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return SignupExtraDetailsState(
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      username: username ?? this.username,
      teamSupported: teamSupported ?? this.teamSupported,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      signUpExtraDetailsStep:
          signUpExtraDetailsStep ?? this.signUpExtraDetailsStep,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        surname,
        dateOfBirth,
        username,
        teamSupported,
        bio,
        avatarUrl,
        signUpExtraDetailsStep,
        status,
        errorMessage,
      ];
}
