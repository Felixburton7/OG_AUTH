// articles/domain/usecases/unlike_article_usecase.dart

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import '../repository/articles_repository.dart';

/// Parameters required for unliking an article.
class UnlikeArticleParams {
  final String articleId;
  UnlikeArticleParams({required this.articleId});
}

@injectable
class UnlikeArticleUseCase implements UseCase<void, UnlikeArticleParams> {
  final ArticlesRepository repository;

  UnlikeArticleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(UnlikeArticleParams params) async {
    return await repository.userUnlikeArticle(articleId: params.articleId);
  }
}
