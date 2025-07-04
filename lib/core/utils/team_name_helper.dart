class TeamNameHelper {
  static const Map<String, String> teamNameMappings = {
    'Newcastle United': 'Newcastle',
    'Wolverhampton Wanderers': 'Wolves',
    'Tottenham Hotspur': 'Tottenham',
    'West Ham United': 'West Ham',
    'Nottingham Forest': 'Nottingham',
    'AFC Bournemouth': 'Bournemouth',
    'Brighton & Hove Albion': 'Brighton',
    'Manchester United': 'Man United',
    'Manchester City': 'Man City',
  };

  /// Function to get the shortened team name if available, otherwise return the original name
  static String getShortenedTeamName(String teamName) {
    return teamNameMappings[teamName] ?? teamName;
  }
}
