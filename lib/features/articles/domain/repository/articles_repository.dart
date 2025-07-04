import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import '../entities/article_detail_entity.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<ArticleDetailEntity>>> fetchAllArticles();

  Future<Either<Failure, void>> userLikeArticle({required String articleId});

  Future<Either<Failure, void>> userUnlikeArticle({required String articleId});

  /// Inserts an upvote for the specified player.
  Future<Either<Failure, void>> userUpvotePlayer({required String playerId});

  /// Inserts a downvote for the specified player.
  Future<Either<Failure, void>> userDownvotePlayer({required String playerId});

  Future<Either<Failure, void>> userRemoveVote({
    required String playerId,
    required bool isUpvote,
  });
}
