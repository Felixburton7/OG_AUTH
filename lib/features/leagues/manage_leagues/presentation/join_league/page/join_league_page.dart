import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/router/router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/network/connection_checker.dart';
import 'package:panna_app/core/utils/team_name_helper.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/join_league/cubit/join_league_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';

@injectable
class JoinLeaguePage extends StatefulWidget {
  const JoinLeaguePage({super.key});

  @override
  _JoinLeaguePageState createState() => _JoinLeaguePageState();
}

class _JoinLeaguePageState extends State<JoinLeaguePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _searchError = false;

  /// Connection Checker instance (injected via get_it)
  final ConnectionChecker _connectionChecker = GetIt.I<ConnectionChecker>();

  /// Connectivity state
  bool isNoWifi = false;

  /// Timer for periodic connectivity checks
  Timer? _connectivityTimer;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    // Periodic connectivity check every 5 seconds.
    _connectivityTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkConnectivity();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _connectivityTimer?.cancel();
    super.dispose();
  }

  /// Checks current internet connectivity.
  Future<void> _checkConnectivity() async {
    bool connected = await _connectionChecker.isConnected;
    if (!connected && !isNoWifi) {
      setState(() {
        isNoWifi = true;
      });
    } else if (connected && isNoWifi) {
      setState(() {
        isNoWifi = false;
      });
      // Optionally trigger a data refresh here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JoinLeagueCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Join a League',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: isNoWifi
            ? noWifiWidget()
            : Column(
                children: [
                  // Search Field for "Add Code"
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _isSearching = value.isNotEmpty;
                              _searchError = false;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).canvasColor,
                            hintText: 'Use Add Code',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _isSearching
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                        _isSearching = false;
                                        _searchError = false;
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                        if (_isSearching)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              onPressed: _verifyAddCode,
                              child: const Text('Verify Add Code'),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // When searching, display league found by add code.
                  if (_isSearching && !_searchError)
                    Expanded(
                      child: FutureBuilder<dynamic>(
                        future: _searchLeagueByAddCode(_searchQuery),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Center(
                                child: Text('No league found.'));
                          } else {
                            final leagueMap =
                                snapshot.data as Map<String, dynamic>;
                            return _buildLeagueCard(context, leagueMap);
                          }
                        },
                      ),
                    )
                  // Otherwise, show list of public leagues.
                  else if (!_isSearching)
                    Expanded(
                      child: FutureBuilder<List<dynamic>>(
                        future: _fetchEligibleLeagues(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No public leagues available.'));
                          } else {
                            final leagues = snapshot.data!;
                            return ListView.builder(
                              itemCount: leagues.length,
                              itemBuilder: (context, index) {
                                final leagueMap =
                                    leagues[index] as Map<String, dynamic>;
                                return _buildLeagueCard(context, leagueMap);
                              },
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  /// Widget displayed when there is no internet connection.
  Widget noWifiWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your internet connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _checkConnectivity,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Searches for a league by its "Add Code".
  Future<dynamic> _searchLeagueByAddCode(String addCode) async {
    try {
      final response = await Supabase.instance.client
          .from('leagues')
          .select()
          .eq('add_code', addCode)
          .maybeSingle();

      if (response == null) {
        setState(() => _searchError = true);
        throw Exception('Add Code Not Found');
      }
      return response;
    } catch (e) {
      setState(() => _searchError = true);
      throw Exception('Add Code Not Found');
    }
  }

  /// Fetches all public leagues that the user is not a member of.
  Future<List<dynamic>> _fetchEligibleLeagues() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User is not logged in');
      }

      // Get league IDs that the user is already a member of.
      final memberLeaguesResponse = await Supabase.instance.client
          .from('league_members')
          .select('league_id')
          .eq('profile_id', userId);

      final memberLeagueIds = (memberLeaguesResponse as List)
          .map((e) => e['league_id'] as String)
          .toList();

      // Get public leagues where the user is not a member.
      final leaguesResponse = await Supabase.instance.client
          .from('leagues')
          .select()
          .eq('league_is_private', false)
          .not('league_id', 'in', memberLeagueIds);

      return leaguesResponse as List<dynamic>;
    } catch (e) {
      throw Exception('Error fetching leagues: $e');
    }
  }

  /// Builds a league card styled like your LeagueCard code,
  /// using the same container, avatar, title, and bio styles.
  /// The join button is placed on the right side of the header row.
  /// The entire card is now clickable so that tapping it navigates to the league details page.
  Widget _buildLeagueCard(
      BuildContext context, Map<String, dynamic> leagueMap) {
    final double titleFontSize = 20;
    final double bioFontSize = 13;
    final double containerHeight = 97;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          final leagueEntity = _convertToLeagueEntity(leagueMap);
          // Wrap the LeagueEntity in LeagueDetailsArguments.
          context.push(
            Routes.leagueHome.path,
            extra: LeagueDetailsArguments(league: leagueEntity),
          );
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 9),
              decoration: BoxDecoration(
                color: const Color.fromARGB(8, 249, 250, 246),
                border: Border.all(
                  color: const Color.fromARGB(255, 5, 51, 38),
                  width: 0.3,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: 380,
              height: containerHeight,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Avatar, league info, and Join button on the right.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor:
                            const Color.fromARGB(132, 206, 216, 214),
                        child: ClipOval(
                          child: FadeInImage(
                            placeholder: const AssetImage(
                                'assets/images/placeholder.png'),
                            image: (leagueMap['league_avatar_url'] != null &&
                                    (leagueMap['league_avatar_url'] as String)
                                        .isNotEmpty)
                                ? NetworkImage(leagueMap['league_avatar_url'])
                                : const AssetImage(
                                        'assets/images/placeholder.png')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                            width: 38,
                            height: 38,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                                width: 38,
                                height: 38,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3),
                            Text(
                              leagueMap['league_title'] ?? 'Unnamed League',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Join Button on the right.
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<JoinLeagueCubit>()
                              .joinLeague(context, leagueMap['league_id']);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 10,
                          ),
                          minimumSize: Size.zero,
                        ),
                        child: const Text(
                          'Join',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // League Bio
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      leagueMap['league_bio'] ?? 'No league bio available',
                      style: TextStyle(
                        fontSize: bioFontSize,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Called when the user taps “Verify Add Code”.
  void _verifyAddCode() {
    setState(() {
      _isSearching = true;
      _searchError = false;
    });
  }

  /// Helper: Convert a Map<String, dynamic> from Supabase into a LeagueEntity.
  LeagueEntity _convertToLeagueEntity(Map<String, dynamic> map) {
    return LeagueEntity(
      leagueId: map['league_id'] as String,
      leagueTitle: map['league_title'] as String? ?? 'Unnamed League',
      leagueBio: map['league_bio'] as String?,
      leagueAvatarUrl: map['league_avatar_url'] as String?,
      // Include additional fields as required.
    );
  }
}
