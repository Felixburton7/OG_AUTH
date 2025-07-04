import 'package:injectable/injectable.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';

@Injectable(as: UserProfileEntity)
class UserProfileDTO extends UserProfileEntity {
  const UserProfileDTO({
    String? profileId,
    DateTime? updatedAt,
    DateTime? dateOfBirth,
    String? username,
    String? avatarUrl,
    String? teamSupported,
    double accountBalance = 0.0,
    String? firstName,
    String? lastName,
    double? lmsAverage,
    String? bio,
  }) : super(
          profileId: profileId,
          updatedAt: updatedAt,
          dateOfBirth: dateOfBirth,
          username: username,
          avatarUrl: avatarUrl,
          teamSupported: teamSupported,
          accountBalance: accountBalance,
          firstName: firstName,
          lastName: lastName,
          lmsAverage: lmsAverage,
          bio: bio,
        );

  factory UserProfileDTO.fromJson(Map<String, dynamic> json) {
    return UserProfileDTO(
      profileId: json['profile_id'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : DateTime(2000, 1, 1), // Default value if null
      username: json['username'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      teamSupported: json['team_supported'] ?? 'MANU',
      accountBalance: _toDouble(json['account_balance']),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      lmsAverage: _toDouble(json['lms_average']),
      bio: json['bio'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      throw FormatException('Cannot convert $value to double');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      // 'profile_id': profileId,
      'updated_at': updatedAt?.toIso8601String(),
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'username': username,
      'avatar_url': avatarUrl,
      'team_supported': teamSupported,
      'account_balance': accountBalance,
      'first_name': firstName,
      'last_name': lastName,
      'lms_average': lmsAverage,
      'bio': bio,
    };
  }

  UserProfileDTO copyWith({
    String? profileId,
    DateTime? updatedAt,
    DateTime? dateOfBirth,
    String? username,
    String? avatarUrl,
    String? teamSupported,
    double? accountBalance,
    String? firstName,
    String? lastName,
    double? lmsAverage,
    String? bio,
  }) {
    return UserProfileDTO(
      profileId: profileId ?? this.profileId,
      updatedAt: updatedAt ?? this.updatedAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      teamSupported: teamSupported ?? this.teamSupported,
      accountBalance: accountBalance ?? this.accountBalance,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      lmsAverage: lmsAverage ?? this.lmsAverage,
      bio: bio ?? this.bio,
    );
  }
}
