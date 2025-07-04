import 'package:panna_app/features/articles/data/mapper/article_comment_dto.dart';
import 'package:panna_app/features/articles/data/mapper/article_dto.dart';
import 'package:panna_app/features/articles/data/mapper/article_like_dto.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';

/// DTO for aggregating article details (article, comments, likes)
class ArticleDetailDTO {
  final ArticleDTO article;
  final List<ArticleCommentDTO> comments;
  final List<ArticleLikeDTO> likes;

  ArticleDetailDTO({
    required this.article,
    required this.comments,
    required this.likes,
  });

  factory ArticleDetailDTO.fromJson(Map<String, dynamic> json) {
    return ArticleDetailDTO(
      // If your API nests article data under an 'article' key,
      // change the following line to:
      // article: ArticleDTO.fromJson(json['article']),
      article: ArticleDTO.fromJson(json),
      comments: (json['article_comments'] as List<dynamic>? ?? [])
          .map((c) => ArticleCommentDTO.fromJson(c))
          .toList(),
      likes: (json['article_likes'] as List<dynamic>? ?? [])
          .map((l) => ArticleLikeDTO.fromJson(l))
          .toList(),
    );
  }

  ArticleDetailEntity toEntity() {
    return ArticleDetailEntity(
      article: article.toEntity(),
      comments: comments.map((c) => c.toEntity()).toList(),
      likes: likes.map((l) => l.toEntity()).toList(),
    );
  }
}
