import 'package:equatable/equatable.dart';

class ArticleLikeEntity extends Equatable {
  final String id;
  final String username;
  final String articleId;
  final String profileId;
  final DateTime? likedAt;

  const ArticleLikeEntity({
    required this.id,
    required this.username,
    required this.articleId,
    required this.profileId,
    this.likedAt,
  });

  @override
  List<Object?> get props => [id, username, articleId, profileId, likedAt];
}
