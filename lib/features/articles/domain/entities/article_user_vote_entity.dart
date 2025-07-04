import 'package:equatable/equatable.dart';

class UserVoteEntity extends Equatable {
  final String voteId;
  final String playerId;
  final String profileId;
  final bool upvote;
  final bool downvote;
  final DateTime? createdAt;

  const UserVoteEntity({
    required this.voteId,
    required this.playerId,
    required this.profileId,
    required this.upvote,
    required this.downvote,
    this.createdAt,
  });

  @override
  List<Object?> get props =>
      [voteId, playerId, profileId, upvote, downvote, createdAt];
}
