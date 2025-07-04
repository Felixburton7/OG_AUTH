import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? profileId;
  final DateTime? updatedAt;
  final DateTime? dateOfBirth;
  final String? username;
  final String? avatarUrl;
  final String? teamSupported;
  final double accountBalance;
  final String? firstName;
  final String? lastName;
  final double? lmsAverage;
  final String? bio;

  const UserProfileEntity({
    this.profileId,
    this.updatedAt,
    this.dateOfBirth,
    this.username,
    this.avatarUrl,
    this.teamSupported,
    this.accountBalance = 0.0,
    this.firstName,
    this.lastName,
    this.lmsAverage,
    this.bio,
  });

  @override
  List<Object?> get props => [
        profileId,
        updatedAt,
        dateOfBirth,
        username,
        avatarUrl,
        teamSupported,
        accountBalance,
        firstName,
        lastName,
        lmsAverage,
        bio,
      ];
}
