// articles/domain/usecases/like_article_usecase.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import '../repository/articles_repository.dart';

/// Parameters required for liking an article.
class LikeArticleParams {
  final String articleId;

  LikeArticleParams({required this.articleId});
}

@injectable
class LikeArticleUseCase implements UseCase<void, LikeArticleParams> {
  final ArticlesRepository repository;

  LikeArticleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(LikeArticleParams params) async {
    return await repository.userLikeArticle(articleId: params.articleId);
  }
}
