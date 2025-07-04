import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/router/router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/widgets/league_card.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/join_league/cubit/join_league_cubit.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';

// Import the reusable LeagueCard and SearchLeagueCard widgets.

class AllLeaguesHomepageListView extends StatefulWidget {
  final String title;
  final List<LeagueSummary> leaguesSummary;

  const AllLeaguesHomepageListView({
    Key? key,
    required this.title,
    required this.leaguesSummary,
  }) : super(key: key);

  @override
  _AllLeaguesHomepageListViewState createState() =>
      _AllLeaguesHomepageListViewState();
}

class _AllLeaguesHomepageListViewState
    extends State<AllLeaguesHomepageListView> {
  bool _isSearchFocused = false;
  String _searchQuery = '';
  late FocusNode _searchFocusNode;
  late TextEditingController _searchController;

  static const String defaultImagePath =
      'assets/images/default_blue_gradient.png';

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();

    // Clear the search when focus is lost.
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          _isSearchFocused = false;
          _searchQuery = '';
          _searchController.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: !_isSearchFocused,
        title: !_isSearchFocused
            ? Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  hintText: 'Search leagues...',
                  border: InputBorder.none,
                ),
                autofocus: true,
                style: const TextStyle(fontSize: 17),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchFocused = true;
                  _searchFocusNode.requestFocus();
                });
              },
            ),
          ),
        ],
      ),
      body: _buildLeaguesList(),
    );
  }

  Widget _buildLeaguesList() {
    final filteredLeagues = widget.leaguesSummary
        .where((league) =>
            (league.league.leagueTitle?.toLowerCase().contains(_searchQuery) ??
                false))
        .toList();

    if (filteredLeagues.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isNotEmpty
              ? 'No leagues found for "$_searchQuery"'
              : 'No leagues available.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    // Instead of building the card manually, reference the reusable LeagueCard widget.
    return ListView.builder(
      itemCount: filteredLeagues.length,
      itemBuilder: (context, index) {
        final leagueSummary = filteredLeagues[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
          child: LeagueCard(
            leagueSummary: leagueSummary,
            defaultImagePath: defaultImagePath,
          ),
        );
      },
    );
  }
}
