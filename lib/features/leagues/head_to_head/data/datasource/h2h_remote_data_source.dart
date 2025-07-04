import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_challenge_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class H2hGameRemoteDataSource {
  final SupabaseClient supabase;

  H2hGameRemoteDataSource(this.supabase);

  /// Fetch H2H game details from Supabase using the 'fetch_h2h_game_details' RPC.
  Future<Either<Failure, H2hGameDetails>> fetchH2hGameDetails(
      String leagueId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return Left(Failure('User is not authenticated.'));
    }

    try {
      print('Fetching H2H game details for league: $leagueId');
      final response = await supabase.rpc(
        'fetch_h2h_game_details',
        params: {
          'p_input_user_id': userId,
          'p_input_league_id': leagueId,
        },
      ).single();

      final h2hGameDetails = _mapToH2hGameDetails(response);
      return Right(h2hGameDetails);
    } catch (e) {
      print('Error fetching H2H game details: $e');
      return Left(
          Failure('Failed to fetch H2H game details. Please try again later.'));
    }
  }

  /// Create a new bet offer in Supabase using the RPC function.
  Future<Either<Failure, BetOfferEntity>> createBetOffer({
    required String fixtureId,
    required String teamId,
    required String gameweekId,
    required String leagueId,
    required double odds,
    required double stakeAmount,
    required DateTime deadline,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return Left(Failure('User is not authenticated.'));
    }

    try {
      print('Creating bet offer with params:');
      print('  Fixture ID: $fixtureId');
      print('  Team ID: $teamId');
      print('  Gameweek ID: $gameweekId');
      print('  League ID: $leagueId');
      print('  Odds: $odds');
      print('  Stake: $stakeAmount');
      print('  Deadline: ${deadline.toIso8601String()}');
      print('  Creator: $userId');

      // Call the RPC function directly
      print('Calling create_bet_offer_transaction RPC');
      final response = await supabase.rpc(
        'create_bet_offer_transaction',
        params: {
          'p_creator_id': userId,
          'p_fixture_id': fixtureId,
          'p_team_id': teamId,
          'p_gameweek_id': gameweekId,
          'p_league_id': leagueId,
          'p_odds': odds,
          'p_stake_per_challenge': stakeAmount,
          'p_deadline': deadline.toIso8601String(),
        },
      );

      if (response == null) {
        return Left(Failure('Failed to create bet offer: Received null data'));
      }

      try {
        print('Parsing bet offer data: $response');
        final betOffer = BetOfferEntity.fromJson(response);
        print('Successfully created bet offer with ID: ${betOffer.betId}');
        return Right(betOffer);
      } catch (e) {
        print('Error parsing bet offer data: $e');
        return Left(Failure('Failed to parse bet offer data: $e'));
      }
    } catch (e) {
      print('Exception in createBetOffer: $e');
      return Left(Failure(
          'Failed to create bet offer. Please try again later. Error: $e'));
    }
  }

  /// Create a new bet challenge in Supabase using the RPC function.
  Future<Either<Failure, BetChallengeEntity>> createBetChallenge({
    required String betId,
    required String challengerTeamId,
    required String leagueId,
    required double stake,
    required DateTime deadline,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('Error: User is not authenticated');
      return Left(Failure('User is not authenticated.'));
    }

    try {
      print('Creating bet challenge with params:');
      print('  Bet ID: $betId');
      print('  Challenger team ID: $challengerTeamId');
      print('  League ID: $leagueId');
      print('  Stake: $stake');
      print('  Deadline: ${deadline.toIso8601String()}');
      print('  Challenger: $userId');

      // Call the RPC function directly
      print('Calling create_bet_challenge_transaction RPC');
      try {
        final rpcResponse = await supabase.rpc(
          'create_bet_challenge_transaction',
          params: {
            'p_bet_id': betId,
            'p_challenger_id': userId,
            'p_challenger_team_id': challengerTeamId,
            'p_league_id': leagueId,
            'p_stake': stake,
            'p_deadline': deadline.toIso8601String(),
          },
        );

        // Ensure we got data back
        if (rpcResponse == null) {
          print('Error: RPC response is null');
          return Left(Failure(
              'Failed to create bet challenge: No response from server'));
        }

        // Check for error properties in the response
        final data = rpcResponse as Map<String, dynamic>;
        if (data.containsKey('error')) {
          final errorMsg = data['error'];
          print('Error in response data: $errorMsg');
          return Left(Failure('Failed to create bet challenge: $errorMsg'));
        }

        print('RPC successful, data received: $data');

        // Parse the challenge entity
        try {
          final betChallenge = BetChallengeEntity.fromJson(data);
          print(
              'Successfully created bet challenge with ID: ${betChallenge.challengeId}');
          return Right(betChallenge);
        } catch (e) {
          print('Error parsing challenge entity: $e');
          return Left(Failure('Failed to parse challenge data: $e'));
        }
      } catch (e) {
        print('Exception in createBetChallenge: $e');

        // Check if it's an insufficient balance error
        if (e.toString().contains('Insufficient balance')) {
          return Left(Failure('Insufficient balance to place this challenge.'));
        }

        return Left(Failure('Failed to create bet challenge: $e'));
      }
    } catch (e) {
      print('Exception in createBetChallenge: $e');
      return Left(Failure(
          'Failed to create bet challenge. Please try again later. Error: $e'));
    }
  }

  /// Confirm a bet challenge in Supabase.
  Future<Either<Failure, BetChallengeEntity>> confirmBetChallenge(
      String challengeId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return Left(Failure('User is not authenticated.'));
    }

    try {
      print('Confirming bet challenge: $challengeId');
      // Call the Supabase RPC to confirm the bet challenge
      final response = await supabase.rpc(
        'confirm_bet_challenge',
        params: {
          'p_challenge_id': challengeId,
          'p_user_id': userId,
        },
      );

      print('Confirmation response: $response');
      final betChallenge = BetChallengeEntity.fromJson(response);
      return Right(betChallenge);
    } catch (e) {
      print('Error confirming bet challenge: $e');
      return Left(Failure('Failed to confirm bet challenge: $e'));
    }
  }

  /// Decline a bet challenge in Supabase.
  Future<Either<Failure, BetChallengeEntity>> declineBetChallenge(
      String challengeId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return Left(Failure('User is not authenticated.'));
    }

    try {
      print('Declining bet challenge: $challengeId');
      // Call the Supabase RPC to decline the bet challenge
      final response = await supabase.rpc(
        'decline_bet_challenge',
        params: {
          'p_challenge_id': challengeId,
          'p_user_id': userId,
        },
      );

      print('Decline response: $response');
      final betChallenge = BetChallengeEntity.fromJson(response);
      return Right(betChallenge);
    } catch (e) {
      print('Error declining bet challenge: $e');
      return Left(Failure('Failed to decline bet challenge: $e'));
    }
  }

  /// Cancel a bet challenge in Supabase.
  Future<Either<Failure, BetChallengeEntity>> cancelBetChallenge(
      String challengeId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return Left(Failure('User is not authenticated.'));
    }

    try {
      print('Cancelling bet challenge: $challengeId');
      // Call the Supabase RPC to cancel the bet challenge
      final response = await supabase.rpc(
        'cancel_bet_challenge',
        params: {
          'p_challenge_id': challengeId,
          'p_user_id': userId,
        },
      );

      print('Cancel response: $response');
      final betChallenge = BetChallengeEntity.fromJson(response);
      return Right(betChallenge);
    } catch (e) {
      print('Error cancelling bet challenge: $e');
      return Left(Failure('Failed to cancel bet challenge: $e'));
    }
  }

  /// Maps the JSON/Map returned by the RPC to our H2hGameDetails model.
  H2hGameDetails _mapToH2hGameDetails(Map<String, dynamic> data) {
    // Helper functions to safely parse booleans and doubles.
    bool _parseBool(dynamic val) =>
        val is bool ? val : (val.toString().toLowerCase() == 'true');
    double _parseDouble(dynamic val) =>
        double.tryParse(val?.toString() ?? '0') ?? 0.0;

    // Build a LeagueEntity from the provided data.
    final league = LeagueEntity(
      leagueId: data['league_id'] as String?,
      leagueTitle: data['league_title'] as String?,
      leagueBio: data['league_bio'] as String?,
      leagueIsPrivate: _parseBool(data['league_is_private']),
      leagueAvatarUrl: data['league_avatar_url'] as String?,
      buyIn: _parseDouble(data['buy_in']),
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'])
          : null,
      createdBy: data['created_by'] as String?,
      addCode: data['add_code'] as String?,
    );

    // Map bet offers.
    final betOffers = (data['bet_offers'] as List<dynamic>?)
            ?.map(
                (json) => BetOfferEntity.fromJson(json as Map<String, dynamic>))
            .toList() ??
        [];

    // Map bet challenges (can be null).
    final betChallenges = (data['bet_challenges'] as List<dynamic>?)
        ?.map(
            (json) => BetChallengeEntity.fromJson(json as Map<String, dynamic>))
        .toList();

    // Map league members.
    final leagueMembers = (data['league_members'] as List<dynamic>?)
            ?.map((json) =>
                LeagueMembersEntity.fromJson(json as Map<String, dynamic>))
            .toList() ??
        [];

    // Map fixtures.
    final fixtures = (data['fixtures'] as List<dynamic>?)
            ?.map(
                (json) => FixtureEntity.fromJson(json as Map<String, dynamic>))
            .toList() ??
        [];

    return H2hGameDetails(
      leagueId: data['league_id'] as String,
      league: league,
      leagueBio: data['league_bio'] as String?,
      leagueIsPrivate: _parseBool(data['league_is_private']),
      leagueAvatarUrl: data['league_avatar_url'] as String?,
      buyIn: _parseDouble(data['buy_in']),
      betOffers: betOffers,
      betChallenges: betChallenges,
      leagueMembers: leagueMembers,
      fixtures: fixtures,
      currentGameweekNumber: data['current_gameweek_number'] as int? ?? 0,
      currentGameweekId: data['current_gameweek_id'] as String? ?? '',
      currentDeadline: data['current_deadline'] != null
          ? DateTime.tryParse(data['current_deadline']) ?? DateTime.now()
          : DateTime.now(),
      addCode: data['add_code'] as String? ?? '',
      createdBy: data['created_by'] as String? ?? '',
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at']) ?? DateTime.now()
          : DateTime.now(),
      memberCount: data['member_count'] as int? ?? 0,
      profileId: data['profile_id'] as String? ?? '',
      profileUpdatedAt: data['profile_updated_at'] != null
          ? DateTime.tryParse(data['profile_updated_at'])
          : null,
      profileDateOfBirth: data['profile_date_of_birth'] != null
          ? DateTime.tryParse(data['profile_date_of_birth'])
          : null,
      profileUsername: data['profile_username'] as String? ?? '',
      profileAvatarUrl: data['profile_avatar_url'] as String? ?? '',
      profileTeamSupported: data['profile_team_supported'] as String? ?? '',
      profileAccountBalance: _parseDouble(data['profile_account_balance']),
      profileFirstName: data['profile_first_name'] as String? ?? '',
      profileLastName: data['profile_last_name'] as String? ?? '',
      isAdmin: _parseBool(data['is_admin']),
      mutualMemberCount: data['mutual_member_count'] as int? ?? 0,
      totalPlayers: data['total_players'] as int? ?? 0,
    );
  }
}
