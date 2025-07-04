import 'package:equatable/equatable.dart';

// From supabase.
class AuthUserEntity extends Equatable {
  const AuthUserEntity({
    required this.id,
    required this.email,
  });

  final String id, email;

  @override
  List<Object?> get props => [
        id,
        email,
      ];
}
