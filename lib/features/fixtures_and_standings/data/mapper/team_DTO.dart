import 'package:equatable/equatable.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/team_entity.dart';

class TeamDTO extends Equatable {
  final String? teamId;
  final String? teamName;

  const TeamDTO({
    this.teamId,
    this.teamName,
  });

  factory TeamDTO.fromJson(Map<String, dynamic> json) {
    return TeamDTO(
      teamId: json['team_id'] as String?,
      teamName: json['team_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'team_name': teamName,
    };
  }

  TeamEntity toEntity() {
    return TeamEntity(
      teamId: teamId,
      teamName: teamName,
    );
  }

  factory TeamDTO.fromEntity(TeamEntity entity) {
    return TeamDTO(
      teamId: entity.teamId,
      teamName: entity.teamName,
    );
  }

  @override
  List<Object?> get props => [teamId, teamName];
}
