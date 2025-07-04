import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:panna_app/core/utils/string_to_datetime.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';
import 'package:supabase/supabase.dart';

@Injectable(as: ManageLeaguesRepository)
class SupabaseManageLeaguesRepository implements ManageLeaguesRepository {
  final SupabaseClient _supabaseClient;

  SupabaseManageLeaguesRepository(this._supabaseClient);

  @override
  Future<LeagueDTO> createLeague(LeagueDTO league) async {
    try {
      final userId = _supabaseClient.auth.currentUser!.id;
      final response = await _supabaseClient
          .from('leagues')
          .insert({
            'created_by': userId,
            'buy_in': league.buyIn,
            'league_title': league.leagueTitle,
            'league_avatar_url': league.leagueAvatarUrl,
            'league_is_private': league.leagueIsPrivate,
            'first_survivor_round_start_date':
                league.firstSurvivorRoundStartDate, // Apply conversion

            'league_bio': league.leagueBio
          })
          .select(
              'league_id, created_by, buy_in, league_title, league_avatar_url, add_code, league_is_private, first_survivor_round_start_date, league_bio')
          .single(); // Ensure we only get the single inserted record

      if (response == null) {
        throw Exception('Failed to create the league. Response is null.');
      }
      final createdLeague = LeagueDTO.fromJson(response);

      return createdLeague;
    } on PostgrestException catch (e) {
      throw Exception('Database error during league creation: ${e.message}');
    } on AuthException catch (error) {
      throw Exception('Authentication error: ${error.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred during league creation: $e');
    }
  }

  @override
  Future<LeagueDTO> updateLeague(LeagueDTO league) async {
    try {
      final leagueId = league.leagueId!;
      final response = await _supabaseClient
          .from('leagues')
          .update({
            'buy_in': league.buyIn,
            'league_title': league.leagueTitle,
            'league_avatar_url': league.leagueAvatarUrl ?? '',
            'league_is_private': league.leagueIsPrivate,
            'first_survivor_round_start_date':
                league.firstSurvivorRoundStartDate,
            'league_bio': league.leagueBio
          })
          .eq('league_id', leagueId)
          .select(
              'league_id, created_by, buy_in, league_title, league_avatar_url, add_code, league_is_private, first_survivor_round_start_date, league_bio')
          .single(); // Ensure we only get the updated record

      if (response == null) {
        throw Exception('Failed to update the league. Response is null.');
      }
      final updatedLeague = LeagueDTO.fromJson(response);

      return updatedLeague;
    } on PostgrestException catch (e) {
      throw Exception('Database error during league update: ${e.message}');
    } on AuthException catch (error) {
      throw Exception('Authentication error: ${error.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred during league update: $e');
    }
  }

  @override
  Future<List<Map<String, String>>> fetchUpcomingGameWeeks() async {
    try {
      // Fetch the current game week number to determine the starting point for the upcoming weeks
      final currentGameWeekNumber = await _fetchCurrentGameWeekNumber();

      // Query the 'game_weeks' table to fetch game weeks that come after the current game week
      final response = await _supabaseClient
          .from('game_weeks')
          .select() // Select all columns (or you can specify the needed columns)
          .gte('gameweek_number',
              currentGameWeekNumber) // Fetch game weeks after the current one
          .order('gameweek_number',
              ascending:
                  true) // Order the results by game week number in ascending order
          .limit(7); // Limit the results to the next 7 game weeks

      // Transform the response into a list of maps with 'id' and 'label' keys
      final List<Map<String, String>> gameWeeks = (response as List)
          .map((gameWeek) => {
                'id': gameWeek['gameweek_id']
                    as String, // Extract the game week ID
                'label':
                    'Week ${gameWeek['gameweek_number']}: ${DateTime.parse(gameWeek['deadline']).toLocal().toString().split(' ')[0]}', // Format the label with the week number and date
              })
          .toList();

      return gameWeeks; // Return the list of game weeks
    } on PostgrestException catch (e) {
      // Handle database-related errors during the query
      throw Exception(
          'Database error during game weeks fetching: ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors
      throw Exception(
          'Unexpected error occurred during game weeks fetching: $e');
    }
  }

  Future<int> _fetchCurrentGameWeekNumber() async {
    // Query to fetch the current game week number
    final response = await _supabaseClient
        .from('game_weeks')
        .select('gameweek_number') // Select only the 'gameweek_number' column
        .eq('current_game_week', true) // Filter to get the current game week
        .single(); // Expect a single result since only one week should be marked as current

    // Return the current game week number
    return response['gameweek_number'] as int;
  }

  @override
  Future<void> joinLeague(String leagueId) async {
    try {
      final userId = _supabaseClient.auth.currentUser!.id;
      final response = await _supabaseClient.from('league_members').insert({
        'profile_id': userId,
        'league_id': leagueId,
        // 'survivor_status': false,
        // 'paid_buy_in': false,
        'admin': false,
        'joined_at': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (e) {
      // Re-throw the custom error message if it's a unique constraint violation
      if (e.message.contains('unique_league_member')) {
        throw Exception('\nYou are already in this league!');
      } else {
        throw Exception('Database error during league joining: ${e.message}');
      }
    } on AuthException catch (error) {
      throw Exception('Authentication error: ${error.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred during league joining: $e');
    }
  }

  Future<bool> payBuyIn(String leagueId) async {
    try {
      final userId = _supabaseClient.auth.currentUser!.id;
      print('Attempting to pay buy-in for League ID: $leagueId');

      final res = await _supabaseClient.functions.invoke(
        'lms_pay_buy_in',
        body: {'league_id': leagueId, 'user_id': userId},
        headers: {
          'Authorization':
              'Bearer ${_supabaseClient.auth.currentSession?.accessToken}'
        },
      );

      print('Pay Buy-In response: ${res.data}');

      if (res.data != null) {
        Map<String, dynamic> data;
        if (res.data is String) {
          // Parse the JSON string into a Map
          data = jsonDecode(res.data);
        } else if (res.data is Map<String, dynamic>) {
          data = res.data;
        } else {
          throw Exception('Unexpected response format.');
        }

        if (data['success'] == true) {
          // Payment succeeded
          print('Payment succeeded.');
          return true;
        } else {
          final errorMessage =
              data['error'] ?? 'Payment failed. Please try again.';
          print('Payment failed: $errorMessage');
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Payment failed. Please try again.');
      }
    } on PostgrestException catch (error) {
      throw Exception('Cannot update buy-in: ${error.message}');
    } catch (e) {
      throw Exception('Unexpected error during buy-in: $e');
    }
  }

  // @override
  // Future<void> payBuyIn(String leagueId) async {
  //   try {
  //     final userId = _supabaseClient.auth.currentUser!.id;
  //     print('attempting pay buy in');
  //     final res = await _supabaseClient.functions.invoke(
  //       'lms_pay_buy_in',
  //       body: {'league_id': leagueId},
  //       headers: {
  //         'Authorization':
  //             'Bearer ${_supabaseClient.auth.currentSession?.accessToken}'
  //       },
  //     );
  //     print('Successfully attempted Pay buy In');
  //     if (res.data != null && res.data['success'] == true) {
  //       // Payment succeeded
  //     } else {
  //       // Payment error
  //       print('Payment error: ${res.data?['error']}');
  //     }
  //   } on PostgrestException catch (error) {
  //     throw Exception('Cannot update buy-in');
  //   }
  // }
  // @override
  // Future<void> payBuyIn(String leagueId) async {
  //   try {
  //     final userId = _supabaseClient.auth.currentUser!.id;
  //     final response = await _supabaseClient
  //         .from('lms_players')
  //         .update({
  //           'paid_buy_in': true,
  //         })
  //         .eq('profile_id', userId)
  //         .eq('league_id', leagueId);
  //   } on PostgrestException catch (error) {
  //     throw Exception('Cannot update buy-in');
  //   }
  // }

  @override
  Future<void> updateLeagueDetails(LeagueDTO updatedLeague) async {
    try {
      final leagueId = updatedLeague.leagueId!;
      final response = await _supabaseClient
              .from('leagues')
              .update({
                'league_title': updatedLeague.leagueTitle,
                'league_bio': updatedLeague.leagueBio,
                'buy_in': updatedLeague.buyIn,
                'league_avatar_url': updatedLeague.leagueAvatarUrl,
              })
              .eq('league_id', leagueId)
              .select()
              .single() // This returns a Map<String, dynamic> in newer versions
          ;

      // Success: do nothing or handle as needed
    } on PostgrestException catch (e) {
      throw Exception('Database error during league update: ${e.message}');
    } on AuthException catch (error) {
      throw Exception('Authentication error: ${error.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred during league update: $e');
    }
  }

  @override
  Future<LeagueSummary> verifyAddCode(String addCode) {
    // TODO: implement verifyAddCode
    throw UnimplementedError();
  }
}



//   @override
//   Future<LeagueSummary> verifyAddCode(String addCode) async {
//     try {
//       // Fetch the league based on the addCode
//       final leagueResponse = await _supabaseClient
//           .from('leagues')
//           .select()
//           .eq('add_code', addCode)
//           .single();

//       final league = LeagueDTO.fromJson(leagueResponse);
//       final leagueTransformed = league.toEntity();

//       // Ensure leagueId is non-null
//       final String leagueId = league.leagueId ?? '';
//       if (leagueId.isEmpty) {
//         throw Exception('League ID is missing.');
//       }

//       // Fetch the count of members in the league
//       final memberCountResponse = await _supabaseClient
//           .from('league_members')
//           .select('league_member_id')
//           .eq('league_id', leagueId);

//       // Get the actual count of members
//       final memberCount = memberCountResponse?.length ?? 0;

//       // Fetch the total pot values
//       final totalPotResponse = await _supabaseClient
//           .from('league_survivor_rounds')
//           .select('total_pot')
//           .eq('league_id', leagueId);

//       // Sum up all the total_pot values (assuming it's a list of maps)
//       double totalPot = totalPotResponse.? map(0.0, (double sum, item) {
//             // Ensure that both sum and item['total_pot'] are non-null
//           // Sum up all the total_pot values (assuming it's a list of maps)
// double totalPot = totalPotResponse?.fold(0.0, (sum, item) {
//   // Ensure that item['total_pot'] is non-null and treated as double
//   double potValue = item['total_pot'] as double? ?? 0.0;
//   return sum + potValue;
// }) ?? 0.0;

//       return LeagueSummary(
//         league: leagueTransformed,
//         memberCount: memberCount,
//         totalPot: totalPot,
//       );
//     } catch (e) {
//       // Handle exceptions
//       throw Exception("Failed to verify add code.");
//     }
//   }

