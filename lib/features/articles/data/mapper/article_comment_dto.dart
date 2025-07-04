import 'package:equatable/equatable.dart';
import 'package:panna_app/features/articles/domain/entities/article_comment.dart';

class ArticleCommentDTO extends Equatable {
  final String commentId;
  final String articleId;
  final String username;
  final String? profileId;
  final DateTime? createdAt;
  final String content;

  const ArticleCommentDTO({
    required this.commentId,
    required this.articleId,
    required this.username,
    this.profileId,
    this.createdAt,
    required this.content,
  });

  factory ArticleCommentDTO.fromJson(Map<String, dynamic> json) {
    return ArticleCommentDTO(
      commentId: json['comment_id'] as String,
      articleId: json['article_id'] as String,
      username: json['username'] as String,
      profileId: json['profile_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'article_id': articleId,
      'username': username,
      'profile_id': profileId,
      'created_at': createdAt?.toIso8601String(),
      'content': content,
    };
  }

  ArticleCommentEntity toEntity() {
    return ArticleCommentEntity(
      commentId: commentId,
      articleId: articleId,
      username: username,
      profileId: profileId,
      createdAt: createdAt,
      content: content,
    );
  }

  factory ArticleCommentDTO.fromEntity(ArticleCommentEntity entity) {
    return ArticleCommentDTO(
      commentId: entity.commentId,
      articleId: entity.articleId,
      username: entity.username,
      profileId: entity.profileId,
      createdAt: entity.createdAt,
      content: entity.content,
    );
  }

  @override
  List<Object?> get props =>
      [commentId, articleId, username, profileId, createdAt, content];
}
