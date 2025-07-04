import 'package:flutter/material.dart';
import 'package:panna_app/core/constants/colors.dart';

class HeadToHeadRulesPage extends StatelessWidget {
  const HeadToHeadRulesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Rules & How to Play",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Game Concept
          _buildRuleSection(
            context,
            Icons.sports_soccer,
            "Head to Head Concept",
            "Create your own betting markets and challenge other players. You set the odds, they pick the opposite team.",
          ),

          // How to Create Bets
          _buildRuleSection(
            context,
            Icons.add_circle,
            "Creating Bets",
            "1. Select a match\n2. Choose your team to win\n3. Set odds for your bet\n4. Stake your money\n\nYour bet offer will appear in the 'Popular' tab for others to challenge.",
          ),

          // How to Accept Bets
          _buildRuleSection(
            context,
            Icons.handshake,
            "Accepting Challenges",
            "1. Browse existing bet offers in the 'Popular' tab\n2. Select a bet you want to challenge\n3. You'll be betting on the opposite team\n4. Match the stake amount\n\nThe bet creator must accept your challenge before it's valid.",
          ),

          // Bet Confirmation
          _buildRuleSection(
            context,
            Icons.check_circle,
            "Bet Confirmation",
            "• Bet creators must confirm or decline each challenge\n• Once accepted, the bet is locked and cannot be cancelled\n• Stakes are held securely until the match is settled",
          ),

          // Winnings & Payouts
          _buildRuleSection(
            context,
            Icons.monetization_on,
            "Winnings & Payouts",
            "• Winner takes the total pot (both stakes minus platform fee)\n• Bets are settled automatically after match completion\n• Winnings are added directly to your account balance\n• Draws result in both stakes being returned minus fees",
          ),

          // Odds Explanation
          _buildRuleSection(
            context,
            Icons.calculate,
            "Understanding Odds",
            "• Odds represent your potential payout multiplier\n• Example: x2.0 means you'll double your stake if you win\n• Higher odds (x2.5, x3.0, etc.) reflect a less likely outcome\n• You set the odds when creating a bet",
            withDivider: false,
          ),

          const SizedBox(height: 20),

          // Example box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Example:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: "You create a bet on "),
                      TextSpan(
                        text: "Liverpool to win",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " against Man City with "),
                      TextSpan(
                        text: "odds of x2.0",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " and a "),
                      TextSpan(
                        text: "£10 stake",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: ".\n\nSomeone challenges your bet, backing "),
                      TextSpan(
                        text: "Man City",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " with a matching "),
                      TextSpan(
                        text: "£10 stake",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ".\n\nIf Liverpool wins, you receive "),
                      TextSpan(
                        text: "£20",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      TextSpan(
                          text:
                              " (your stake + your winnings).\n\nIf Man City wins, your challenger receives "),
                      TextSpan(
                        text: "£20",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      TextSpan(text: " (their stake + their winnings)."),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Terms and Conditions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                const Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Please gamble responsibly. All bets are subject to the Panna App Terms of Service. Users must be 18+ to participate in Head to Head betting.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRuleSection(
      BuildContext context, IconData icon, String title, String content,
      {bool withDivider = true}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (withDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
          ),
      ],
    );
  }
}
