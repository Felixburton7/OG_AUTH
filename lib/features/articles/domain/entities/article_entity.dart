import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String id;
  final String? title;
  final String? authorId;
  final String? authorName;
  final int? authorRating;
  final DateTime? date;
  final String? content;
  final String? imageUrl;
  final bool isDraft;
  final int? likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? topStory;
  final bool? shortStory;
  final bool? liveOpinion;

  const ArticleEntity({
    required this.id,
    this.title,
    this.authorId,
    this.authorName,
    this.authorRating,
    this.date,
    this.content,
    this.imageUrl,
    this.isDraft = false,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.topStory,
    this.shortStory,
    this.liveOpinion,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        authorId,
        authorName,
        authorRating,
        date,
        content,
        imageUrl,
        isDraft,
        likes,
        createdAt,
        updatedAt,
        topStory,
        shortStory,
        liveOpinion,
      ];
}
