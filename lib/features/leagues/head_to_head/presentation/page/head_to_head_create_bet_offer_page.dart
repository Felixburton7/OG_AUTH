import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/utils/team_name_helper.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/h2h_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/head_to_head_betslip.dart';

/// Constants and helper data
class TeamData {
  static const Map<String, String> teamToCrest = {
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

  static const Map<String, String> teamToAcronym = {
    'Arsenal': 'ARS',
    'AFC Bournemouth': 'BOU',
    'Brentford': 'BRE',
    'Brighton & Hove Albion': 'BHA',
    'Chelsea': 'CHE',
    'Everton': 'EVE',
    'Nottingham Forest': 'NFO',
    'Fulham': 'FUL',
    'Ipswich Town': 'IPS',
    'Leicester City': 'LEI',
    'Liverpool': 'LIV',
    'Manchester City': 'MCI',
    'Manchester United': 'MUN',
    'Newcastle United': 'NEW',
    'Crystal Palace': 'CRY',
    'Southampton': 'SOU',
    'Tottenham Hotspur': 'TOT',
    'Aston Villa': 'AVL',
    'West Ham United': 'WHU',
    'Wolverhampton Wanderers': 'WOL',
  };
}

class AppUtils {
  /// Converts a decimal multiplier to a reduced fraction string.
  /// (Here we assume the passed value is the stored odds value plus 1,
  /// so that passing 1.0 yields 2/1.)
  static String decimalToFraction(double value) {
    final double adjustedValue = value + 1.0;
    int numerator = (adjustedValue * 2).round();
    int denominator = 2;
    int gcdValue = _gcd(numerator, denominator);
    numerator = numerator ~/ gcdValue;
    denominator = denominator ~/ gcdValue;
    return "$numerator/$denominator";
  }

  static int _gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Formats date as "EEEE, MMM d"
  static String formatDay(DateTime dt) =>
      DateFormat('EEEE, MMM d').format(dt.toLocal());

  /// Formats fixture time with relative context (Today, Tomorrow, or date)
  static String formatFixtureTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final fixtureDate = DateTime(dt.year, dt.month, dt.day);
    final formattedTime = DateFormat.Hm().format(dt);

    if (fixtureDate == today) {
      return "Today, $formattedTime";
    } else if (fixtureDate == tomorrow) {
      return "Tomorrow, $formattedTime";
    } else {
      return "${DateFormat('d MMM').format(dt).toUpperCase()}, $formattedTime";
    }
  }
}

class CreateBetOfferPage extends StatefulWidget {
  final H2hGameDetails h2hGameDetails;

  const CreateBetOfferPage({Key? key, required this.h2hGameDetails})
      : super(key: key);

  @override
  State<CreateBetOfferPage> createState() => _CreateBetOfferPageState();
}

class _CreateBetOfferPageState extends State<CreateBetOfferPage> {
  String? _expandedFixtureId;
  String? _selectedSide; // "home" or "away"
  double? _selectedOdds; // Stores (button value - 1.0)
  String? _selectedTeamName;

  // Pre-generate odds list (e.g. buttons showing 1.0, 1.5, 2.0, etc.)
  final List<double> _oddsList =
      List.generate(20, (index) => 0.5 + index * 0.5);

  // Global flag to control odds display format.
  bool _isDecimal = false;

  void _handleOddsTap(double oddValue, String teamName) {
    final double storedValue = oddValue - 1.0;
    setState(() {
      if (_selectedOdds == storedValue) {
        _selectedOdds = null;
      } else {
        _selectedOdds = storedValue;
        _selectedTeamName = teamName;
      }
    });
  }

  void _handleTeamSelection(String fixtureId, String side, String teamName) {
    setState(() {
      if (_expandedFixtureId == fixtureId && _selectedSide == side) {
        // Toggle off if same team selected
        _expandedFixtureId = null;
        _selectedSide = null;
        _selectedOdds = null;
        _selectedTeamName = null;
      } else {
        // Select new team; clear any previously selected odds.
        _expandedFixtureId = fixtureId;
        _selectedSide = side;
        _selectedOdds = null;
        _selectedTeamName = teamName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List<FixtureEntity> fixtures = widget.h2hGameDetails.fixtures
        .where((f) =>
            f.startTime != null &&
            f.startTime!.isAfter(now) &&
            f.gameweekId == widget.h2hGameDetails.currentGameweekId)
        .toList()
      ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

    // Group fixtures by day.
    final Map<String, List<FixtureEntity>> groupedFixtures = {};
    for (var fixture in fixtures) {
      final String day = AppUtils.formatDay(fixture.startTime!);
      groupedFixtures.putIfAbsent(day, () => []).add(fixture);
    }

    // Sort days chronologically.
    final List<String> sortedDays = groupedFixtures.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('EEEE, MMM d').parse(a);
        final dateB = DateFormat('EEEE, MMM d').parse(b);
        return dateA.compareTo(dateB);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bet Offer'),
      ),
      body: Stack(
        children: [
          _buildFixturesList(sortedDays, groupedFixtures),
          _buildFloatingOddsCard(),
          if (_expandedFixtureId != null && _selectedTeamName != null)
            _buildFormatToggleButton(),
        ],
      ),
    );
  }

  Widget _buildFixturesList(List<String> sortedDays,
      Map<String, List<FixtureEntity>> groupedFixtures) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Create Your Bet',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        for (var day in sortedDays) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              day,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...groupedFixtures[day]!.map((fixture) => _buildFixtureCard(fixture)),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildFixtureCard(FixtureEntity fixture) {
    final String fixtureId = fixture.fixtureId ?? UniqueKey().toString();
    final bool isExpanded = _expandedFixtureId == fixtureId;
    final String time = fixture.startTime != null
        ? AppUtils.formatFixtureTime(fixture.startTime!)
        : "TBD";

    final String homeTeamShort =
        TeamNameHelper.getShortenedTeamName(fixture.homeTeamName ?? "Home");
    final String awayTeamShort =
        TeamNameHelper.getShortenedTeamName(fixture.awayTeamName ?? "Away");
    final String homeTeamAcronym =
        TeamData.teamToAcronym[fixture.homeTeamName ?? "Home"] ?? homeTeamShort;
    final String awayTeamAcronym =
        TeamData.teamToAcronym[fixture.awayTeamName ?? "Away"] ?? awayTeamShort;
    final String homeTeamName = fixture.homeTeamName ?? homeTeamShort;
    final String awayTeamName = fixture.awayTeamName ?? awayTeamShort;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(time,
                          style: TextStyle(
                              color: AppColors.lightGrey, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(homeTeamShort,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(awayTeamShort,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTeamButton(
                        homeTeamAcronym,
                        () => _handleTeamSelection(
                            fixtureId, "home", homeTeamName),
                      ),
                      const SizedBox(width: 10),
                      _buildTeamButton(
                        awayTeamAcronym,
                        () => _handleTeamSelection(
                            fixtureId, "away", awayTeamName),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: _oddsSelectionContainer(
              _selectedSide == "home" ? homeTeamName : awayTeamName,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamButton(String acronym, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          acronym,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _oddsSelectionContainer(String teamName) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.3),
        border: Border.all(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select odds for $teamName to WIN',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _oddsList
                    .map((odd) => _buildOddsButton(odd, teamName))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOddsButton(double oddValue, String teamName) {
    final double storedValue = oddValue - 1.0;
    final bool isSelected = _selectedOdds == storedValue;
    final String oddsText = _isDecimal
        ? oddValue.toStringAsFixed(2)
        : AppUtils.decimalToFraction(oddValue);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleOddsTap(oddValue, teamName),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen
              : AppColors.primaryGreen.withOpacity(0.2),
          border: Border.all(color: Colors.green, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          oddsText,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? AppColors.white : AppColors.darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingOddsCard() {
    if (_selectedOdds == null || _selectedTeamName == null) {
      return const SizedBox.shrink();
    }

    // Calculate the selected odd in decimal form: button value (e.g., 1.0)
    final double selectedDecimal = _selectedOdds! + 1.0;
    // Determine the displayed odds text based on the format toggle.
    final String oddsText = _isDecimal
        ? selectedDecimal.toStringAsFixed(1)
        : AppUtils.decimalToFraction(selectedDecimal);

    return Positioned(
      bottom: 32,
      left: 19,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(28),
          color: AppColors.primaryGreen,
          child: InkWell(
            onTap: () {
              if (_expandedFixtureId != null) {
                final betOfferBloc = getIt<BetOfferBloc>();
                betOfferBloc.add(ResetBetOfferStateEvent());

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => HeadToHeadBetslip(
                    fixtureId: _expandedFixtureId!,
                    teamName: _selectedTeamName!,
                    odds: _selectedOdds!,
                    h2hGameDetails: widget.h2hGameDetails,
                  ),
                ).then((result) {
                  if (result != null) {
                    _processBet(result);
                  }
                });
              }
            },
            borderRadius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circle shows the original decimal odd (e.g., 1.0)
                  CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 20,
                    child: Text(
                      selectedDecimal.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Text displays team name and the odds in the chosen format
                  Text(
                    "$_selectedTeamName @ $oddsText",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatToggleButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isDecimal = !_isDecimal;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 14, 118, 46).withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _isDecimal ? "Decimal" : "Fraction",
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _processBet(Map<String, dynamic> betDetails) {
    if (betDetails['success'] == true) {
      final bet = betDetails['bet'];
      final String teamName = _selectedTeamName ?? "selected team";
      final double multiplier = (_selectedOdds ?? 0) + 2.0;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Bet placed on $teamName at odds ${multiplier.toStringAsFixed(1)}'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );

      Navigator.pop(context, betDetails);
    }
  }
}
