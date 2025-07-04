import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/articles/data/datasource/articles_local_datasource.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';
import 'package:panna_app/features/articles/domain/repository/articles_repository.dart';
import '../datasource/articles_remote_data_source.dart';

@Injectable(as: ArticlesRepository)
class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSource remoteDataSource;
  final ArticlesLocalDataSource localDataSource;

  ArticlesRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, List<ArticleDetailEntity>>> fetchAllArticles() async {
    try {
      final articles = await remoteDataSource.fetchAllArticlesDetail();

      if (articles.isNotEmpty) {
        // Cache the remote data locally.
        await localDataSource.cacheArticles(articles);
        return Right(articles);
      } else {
        // Fallback: return cached articles if available.
        final cachedArticles = await localDataSource.getLastArticles();
        if (cachedArticles.isNotEmpty) {
          return Right(cachedArticles);
        } else {
          return Left(Failure("No articles found."));
        }
      }
    } catch (e) {
      // On error, try to load cached articles.
      final cachedArticles = await localDataSource.getLastArticles();
      if (cachedArticles.isNotEmpty) {
        return Right(cachedArticles);
      } else {
        return Left(Failure("Failed to fetch articles: $e"));
      }
    }
  }

  @override
  Future<Either<Failure, void>> userLikeArticle({
    required String articleId,
  }) async {
    try {
      await remoteDataSource.userLikeArticle(
        articleId: articleId,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to like article: $e"));
    }
  }

  // UNLIKE

  // NEW: Unlike
  @override
  Future<Either<Failure, void>> userUnlikeArticle({
    required String articleId,
  }) async {
    try {
      await remoteDataSource.userUnlikeArticle(
        articleId: articleId,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to unlike article: $e"));
    }
  }

  // NEW: Upvote a player.
  @override
  Future<Either<Failure, void>> userUpvotePlayer({
    required String playerId,
  }) async {
    try {
      await remoteDataSource.userUpvotePlayer(playerId: playerId);
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to upvote player: $e"));
    }
  }

  // NEW:Remove a vote (upvote or downvote) for a player.
  @override
  Future<Either<Failure, void>> userDownvotePlayer({
    required String playerId,
  }) async {
    try {
      await remoteDataSource.userDownvotePlayer(playerId: playerId);
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to downvote player: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> userRemoveVote({
    required String playerId,
    required bool isUpvote,
  }) async {
    try {
      await remoteDataSource.userRemoveVote(
        playerId: playerId,
        isUpvote: isUpvote,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to remove vote: $e"));
    }
  }
}
