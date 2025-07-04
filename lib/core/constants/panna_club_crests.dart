import 'package:flutter/material.dart';

class PannaCrestRow extends StatelessWidget {
  const PannaCrestRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Team data with assigned crest icons
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

    // Team acronym mapping
    final Map<String, String> teamToAcronym = {
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

    // Define custom background colors for specific teams
    Color getCircleColor(String teamName) {
      if ([
        'Chelsea',
        'Brighton & Hove Albion',
        'Everton',
        'Manchester City',
        'Crystal Palace',
        'Tottenham Hotspur',
      ].contains(teamName)) {
        return Colors.blue.shade900; // Darker blue
      } else if ([
        'Arsenal',
        'Manchester United',
        'Southampton',
        'West Ham United',
        'Brentford',
        'Nottingham Forest',
        'AFC Bournemouth',
        // 'Nottingham Forest',
      ].contains(teamName)) {
        return Colors.red.shade900; // Darker red
      } else {
        return Colors.grey.shade800; // Black for other teams
      }
    }

    // Ensure that no two consecutive teams have the same background color
    Color lastCircleColor = Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 90, // Adjust height to fit the crests and abbreviations
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: teamToCrest.length,
          itemBuilder: (context, index) {
            String teamName = teamToCrest.keys.elementAt(index);
            String teamCrest = teamToCrest[teamName]!;
            String teamAcronym = teamToAcronym[teamName]!;

            // Get the circle color for each team
            Color circleColor = getCircleColor(teamName);

            // Check if the current color matches the previous one
            if (circleColor == lastCircleColor) {
              // Swap color to prevent two consecutive same-colored circles
              circleColor = circleColor == Colors.black87
                  ? Colors.red.shade900
                  : Colors.black87;
            }

            // Set the last used color to the current one
            lastCircleColor = circleColor;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  // Circle with crest inside
                  Container(
                    width: 50, // Reduced width for smaller circles
                    height: 50, // Reduced height for smaller circles
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: circleColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        teamCrest,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Team acronym below the crest
                  Text(
                    teamAcronym,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black, // Black text for acronyms
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
