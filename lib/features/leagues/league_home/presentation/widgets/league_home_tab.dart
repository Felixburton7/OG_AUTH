import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for URL launching
import 'package:panna_app/core/enums/leagues/league_button_action.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_survivor_rounds_entity.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/confirm_join_league_page.dart';
import 'package:panna_app/features/leagues/league_home/presentation/page/pay_buy_in_page.dart';

class LeagueHomeHomeTab extends StatelessWidget {
  final LeagueDetails leagueDetails;

  const LeagueHomeHomeTab({
    Key? key,
    required this.leagueDetails,
  }) : super(key: key);

  // Team data with assigned crest icons
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

  // Team acronym mapping
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

  @override
  Widget build(BuildContext context) {
    // Extract LeagueEntity from LeagueDetails
    final LeagueEntity? leagueEntity = leagueDetails.league;
    // Print the joinedAt for each member
    for (var member in leagueDetails.leagueMembers) {}

    return Scaffold(
      // Removed AppBar and LMS title
      body: RefreshIndicator(
        onRefresh: () async {
          // Handle refresh if necessary
          // Since it's a StatelessWidget, you might need to call a callback or use a state management solution
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Full-width elements
            children: [
              // 1. Welcome Beta Players Section
              // Card(
              //   elevation: 0,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   color: Theme.of(context).brightness == Brightness.light
              //       ? Colors.white
              //       : Colors.white.withOpacity(0.9),
              //   child: Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: Row(
              //       children: [
              //         // Textual Content
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               const Text(
              //                 'Welcome Beta Players',
              //                 style: TextStyle(
              //                   fontSize: 14.5, // Increased from 13.5 to 14.5
              //                   fontWeight: FontWeight.w600,
              //                   color: Colors.black,
              //                 ),
              //               ),
              //               const SizedBox(height: 5), // Reduced spacing
              //               const Text(
              //                 'This is the main hub for communities, where you can access all games.',
              //                 style: TextStyle(
              //                   fontSize: 13, // Increased from 12 to 13
              //                   color: Colors.black54,
              //                 ),
              //               ),
              //               const SizedBox(height: 6), // Reduced spacing
              //
              //               Align(
              //                 alignment: Alignment.bottomLeft,
              //                 child: TextButton(
              //                   onPressed: () async {
              //                     final Uri url =
              //                         Uri.parse('https://www.panna-app.uk');
              //                     if (await canLaunchUrl(url)) {
              //                       await launchUrl(
              //                         url,
              //                         mode: LaunchMode.externalApplication,
              //                       );
              //                     } else {
              //                       ScaffoldMessenger.of(context).showSnackBar(
              //                         const SnackBar(
              //                           content: Text(
              //                               'Could not launch the website.'),
              //                         ),
              //                       );
              //                     }
              //                   },
              //                   style: TextButton.styleFrom(
              //                     backgroundColor: const Color(
              //                         0xFF008FC2), // Updated to match #008FC2
              //
              //                     padding: const EdgeInsets.symmetric(
              //                       horizontal:
              //                           10, // Adjust horizontal padding for width
              //                       vertical:
              //                           5, // Smaller vertical padding to reduce height
              //                     ),
              //                     minimumSize: Size
              //                         .zero, // Remove default minimum size constraints
              //                     tapTargetSize: MaterialTapTargetSize
              //                         .shrinkWrap, // Reduce touch target size
              //                   ),
              //                   child: const Text(
              //                     'Learn more',
              //                     style: TextStyle(
              //                       fontSize: 13, // Increased from 12 to 13
              //                       color: Colors.white, // White font colour
              //                       fontWeight: FontWeight.w900,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         SizedBox(
              //           width: 120, // Width to accommodate both circles
              //           height: 60,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment
              //                 .center, // Align circles in the centre
              //             crossAxisAlignment: CrossAxisAlignment
              //                 .end, // Align circles vertically
              //             children: [
              //               Image.asset(
              //                 'assets/images/league_home_red_circle2.png',
              //                 width: 60, // Size for circle 2
              //                 height: 60,
              //                 fit: BoxFit.contain,
              //               ),
              //               const SizedBox(
              //                   width:
              //                       5), // Add spacing between the circles
              //               Padding(
              //                 padding: const EdgeInsets.only(
              //                     bottom: 20), // Move circle 1 slightly higher
              //                 child: Image.asset(
              //                   'assets/images/league_home_red_circle1.png',
              //                   width: 40, // Size for circle 1
              //                   height: 40,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //
              // const SizedBox(height: 18),
              //
              // 2. Games Modes Section
              // Container(
              //   padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
              //   child: Text(
              //     'Games',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight
              //           .w900, // Extra-bold (thicker than FontWeight.bold)
              //
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 5),
              //
              GestureDetector(
                onTap: () {
                  context.push(Routes.headToHeadHomePage.path,
                      extra: leagueEntity);
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  child: Container(
                    height: 150, // Adjust the height as needed
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top: Head-to-head image centered horizontally

                        Image.asset(
                          'assets/images/games/head-to-head-green.png',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        // Middle: Title and subtitle texts

                        // Bottom left: "View Game" button
                        ElevatedButton(
                          onPressed: () {
                            context.push(Routes.headToHeadHomePage.path,
                                extra: leagueEntity);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 234, 234, 234),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.play_circle_outline_rounded,
                                  size: 16, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'View Game',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 2.1 Last Man Standing Card with Tap Navigation
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  if (leagueEntity != null) {
                    context.push(
                      Routes.lmsHome.path,
                      extra: leagueEntity,
                    );
                  } else {
                    // Handle null LeagueEntity if necessary
                  }
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: const Color.fromARGB(
                      225, 0, 117, 84), // Changed to specified colour
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // Reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Pot Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/lmsLight.png',
                                  height: 22, // Increased from 21 to 22
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gameweek ${leagueDetails.currentGameweek} Deadline',
                                        style: const TextStyle(
                                          fontSize:
                                              11, // Increased from 11 to 12
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start, // Shift to right
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline
                                            .alphabetic, // Required for baseline alignment
                                        children: [
                                          _buildCountdownSegment(
                                            context,
                                            _formatCountdownNumber(
                                                leagueDetails, 'days'),
                                            'DAYS',
                                          ),
                                          const Text(
                                            ' : ',
                                            style: TextStyle(
                                              fontSize:
                                                  21, // Increased from 20 to 21
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          _buildCountdownSegment(
                                            context,
                                            _formatCountdownNumber(
                                                leagueDetails, 'hours'),
                                            'HOURS',
                                          ),
                                          const Text(
                                            ' : ',
                                            style: TextStyle(
                                              fontSize:
                                                  21, // Increased from 20 to 21
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          _buildCountdownSegment(
                                            context,
                                            _formatCountdownNumber(
                                                leagueDetails, 'minutes'),
                                            'MINS',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                // Money Formatting with different font sizes
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      // Currency Symbol
                                      TextSpan(
                                        text: '£',
                                        style: TextStyle(
                                          fontSize:
                                              19, // Increased from 18 to 19
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // Integer Part of Total Pot
                                      TextSpan(
                                        text:
                                            '${leagueDetails.totalPot.toInt()}',
                                        style: const TextStyle(
                                          fontSize:
                                              30, // Increased from 29 to 30
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      // Decimal Part of Total Pot
                                      TextSpan(
                                        text:
                                            '.${((leagueDetails.totalPot * 100).round() % 100).toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          fontSize:
                                              19, // Increased from 18 to 19
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'POT TOTAL',
                                  style: TextStyle(
                                    fontSize: 11, // Increased from 10 to 11
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Gameweek Deadline and Countdown Timer

                        const SizedBox(height: 8), // Reduced spacing
                        // Buttons Row: "Make selection" and three dots icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Group the buttons in a Row for alignment
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await context.push<bool>(
                                      // Routes.currentMatchesPage.path,
                                      Routes.lmsHome.path,
                                      extra: leagueDetails.league,
                                    );
                                    if (result == true) {
                                      // Handle the result if necessary
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.play_circle_outline_rounded,
                                        size: 16,
                                      ), // First icon
                                      const SizedBox(
                                          width:
                                              8), // Gap between the icon and the text
                                      const Text('View Game'),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 6,
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    textStyle: TextStyle(
                                        fontSize: 14, // Increased from 14 to 15
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                  ),
                                ),
                              ],
                            ),
                            // Add the more_horiz icon at the end
                            GestureDetector(
                              onTap:
                                  null, // Replace with your desired action or leave null for non-interactive
                              child: Container(
                                padding: const EdgeInsets.all(
                                    0), // No padding around the icon
                                width:
                                    40, // Set a fixed width for the container
                                height:
                                    40, // Set a fixed height for the container
                                decoration: BoxDecoration(
                                  color: Colors
                                      .transparent, // No background colour
                                  borderRadius: BorderRadius.circular(
                                      8), // Optional: rounded corners
                                ),
                                child: const Icon(
                                  Icons.more_horiz, // Three dots icon
                                  color: Colors
                                      .white, // Set the icon colour to white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2.2 Removed "Interactive Containers" Section
              // 3. Coming Soon Section
              Card(
                elevation: 0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.white.withOpacity(
                        0.9), // White background for Activity section,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Games coming soon',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height:
                            90, // Adjusted height to better fit images without text
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildComingSoonCard(
                              [
                                Colors.deepPurple,
                                Colors.deepPurple,
                                Colors.purple
                              ],
                              'assets/images/booked.png', // Replace with your image asset
                            ),
                            const SizedBox(width: 12),
                            _buildComingSoonCard(
                              [
                                Colors.blueAccent,
                                Colors.blueAccent,
                                Colors.blueAccent,
                              ],
                              'assets/images/golf_sweepstake.png', // Replace with your image asset
                            ),
                            const SizedBox(width: 12),
                            _buildComingSoonCard(
                              [Colors.teal, Colors.teal, Colors.teal],
                              'assets/images/goalscorer_draft.png', // Replace with your image asset
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 4. Activity Section
              Card(
                elevation: 0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.white.withOpacity(
                        0.9), // White background for Activity section
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Activity Header with Three Dots Icon Inside the Card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'Activity',
                              style: TextStyle(
                                fontSize: 15, // Increased from 14 to 15
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              // Open Activity Modal with Smooth Transition
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 24.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: Column(
                                        children: [
                                          // Modal Header
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'All Activity',
                                                  style: TextStyle(
                                                    fontSize:
                                                        19, // Increased from 18 to 19
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          // Activity Feed
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                child:
                                                    _buildGroupedActivityFeed(
                                                        context, leagueDetails),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildGroupedActivityFeed(context, leagueDetails),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Divider (optional)
              Divider(
                color: Theme.of(context).dividerColor,
                thickness: 1,
              ),

              // Additional spacing at the bottom
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats the countdown number based on the type ('days', 'hours', 'minutes')
  String _formatCountdownNumber(LeagueDetails leagueDetails, String type) {
    final gameweekDeadline = _calculateNextDeadline(leagueDetails);
    final countdownDuration =
        gameweekDeadline.difference(DateTime.now().toUtc());
    switch (type) {
      case 'days':
        return countdownDuration.inDays.toString().padLeft(2, '0');
      case 'hours':
        return (countdownDuration.inHours % 24).toString().padLeft(2, '0');
      case 'minutes':
        return (countdownDuration.inMinutes % 60).toString().padLeft(2, '0');
      default:
        return '00';
    }
  }

  /// Builds a segment of the countdown timer with number and label
  Widget _buildCountdownSegment(
      BuildContext context, String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 21, // Increased from 20 to 21
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
              fontWeight: FontWeight.bold), // Increased from 9 to 10
        ),
      ],
    );
  }

  Widget _buildComingSoonCard(List<Color> gradientColours, String imagePath) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColours,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          height: 63, // Adjusted height to better fit the image
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildGroupedActivityFeed(
      BuildContext context, LeagueDetails leagueDetails) {
    // Combine selections and new members into a single list
    List<dynamic> activities = [];

    // Add recent selections
    activities.addAll(leagueDetails.currentSelections ?? []);

    // Add recent joined members (already filtered to have non-null joinedAt)
    activities.addAll(
        leagueDetails.leagueMembers.where((member) => member.joinedAt != null));

    // Print the joinedAt for each member
    for (var member in leagueDetails.leagueMembers) {}
    // Sort activities by date descending
    activities.sort((a, b) {
      DateTime? aDate;
      DateTime? bDate;

      if (a is SelectionsEntity) {
        aDate = a.selectionDate?.toLocal();
      } else if (a is LeagueMembersEntity) {
        aDate = a.joinedAt?.toLocal();
      }

      if (b is SelectionsEntity) {
        bDate = b.selectionDate?.toLocal();
      } else if (b is LeagueMembersEntity) {
        bDate = b.joinedAt?.toLocal();
      }

      // Handle null dates by placing them at the end
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return bDate.compareTo(aDate);
    });

    // Group activities by day (in local time)
    Map<String, List<dynamic>> groupedActivities = {};

    for (var activity in activities) {
      DateTime? date;
      if (activity is SelectionsEntity) {
        date = activity.selectionDate?.toLocal();
      } else if (activity is LeagueMembersEntity) {
        date = activity.joinedAt?.toLocal();
      }

      if (date == null) {
        // Skip activities without a valid date
        continue;
      }

      String day;
      try {
        // Format the date header
        day = DateFormat('EEEE, dd MMM', 'en_GB').format(date);
      } catch (e) {
        // Fallback formatting
        day = DateFormat('dd MMM', 'en_GB').format(date);
      }

      if (!groupedActivities.containsKey(day)) {
        groupedActivities[day] = [];
      }
      groupedActivities[day]!.add(activity);
    }

    // Sort the date headers in descending order
    final sortedDates = groupedActivities.keys.toList()
      ..sort((a, b) {
        DateTime aDate = DateFormat('EEEE, dd MMM', 'en_GB').parse(a);
        DateTime bDate = DateFormat('EEEE, dd MMM', 'en_GB').parse(b);
        return bDate.compareTo(aDate);
      });

    List<Widget> activityWidgets = [];

    for (var day in sortedDates) {
      // Display the formatted day header
      activityWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
          child: Text(
            day.toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(221, 42, 42, 42),
            ),
          ),
        ),
      );

      for (var activity in groupedActivities[day]!) {
        if (activity is SelectionsEntity) {
          // Find the member who made the selection
          final member = leagueDetails.leagueMembers.firstWhere(
              (m) => m.profileId != null && m.profileId == activity.userId,
              orElse: () => LeagueMembersEntity(
                    firstName: 'Unknown',
                    lastName: '',
                    username: 'unknown',
                    avatarUrl: 'assets/images/default_avatar.png',
                  ));

          // Format the selection time if available
          final String? selectionTime = activity.selectionDate != null
              ? DateFormat('HH:mm', 'en_GB')
                  .format(activity.selectionDate!.toLocal())
              : null;

          activityWidgets.add(
            ListTile(
              leading: _buildAvatar(member),
              title: Text(
                '${member.firstName} ${member.lastName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${member.username}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Submitted selection',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (selectionTime != null)
                    Text(
                      selectionTime,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
          );
        } else if (activity is LeagueMembersEntity) {
          // Since LeagueMembersEntity are already filtered to have joinedAt != null
          final String joinedTime =
              DateFormat('HH:mm', 'en_GB').format(activity.joinedAt!.toLocal());

          activityWidgets.add(
            ListTile(
              leading: _buildAvatar(activity),
              title: Text(
                '${activity.firstName} ${activity.lastName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@${activity.username}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'NEW MEMBER',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    joinedTime,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: activityWidgets,
    );
  }

  /// Figures out the next deadline from league details
  DateTime _calculateNextDeadline(LeagueDetails leagueDetails) {
    if (leagueDetails.currentDeadline != null &&
        leagueDetails.currentDeadline!.isAfter(DateTime.now().toUtc())) {
      return leagueDetails.currentDeadline!;
    }
    // Return current time if no valid deadline is found to prevent errors
    return DateTime.now().toUtc();
  }

  Widget _buildAvatar(LeagueMembersEntity member) {
    final avatarUrl = member.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/images/defaultProfile.png'),
      );
    }
  }
}
