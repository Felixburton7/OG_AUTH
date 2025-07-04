import 'package:flutter/material.dart';

class BuildCrestRow extends StatelessWidget {
  final String? teamName;
  const BuildCrestRow({super.key, this.teamName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> teams = [
      {'name': 'Newcastle', 'icon': 'assets/images/newcastle_crest.png'},
      {'name': 'Arsenal', 'icon': 'assets/images/arsenal.png'},
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
      {'name': 'Wolves', 'icon': 'assets/images/wolves.png'},
      {'name': 'Barcelona', 'icon': 'assets/images/barcelona_crest.png'},
      {'name': 'Real Madrid', 'icon': 'assets/images/real_madrid_crest.png'},
      {'name': 'Dortmund', 'icon': 'assets/images/dortmund_crest.png'},
      {
        'name': 'Bayern Munich',
        'icon': 'assets/images/bayern_munich_crest.png'
      },
      {'name': 'AC Milan', 'icon': 'assets/images/ac_milan_crest.png'},
      {'name': 'Inter Milan', 'icon': 'assets/images/inter_milan_crest.png'},
      {'name': 'PSG', 'icon': 'assets/images/paris_st_germain_crest.png'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 100, // Set a fixed height for the row
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Image.asset(
                    teams[index]['icon']!,
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    teams[index]['name']!,
                    style: Theme.of(context).textTheme.bodySmall,
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
// 