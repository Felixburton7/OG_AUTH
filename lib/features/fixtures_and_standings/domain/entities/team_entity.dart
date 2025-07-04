import 'package:equatable/equatable.dart';

class TeamEntity extends Equatable {
  final String? teamId;
  final String? teamName;

  const TeamEntity({
    this.teamId,
    this.teamName,
  });

  @override
  List<Object?> get props => [teamId, teamName];
}
