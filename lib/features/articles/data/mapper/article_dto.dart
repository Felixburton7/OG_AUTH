import 'package:equatable/equatable.dart';
import '../../domain/entities/article_entity.dart';

class ArticleDTO extends Equatable {
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
  final bool topStory;
  final bool shortStory;
  final bool liveOpinion;

  const ArticleDTO({
    required this.id,
    this.title,
    this.authorId,
    this.authorName,
    this.authorRating,
    this.date,
    this.content,
    this.imageUrl,
    required this.isDraft,
    required this.likes,
    this.createdAt,
    this.updatedAt,
    required this.topStory,
    required this.shortStory,
    required this.liveOpinion,
  });

  factory ArticleDTO.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value.toLowerCase() == 'true';
      return false;
    }

    return ArticleDTO(
      id: json['id'] as String,
      title: json['title'] as String?,
      authorId: json['author_id'] as String?,
      authorName: json['author_name'] as String?,
      authorRating: json['author_rating'] as int?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      isDraft: parseBool(json['is_draft']),
      likes: json['likes'] is int ? json['likes'] as int : 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      topStory: parseBool(json['topStory']),
      shortStory: parseBool(json['shortStory']),
      liveOpinion: parseBool(json['liveOpinion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author_id': authorId,
      'author_name': authorName,
      'author_rating': authorRating,
      'date': date?.toIso8601String(),
      'content': content,
      'image_url': imageUrl,
      'is_draft': isDraft ? 1 : 0,
      'likes': likes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'topStory': topStory ? 1 : 0,
      'shortStory': shortStory ? 1 : 0,
      'liveOpinion': liveOpinion ? 1 : 0,
    };
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      title: title,
      authorId: authorId,
      authorName: authorName,
      authorRating: authorRating,
      date: date,
      content: content,
      imageUrl: imageUrl,
      isDraft: isDraft,
      likes: likes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      topStory: topStory,
      shortStory: shortStory,
      liveOpinion: liveOpinion,
    );
  }

  factory ArticleDTO.fromEntity(ArticleEntity entity) {
    return ArticleDTO(
      id: entity.id,
      title: entity.title,
      authorId: entity.authorId,
      authorName: entity.authorName,
      authorRating: entity.authorRating,
      date: entity.date,
      content: entity.content,
      imageUrl: entity.imageUrl,
      isDraft: entity.isDraft,
      likes: entity.likes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      topStory: entity.topStory ?? false,
      shortStory: entity.shortStory ?? false,
      liveOpinion: entity.liveOpinion ?? false,
    );
  }

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
