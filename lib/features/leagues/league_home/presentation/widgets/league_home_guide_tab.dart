import 'package:flutter/material.dart';
import 'package:panna_app/core/constants/colors.dart';

/// A simple tab that explains how to navigate the league home,
/// how to pay the buy in, and how to join a game.
class LeagueHomeGuideTab extends StatelessWidget {
  const LeagueHomeGuideTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          const Text(
            'Guide to Joining Games',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Section 1: Game Card
          Row(
            children: const [
              Icon(Icons.gamepad, size: 24, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Click on the Game Card',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Text(
              'Click on the game card to enter that game.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),

          // Section 2: Game Status
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.access_time, size: 24, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Check the current status of the Game',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Text(
              'Check if there is an ongoing round. If you cannot pay the buy in, it will display "ongoing round". '
              'When the week is in progress, you won\'t be able to join and selections will be blocked.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),

          // Section 3: Pay Buy In
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.payment, size: 24, color: AppColors.grey700),
              SizedBox(width: 8),
              Text(
                'Pay Buy In and Join Round',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Text(
              'If a round is available to join, click "Pay Buy In". '
              'You will need to have enough funds in your account balance. '
              'Once you have paid the buy in, make your selection to start the game. '
              'For game modes other than LMS, follow the specific instructions provided.',
              style: TextStyle(fontSize: 14, color: AppColors.grey700),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
