import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ClubPicker extends StatelessWidget {
  final String selectedTeam;
  final Function(String) onTeamSelected;

  const ClubPicker({
    Key? key,
    required this.selectedTeam,
    required this.onTeamSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    final Map<String, String> teamToAcronym = {
      'Arsenal': 'ARS',
      'AFC Bournemouth': 'BHA',
      'Brentford': 'BRE',
      'Brighton & Hove Albion': 'BHA',
      'Chelsea': 'CHE',
      'Everton': 'EVE',
      'Nottingham Forest': 'NFO',
      'Fulham': 'FUL',
      'Ipswich Town': 'IPS',
      'Leicester City': 'LEI',
      'Liverpool': 'LIV',
      'Manchester City': 'MCL',
      'Manchester United': 'MUN',
      'Newcastle United': 'NEW',
      'Crystal Palace': 'CRY',
      'Southampton': 'SOU',
      'Tottenham Hotspur': 'TOT',
      'Aston Villa': 'AVL',
      'West Ham United': 'WHU',
      'Wolverhampton Wanderers': 'WOL',
    };

    List<Map<String, String>> teams = teamToCrest.entries
        .map((entry) => {
              'fullName': entry.key,
              'shortName': teamToAcronym[entry.key] ?? '',
              'icon': entry.value,
            })
        .toList();

    Map<String, String>? selectedTeamItem = selectedTeam.isNotEmpty
        ? teams.firstWhere(
            (team) =>
                team['fullName'] == selectedTeam, // Match with full team name
            orElse: () => {
              'fullName': 'Pick Team',
              'shortName': '',
              'icon': 'assets/images/default_team_icon.png',
            },
          )
        : null;

    return DropdownSearch<Map<String, String>>(
      items: teams,
      selectedItem: selectedTeamItem,
      itemAsString: (Map<String, String>? team) => team?['fullName'] ?? '',
      dropdownBuilder: (context, selectedItem) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              if (selectedItem != null && selectedItem['icon'] != null)
                Image.asset(
                  selectedItem['icon']!,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.sports_soccer);
                  },
                )
              else
                const Icon(Icons.sports_soccer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedItem != null && selectedItem['fullName'] != 'Pick Team'
                      ? selectedItem['fullName']!
                      : 'Pick Team',
                ),
              ),
            ],
          ),
        );
      },
      compareFn: (item, selectedItem) =>
          item['fullName'] == selectedItem['fullName'],
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: false,
        constraints: const BoxConstraints(
          maxHeight: 300,
        ),
        containerBuilder: (ctx, popupWidget) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: popupWidget,
          );
        },
        itemBuilder: (context, team, isSelected) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              leading: team['icon'] != null
                  ? Image.asset(
                      team['icon']!,
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.sports_soccer);
                      },
                    )
                  : const Icon(Icons.sports_soccer),
              title: Text(team['fullName']!),
            ),
          );
        },
      ),
      onChanged: (Map<String, String>? newValue) {
        if (newValue != null) {
          onTeamSelected(newValue['fullName']!); // Send full name to backend
        }
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

