import 'package:equatable/equatable.dart';

class ArticleCommentEntity extends Equatable {
  final String commentId;
  final String articleId;
  final String username;
  final String? profileId;
  final DateTime? createdAt;
  final String content;

  const ArticleCommentEntity({
    required this.commentId,
    required this.articleId,
    required this.username,
    this.profileId,
    this.createdAt,
    required this.content,
  });

  @override
  List<Object?> get props =>
      [commentId, articleId, username, profileId, createdAt, content];
}
