import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import '../entities/article_detail_entity.dart';
import '../repository/articles_repository.dart';

@injectable
class FetchAllArticlesUseCase
    implements UseCase<List<ArticleDetailEntity>, void> {
  final ArticlesRepository repository;

  FetchAllArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleDetailEntity>>> execute(
      void params) async {
    return await repository.fetchAllArticles();
  }
}
