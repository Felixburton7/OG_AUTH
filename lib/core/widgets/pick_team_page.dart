import 'package:flutter/material.dart';

class PickTeamPage extends StatefulWidget {
  const PickTeamPage({super.key});

  @override
  _PickTeamPageState createState() => _PickTeamPageState();
}

class _PickTeamPageState extends State<PickTeamPage> {
  // List of Premier League teams and their corresponding image paths
  final List<Map<String, String>> teams = [
    {'name': 'Newcastle', 'icon': 'assets/images/newcastle_crest.png'},
    {'name': 'Southhampton', 'icon': 'assets/images/southhampton_logo.png'},
    {'name': 'Tottenham', 'icon': 'assets/images/tottenham_crest.png'},
    {
      'name': 'Manchester City',
      'icon': 'assets/images/manchester_city_crest.png'
    },
    {
      'name': 'Manchester United',
      'icon': 'assets/images/manchester_united_crest.png'
    },
    {
      'name': 'Crystal Palace',
      'icon': 'assets/images/crystal_palace_crest.png'
    },
    {'name': 'Aston Villa', 'icon': 'assets/images/aston_villa_crest.png'},
    {'name': 'Bournmouth', 'icon': 'assets/images/bournemouth_crest.png'},
    {'name': 'Liverpool', 'icon': 'assets/images/liverpool_crest.png'},
    {'name': 'Chelsea', 'icon': 'assets/images/chelsea_crest.png'},
    {'name': 'Brentford', 'icon': 'assets/images/brentford_crest.png'},
    {'name': 'Arsenal', 'icon': 'assets/images/arsenal_crest.png'},
    {'name': 'Barcelona', 'icon': 'assets/images/barcelona_crest.png'},
    {'name': 'Real Madrid', 'icon': 'assets/images/real_madrid_crest.png'},
    // {'name': 'Hannover', 'icon': 'assets/images/hannover_crest.png'},
    {'name': 'Dortmund', 'icon': 'assets/images/dortmund_crest.png'},
    {'name': 'Bayern Munich', 'icon': 'assets/images/bayern_munich_crest.png'},
    {'name': 'AC Milan', 'icon': 'assets/images/ac_milan_crest.png'},
    {'name': 'Inter Milan', 'icon': 'assets/images/inter_milan_crest.png'},
    {'name': 'PSG', 'icon': 'assets/images/paris_st_germain_crest.png'},
    // Add more teams here
  ];

  String? selectedTeam; // To keep track of the selected team

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Team'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return ListTile(
                  leading: Image.asset(
                    team['icon']!,
                    width: 40,
                    height: 40,
                  ),
                  title: Text(team['name']!),
                  trailing: selectedTeam == team['name']
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null, // Show check icon if the team is selected
                  onTap: () {
                    setState(() {
                      selectedTeam = team['name']; // Update selected team
                    });
                  },
                );
              },
            ),
          ),
          // Confirm Button
          if (selectedTeam != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle confirmation action here
                  // For example, show a dialog or navigate to another page
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Selection'),
                        content: Text(
                            'You have selected $selectedTeam as your team.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle team selection confirmation
                              Navigator.of(context).pop();
                              // You can save this selection to a database or perform other actions here
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Confirm Selection for $selectedTeam'),
              ),
            ),
        ],
      ),
    );
  }
}
