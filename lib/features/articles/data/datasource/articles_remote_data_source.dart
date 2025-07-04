import 'package:injectable/injectable.dart';
import 'package:panna_app/features/articles/data/mapper/article_details_dto.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';
import 'package:supabase/supabase.dart';
import '../mapper/article_dto.dart';
import '../../domain/entities/article_entity.dart';

@injectable
class ArticlesRemoteDataSource {
  final SupabaseClient client;

  ArticlesRemoteDataSource({required this.client});

  /// Fetches all articles along with their associated comments and likes.
  Future<List<ArticleDetailEntity>> fetchAllArticlesDetail() async {
    final response = await client
        .from('articles')
        .select('*, article_comments(*), article_likes(*)')
        .order('created_at', ascending: false);

    final List data = response as List;
    return data
        .map((json) => ArticleDetailDTO.fromJson(json).toEntity())
        .toList();
  }

  /// Inserts a new like record into the 'article_likes' table.
  Future<void> userLikeArticle({
    required String articleId,
  }) async {
    final userId = client.auth.currentSession!.user.id;

    // Fetch the username from the 'profiles' table using the user's ID.
    final username = await _fetchUsernameFromProfiles(userId);

    // Insert a new row into 'article_likes'.
    final response = await client.from('article_likes').insert({
      'article_id': articleId,
      'username': username, // foreign key to profiles.username
      'profile_id': userId, // references the user's ID in profiles
      'liked_at': DateTime.now().toIso8601String(),
    });

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  /// Deletes the like record for the current user on the given article.
  Future<void> userUnlikeArticle({
    required String articleId,
  }) async {
    final userId = client.auth.currentSession!.user.id;

    // Delete the like row where both article_id and profile_id match.
    final response = await client
        .from('article_likes')
        .delete()
        .eq('article_id', articleId)
        .eq('profile_id', userId);

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  /// Private helper to fetch a username from the 'profiles' table
  /// given a user's Supabase Auth ID.
  Future<String> _fetchUsernameFromProfiles(String authId) async {
    final response = await client
        .from('profiles')
        .select('username')
        .eq('profile_id', authId)
        .single();

    return response['username'] as String;
  }

  /// Inserts a new upvote record into the 'player_votes' table.
  Future<void> userUpvotePlayer({
    required String playerId,
  }) async {
    final userId = client.auth.currentSession!.user.id;
    final response = await client.from('player_votes').insert({
      'player_id': playerId,
      'profile_id': userId,
      'upvote': true,
      'downvote': false,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  /// Inserts a new downvote record into the 'player_votes' table.
  Future<void> userDownvotePlayer({
    required String playerId,
  }) async {
    final userId = client.auth.currentSession!.user.id;
    final response = await client.from('player_votes').insert({
      'player_id': playerId,
      'profile_id': userId,
      'upvote': false,
      'downvote': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  /// Deletes a vote (either upvote or downvote) for the current user on the given player.
  /// Pass `isUpvote` as true to delete an upvote, or false for a downvote.
  Future<void> userRemoveVote({
    required String playerId,
    required bool isUpvote,
  }) async {
    final userId = client.auth.currentSession!.user.id;
    final response = await client
        .from('player_votes')
        .delete()
        .eq('player_id', playerId)
        .eq('profile_id', userId)
        .eq(isUpvote ? 'upvote' : 'downvote', true);

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}
