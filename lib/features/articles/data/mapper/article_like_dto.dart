import 'package:equatable/equatable.dart';
import 'package:panna_app/features/articles/domain/entities/article_like.dart';

class ArticleLikeDTO extends Equatable {
  final String id;
  final String username;
  final String articleId;
  final String profileId;
  final DateTime? likedAt;

  const ArticleLikeDTO({
    required this.id,
    required this.username,
    required this.articleId,
    required this.profileId,
    this.likedAt,
  });

  factory ArticleLikeDTO.fromJson(Map<String, dynamic> json) {
    return ArticleLikeDTO(
      id: json['id'] as String,
      username: json['username'] as String,
      articleId: json['article_id'] as String,
      profileId: json['profile_id'] as String,
      likedAt:
          json['liked_at'] != null ? DateTime.parse(json['liked_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'article_id': articleId,
      'profile_id': profileId,
      'liked_at': likedAt?.toIso8601String(),
    };
  }

  ArticleLikeEntity toEntity() {
    return ArticleLikeEntity(
      id: id,
      username: username,
      articleId: articleId,
      profileId: profileId,
      likedAt: likedAt,
    );
  }

  factory ArticleLikeDTO.fromEntity(ArticleLikeEntity entity) {
    return ArticleLikeDTO(
      id: entity.id,
      username: entity.username,
      articleId: entity.articleId,
      profileId: entity.profileId,
      likedAt: entity.likedAt,
    );
  }

  @override
  List<Object?> get props => [id, username, articleId, profileId, likedAt];
}
