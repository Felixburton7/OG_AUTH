import 'package:panna_app/features/articles/domain/entities/article_comment.dart';
import 'package:panna_app/features/articles/domain/entities/article_entity.dart';
import 'package:panna_app/features/articles/domain/entities/article_like.dart';

class ArticleDetailEntity {
  final ArticleEntity article;
  final List<ArticleCommentEntity> comments;
  final List<ArticleLikeEntity> likes;

  ArticleDetailEntity({
    required this.article,
    required this.comments,
    required this.likes,
  });
}
