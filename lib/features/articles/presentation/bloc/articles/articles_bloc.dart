import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';
import 'package:panna_app/features/articles/domain/usecases/fetch_all_articles_uscase.dart';
import 'package:panna_app/features/articles/domain/usecases/like_article_usecase.dart';
import 'package:panna_app/features/articles/domain/usecases/unlike_article_usecase.dart';

part 'articles_event.dart';
part 'articles_state.dart';

@injectable
class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final FetchAllArticlesUseCase fetchAllArticlesUseCase;
  final LikeArticleUseCase likeArticleUseCase;
  final UnlikeArticleUseCase unlikeArticleUseCase;

  ArticlesBloc({
    required this.fetchAllArticlesUseCase,
    required this.likeArticleUseCase,
    required this.unlikeArticleUseCase,
  }) : super(ArticlesInitial()) {
    on<FetchArticles>(_onFetchArticles);
    on<LikeArticleEvent>(_onLikeArticle);
    on<UnlikeArticleEvent>(_onUnlikeArticle);
  }

  Future<void> _onFetchArticles(
      FetchArticles event, Emitter<ArticlesState> emit) async {
    // Emit loading state; in production you might want to keep the current list visible.
    emit(ArticlesLoading());
    try {
      final Either<Failure, List<ArticleDetailEntity>> articlesEither =
          await fetchAllArticlesUseCase.execute(NoParams());
      articlesEither.fold(
        (failure) {
          // Instead of replacing the whole page with an error, we could choose to simply log it.
          // For now, if there's an error and we already have loaded articles, we keep them.
          if (state is ArticlesLoaded) {
            emit(state);
          } else {
            emit(ArticlesError(message: failure.message));
          }
        },
        (articles) => emit(ArticlesLoaded(articles: articles)),
      );
    } catch (e) {
      if (state is ArticlesLoaded) {
        emit(state);
      } else {
        emit(ArticlesError(message: 'Failed to load articles: $e'));
      }
    }
  }

  Future<void> _onLikeArticle(
      LikeArticleEvent event, Emitter<ArticlesState> emit) async {
    final result = await likeArticleUseCase.execute(
      LikeArticleParams(articleId: event.articleId),
    );
    result.fold(
      (failure) {
        // If the error message indicates a duplicate key error, then the user has already liked this article.
        // In that case, we trigger an unlike event instead.
        if (failure.message.contains('duplicate key')) {
          add(UnlikeArticleEvent(articleId: event.articleId));
        } else {
          // For other errors, we simply re-fetch articles to maintain UI consistency.
          add(FetchArticles());
        }
      },
      (_) {
        // On successful like, re-fetch articles so the updated like count is reflected.
        add(FetchArticles());
      },
    );
  }

  Future<void> _onUnlikeArticle(
      UnlikeArticleEvent event, Emitter<ArticlesState> emit) async {
    final result = await unlikeArticleUseCase.execute(
      UnlikeArticleParams(articleId: event.articleId),
    );
    result.fold(
      (failure) {
        // Log the error and re-fetch articles so the UI remains consistent.
        add(FetchArticles());
      },
      (_) {
        add(FetchArticles());
      },
    );
  }
}
