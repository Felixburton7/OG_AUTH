import 'package:equatable/equatable.dart';
import 'package:panna_app/features/articles/domain/entities/article_user_vote_entity.dart';

class UserVoteDTO extends Equatable {
  final String voteId;
  final String playerId;
  final String profileId;
  final bool upvote;
  final bool downvote;
  final DateTime? createdAt;

  const UserVoteDTO({
    required this.voteId,
    required this.playerId,
    required this.profileId,
    required this.upvote,
    required this.downvote,
    this.createdAt,
  });

  factory UserVoteDTO.fromJson(Map<String, dynamic> json) {
    return UserVoteDTO(
      voteId: json['vote_id'] as String,
      playerId: json['player_id'] as String,
      profileId: json['profile_id'] as String,
      upvote: json['upvote'] as bool,
      downvote: json['downvote'] as bool,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vote_id': voteId,
      'player_id': playerId,
      'profile_id': profileId,
      'upvote': upvote,
      'downvote': downvote,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserVoteEntity toEntity() {
    return UserVoteEntity(
      voteId: voteId,
      playerId: playerId,
      profileId: profileId,
      upvote: upvote,
      downvote: downvote,
      createdAt: createdAt,
    );
  }

  factory UserVoteDTO.fromEntity(UserVoteEntity entity) {
    return UserVoteDTO(
      voteId: entity.voteId,
      playerId: entity.playerId,
      profileId: entity.profileId,
      upvote: entity.upvote,
      downvote: entity.downvote,
      createdAt: entity.createdAt,
    );
  }

  @override
  List<Object?> get props =>
      [voteId, playerId, profileId, upvote, downvote, createdAt];
}
