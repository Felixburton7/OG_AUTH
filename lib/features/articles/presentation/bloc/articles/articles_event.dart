part of 'articles_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object> get props => [];
}

class FetchArticles extends ArticlesEvent {}

class LikeArticleEvent extends ArticlesEvent {
  final String articleId;

  const LikeArticleEvent({required this.articleId});

  @override
  List<Object> get props => [articleId];
}

class UnlikeArticleEvent extends ArticlesEvent {
  final String articleId;

  const UnlikeArticleEvent({required this.articleId});

  @override
  List<Object> get props => [articleId];
}
