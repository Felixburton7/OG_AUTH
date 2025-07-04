import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for haptic feedback
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/router/navigation/nav_drawer_navigator/navigation_drawer.dart';
import 'package:panna_app/core/router/router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/utils/string_to_datetime.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

// Import the separate card widgets.
import '../widgets/league_card.dart';
import '../widgets/search_league_card.dart';

/// Updated enum with four options: Recent, Active, Inactive, and Featured.
enum FilterOption { recent, active, inactive, featured }

class AllLeaguesHomepage extends StatefulWidget {
  AllLeaguesHomepage({Key? key}) : super(key: key);

  @override
  _AllLeaguesHomepageState createState() => _AllLeaguesHomepageState();
}

class _AllLeaguesHomepageState extends State<AllLeaguesHomepage> {
  final List<String> defaultImagePaths = [
    'assets/images/default_blue_gradient.png',
    // 'assets/images/default_purple_gradient.png',
    'assets/images/default_green_gradient.png',
    'assets/images/default_yellow_gradient.png',
    // 'assets/images/default_red_gradient.png',
  ];

  String getRandomDefaultImagePath() {
    final random = Random();
    return defaultImagePaths[random.nextInt(defaultImagePaths.length)];
  }

  final Map<String, String> teamToCrest = {
    'Arsenal': 'assets/images/arsenal.png',
    'AFC Bournemouth': 'assets/images/bournemouth.png',
    'Brentford': 'assets/images/brentford.png',
    'Brighton & Hove Albion': 'assets/images/brighton.png',
    'Chelsea': 'assets/images/chelsea.png',
    'Everton': 'assets/images/everton_crest.png',
    'Nottingham Forest': 'assets/images/forest.png',
    'Fulham': 'assets/images/fulham.png',
    'Ipswich Town': 'assets/images/ipswich.png',
    'Leicester City': 'assets/images/leicester.png',
    'Liverpool': 'assets/images/liverpool.png',
    'Manchester City': 'assets/images/man_city.png',
    'Manchester United': 'assets/images/man_united.png',
    'Newcastle United': 'assets/images/newcastle.png',
    'Crystal Palace': 'assets/images/palace.png',
    'Southampton': 'assets/images/southampton.png',
    'Tottenham Hotspur': 'assets/images/tottenham.png',
    'Aston Villa': 'assets/images/aston_villa.png',
    'West Ham United': 'assets/images/west_ham.png',
    'Wolverhampton Wanderers': 'assets/images/wolves.png',
  };

  /// When true, the dedicated search screen is shown.
  bool _isSearchBoxActive = false;
  String _searchQuery = '';
  late FocusNode _searchFocusNode;
  late TextEditingController _searchController;
  int _currentCarouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  Timer? _carouselTimer;

  // New filter option state. Default is set to Recent.
  FilterOption _selectedFilter = FilterOption.recent;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();
    // Log screen view for AllLeaguesHomepage.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<FirebaseAnalyticsService>().setCurrentScreen('AllLeaguesHomepage');
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).animate(animation);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      // Use keys so that AnimatedSwitcher knows which widget is which.
      child: _isSearchBoxActive
          ? _buildSearchPage(key: ValueKey('searchPage'))
          : _buildMainPage(key: ValueKey('mainPage')),
    );
  }

  /// The main leagues homepage (non-search view).
  Widget _buildMainPage({Key? key}) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 44, 182, 85).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final profile = (state is ProfileLoaded)
                    ? state.profile
                    : (state is ProfileAvatarUpdating)
                        ? state.profile
                        : null;
                final balance =
                    profile?.accountBalance?.toStringAsFixed(2) ?? '0.00';
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '£$balance',
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                          0, -4), // Adjust this value to lift the icon up
                      child: IconButton(
                        icon: Icon(Icons.manage_accounts),
                        onPressed: () async {
                          // Navigation code
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
      drawer: NavDrawer(),
      body: BlocConsumer<LeagueBloc, LeagueState>(
        listener: (context, state) {
          if (state is LeagueError) {
            context.showErrorSnackBarMessage(
                "We are having trouble loading the league right now");
          }
        },
        builder: (context, state) {
          if (state is LeagueLoading) {
            // Modified: Wrap loading spinner in a full-page RefreshIndicator.
            return RefreshIndicator(
              onRefresh: () async {
                context.read<LeagueBloc>().add(FetchUserLeagues());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),
            );
          } else if (state is UserLeaguesLoaded) {
            // Filter leagues by the search query (if any)
            final filteredLeagues = state.leagues
                .where((league) =>
                    league.league.leagueTitle
                        ?.toLowerCase()
                        .contains(_searchQuery) ??
                    false)
                .toList();

            if (_selectedFilter == FilterOption.recent) {
              // Process leagues for the recent filter...
              List<LeagueSummary> myLeagues = filteredLeagues
                  .where((leagueSummary) => leagueSummary.isUserAMember == true)
                  .toList();
              final activeMyLeagues = myLeagues
                  .where((leagueSummary) => leagueSummary.activeLeague == true)
                  .toList();
              activeMyLeagues
                  .sort((a, b) => b.memberCount.compareTo(a.memberCount));
              final inactiveMyLeagues = myLeagues
                  .where((leagueSummary) => leagueSummary.activeLeague != true)
                  .toList();
              myLeagues = [...activeMyLeagues, ...inactiveMyLeagues];

              final leaguesStartingSoon = filteredLeagues
                  .where((leagueSummary) =>
                      leagueSummary.numberOfWeeksActive == 0 &&
                      leagueSummary.isUserAMember == false)
                  .toList();
              final featuredLeagues = filteredLeagues
                  .where((leagueSummary) =>
                      leagueSummary.isUserAMember == false &&
                      leagueSummary.league.leagueIsPrivate == false)
                  .toList();

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<LeagueBloc>().add(FetchUserLeagues());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    // Modified: Ensure the scrollable area fills the screen.
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Column(
                        children: [
                          _buildFilterRow(),
                          if (myLeagues.isNotEmpty)
                            _buildLeagueSection(
                                context, 'My Leagues', myLeagues, state),
                          if (leaguesStartingSoon.isNotEmpty)
                            _buildLeagueSection(
                                context,
                                'Leagues Starting Soon',
                                leaguesStartingSoon,
                                state),
                          if (featuredLeagues.isNotEmpty)
                            _buildLeagueSection(
                                context, 'Featured', featuredLeagues, state),
                          if (filteredLeagues.isEmpty &&
                              _searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No leagues found for "$_searchQuery"',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (_selectedFilter == FilterOption.active) {
              final activeLeagues = filteredLeagues
                  .where((leagueSummary) =>
                      leagueSummary.isUserAMember == true &&
                      leagueSummary.activeLeague == true)
                  .toList();
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<LeagueBloc>().add(FetchUserLeagues());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Column(
                        children: [
                          _buildFilterRow(),
                          if (activeLeagues.isNotEmpty)
                            _buildLeagueSection(context, 'My Active Leagues',
                                activeLeagues, state)
                          else if (_searchQuery.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No leagues with active bets that can still be won',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No leagues found for "$_searchQuery"',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (_selectedFilter == FilterOption.inactive) {
              final inactiveLeagues = filteredLeagues
                  .where((leagueSummary) =>
                      leagueSummary.isUserAMember == true &&
                      leagueSummary.activeLeague == false)
                  .toList();
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<LeagueBloc>().add(FetchUserLeagues());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Column(
                        children: [
                          _buildFilterRow(),
                          if (inactiveLeagues.isNotEmpty)
                            _buildLeagueSection(context, 'My Inactive Leagues',
                                inactiveLeagues, state)
                          else if (_searchQuery.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No leagues that are "Inactive" ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No leagues found for "$_searchQuery"',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (_selectedFilter == FilterOption.featured) {
              final nonMemberLeagues = filteredLeagues
                  .where(
                      (leagueSummary) => leagueSummary.isUserAMember == false)
                  .toList();
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<LeagueBloc>().add(FetchUserLeagues());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Column(
                        children: [
                          _buildFilterRow(),
                          if (nonMemberLeagues.isNotEmpty)
                            _buildLeagueSection(context, 'Featured Leagues',
                                nonMemberLeagues, state)
                          else if (_searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No leagues found for "$_searchQuery"',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          } else if (state is LeagueError) {
            return _buildErrorContent(context, state.message);
          } else {
            return _buildErrorContent(context, 'Cannot load leagues right now');
          }
        },
      ),
    );
  }

  /// The dedicated search screen.
  Widget _buildSearchPage({Key? key}) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        toolbarHeight: 100, // Bigger AppBar
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            style: const TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              hintText: 'Search leagues',
              hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 72, 72, 72), fontSize: 18),
              filled: true,
              fillColor: const Color.fromARGB(255, 228, 228, 228),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isSearchBoxActive = false;
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<LeagueBloc, LeagueState>(
        builder: (context, state) {
          if (state is LeagueLoading) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<LeagueBloc>().add(FetchUserLeagues());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),
            );
          } else if (state is UserLeaguesLoaded) {
            final filteredLeagues = state.leagues
                .where((league) => (league.league.leagueTitle
                        ?.toLowerCase()
                        .contains(_searchQuery) ??
                    false))
                .toList();

            if (_searchQuery.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Search',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      'Search for any public league!\nType in the league title. \n\nFor private leagues go to ',
                                ),
                                TextSpan(
                                  text: 'Join Leagues',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push(Routes.joinLeague.path);
                                    },
                                ),
                                const TextSpan(
                                  text: ' and type in the add code.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (filteredLeagues.isEmpty) {
              return Center(
                child: Text(
                  'No leagues found for "$_searchQuery"',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: filteredLeagues.length,
                itemBuilder: (context, index) {
                  final leagueSummary = filteredLeagues[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    child: SearchLeagueCard(
                      leagueSummary: leagueSummary,
                      defaultImagePath: getRandomDefaultImagePath(),
                    ),
                  );
                },
              );
            }
          } else if (state is LeagueError) {
            return _buildErrorContent(context, state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  /// Builds a filter row with search icon and filter buttons.
  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Search Box
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSearchBoxActive = true;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 207, 207, 207)),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: Icon(Icons.search),
              ),
            ),
            const SizedBox(width: 8),
            // Recent Filter Box
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick(); // Added haptic feedback
                setState(() {
                  _selectedFilter = FilterOption.recent;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _selectedFilter == FilterOption.recent
                          ? const Color(0xFF1C8366)
                          : Color.fromARGB(255, 207, 207, 207)),
                  borderRadius: BorderRadius.circular(20),
                  color: _selectedFilter == FilterOption.recent
                      ? const Color(0xFF1C8366)
                      : Colors.transparent,
                ),
                child: Text(
                  'Recent',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _selectedFilter == FilterOption.recent
                        ? Colors.white
                        : const Color.fromARGB(255, 134, 134, 134),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Active Filter Box
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick(); // Added haptic feedback
                setState(() {
                  _selectedFilter = FilterOption.active;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedFilter == FilterOption.active
                        ? const Color(0xFF1C8366)
                        : const Color.fromARGB(255, 207, 207, 207),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: _selectedFilter == FilterOption.active
                      ? const Color(0xFF1C8366)
                      : Colors.transparent,
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _selectedFilter == FilterOption.active
                        ? Colors.white
                        : const Color.fromARGB(255, 134, 134, 134),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Inactive Filter Box
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick(); // Added haptic feedback
                setState(() {
                  _selectedFilter = FilterOption.inactive;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _selectedFilter == FilterOption.inactive
                          ? const Color(0xFF1C8366)
                          : const Color.fromARGB(255, 207, 207, 207)),
                  borderRadius: BorderRadius.circular(20),
                  color: _selectedFilter == FilterOption.inactive
                      ? const Color(0xFF1C8366)
                      : Colors.transparent,
                ),
                child: Text(
                  'Inactive',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _selectedFilter == FilterOption.inactive
                        ? Colors.white
                        : const Color.fromARGB(255, 134, 134, 134),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Featured Filter Box
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick(); // Added haptic feedback
                setState(() {
                  _selectedFilter = FilterOption.featured;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _selectedFilter == FilterOption.featured
                          ? const Color(0xFF1C8366)
                          : const Color.fromARGB(255, 207, 207, 207)),
                  borderRadius: BorderRadius.circular(20),
                  color: _selectedFilter == FilterOption.featured
                      ? const Color(0xFF1C8366)
                      : Colors.transparent,
                ),
                child: Text(
                  'Featured',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _selectedFilter == FilterOption.featured
                        ? Colors.white
                        : const Color.fromARGB(255, 134, 134, 134),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a league section with a title and a horizontal list of cards.
  Widget _buildLeagueSection(BuildContext context, String title,
      List<LeagueSummary> leagues, LeagueState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 15),
                onPressed: () {
                  context.push(
                    Routes.allLeaguesHomepageListView.path,
                    extra:
                        LeagueListPageArguments(title: title, leagues: leagues),
                  );
                },
              ),
            ],
          ),
        ),
        _buildLeaguesList(context, leagues, state),
      ],
    );
  }

  /// Builds a horizontal list of LeagueCard widgets (for non-search view).
  Widget _buildLeaguesList(
      BuildContext context, List<LeagueSummary> leagues, LeagueState state) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.755;
    cardWidth = cardWidth > 380 ? 380 : cardWidth;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: SizedBox(
        height: 245,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (leagues.length / 2).ceil(),
          itemBuilder: (context, index) {
            final firstIndex = index * 2;
            final secondIndex = firstIndex + 1;
            return Container(
              width: cardWidth,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                children: [
                  LeagueCard(
                    leagueSummary: leagues[firstIndex],
                    defaultImagePath: getRandomDefaultImagePath(),
                  ),
                  if (secondIndex < leagues.length)
                    LeagueCard(
                      leagueSummary: leagues[secondIndex],
                      defaultImagePath: getRandomDefaultImagePath(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Modified _buildErrorContent to include the filter row at the top and
  /// display a full-page error message with an icon and a “swipe up” prompt.
  Widget _buildErrorContent(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LeagueBloc>().add(FetchUserLeagues());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          // Ensure the content fills at least the full screen height.
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              // Always show the filter row at the top.
              _buildFilterRow(),
              // Use Expanded to take up the rest of the space.
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // You can change this icon to one you prefer (e.g. Icons.wifi_off).
                      Icon(Icons.wifi_off, color: Colors.grey, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.swipe, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "Please swipe up to refetch",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // End of non-search view code.
}
