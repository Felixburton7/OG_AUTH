// team_logo_cell.dart

import 'package:flutter/material.dart';

class TeamLogoCell extends StatelessWidget {
  final String teamName;
  final Map<String, String> teamToCrest;

  const TeamLogoCell({
    Key? key,
    required this.teamName,
    required this.teamToCrest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: teamName != 'N/A'
          ? Image.asset(
              teamToCrest[teamName] ?? 'assets/images/default_crest.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Display default crest if the asset is missing
                return Image.asset(
                  'assets/images/default_crest.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                );
              },
              semanticLabel: '$teamName Crest',
            )
          : const Icon(
              Icons.help_outline,
              color: Colors.grey,
              size: 24,
              semanticLabel: 'No Selection Made',
            ),
    );
  }
}
