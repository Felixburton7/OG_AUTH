import 'package:flutter/material.dart';

class LmsRulesPage extends StatelessWidget {
  const LmsRulesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Grab color scheme and text theme from your app_theme
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LMS Rules',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              // 1) Joining a League
              _RuleItem(
                ruleNumber: 1,
                icon: Icons.group,
                title: 'Joining a League',
                description:
                    'Join any time to see chat & members, but pay before the first match of the week to compete in LMS. '
                    'Make sure you have enough funds. No refunds, one entry per game.',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              // 2) Team Selection
              _RuleItem(
                ruleNumber: 2,
                icon: Icons.sports_soccer,
                title: 'Team Selection',
                description:
                    'Pick one team per gameweek. You can’t reuse the same team later. '
                    'Finalise picks one hour pre-kickoff or be eliminated. Picks stay hidden until deadline.',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              // 3) Winning & Elimination
              _RuleItem(
                ruleNumber: 3,
                icon: Icons.sports_score,
                title: 'Winning & Elimination',
                description:
                    'Win to advance; lose or draw and you’re out. Only 90 mins + stoppage time counts. '
                    'Keep track of other members’ progress on the live leaderboard.',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              // 4) Pot Distribution
              _RuleItem(
                ruleNumber: 4,
                icon: Icons.paid,
                title: 'Pot Distribution',
                description:
                    'Last player standing takes the pot. If everyone falls together, it’s split. '
                    'Survivors at the season’s end also share equally.',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              // 5) Special Situations
              _RuleItem(
                ruleNumber: 5,
                icon: Icons.help_center,
                title: 'Special Situations',
                description:
                    'If a match is postponed or canceled, you automatically progress. '
                    'Abandoned fixtures also let you advance.',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single row item showing the rule number, an icon, and the rule description.
class _RuleItem extends StatelessWidget {
  final int ruleNumber;
  final IconData icon;
  final String title;
  final String description;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _RuleItem({
    Key? key,
    required this.ruleNumber,
    required this.icon,
    required this.title,
    required this.description,
    required this.colorScheme,
    required this.textTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Spacing between rule items
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular container with rule number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary, // Matches your theme’s primary
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$ruleNumber',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Rule content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: colorScheme.secondary),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
