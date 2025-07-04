import 'package:flutter/material.dart';

//  Text(
//                   GetRoundStartDate(
//                           widget.leagueSummary.nextRoundStartDate)
//                       .getNextRoundText(),
//                   style: TextStyle(fontSize: 16),
//                 ),

class GetRoundStartDate {
  final DateTime roundStartDate;

  GetRoundStartDate(this.roundStartDate);

  // This function returns the text to display for the next round.
  String getNextRoundText() {
    final now = DateTime.now();
    const monday = DateTime.monday;

    final difference = roundStartDate.difference(now).inDays;

    if (difference == 0) {
      return 'Next round starts today';
    } else if (difference == 1) {
      return 'Next round in 1 day';
    } else if (difference > 1) {
      return 'Next round in $difference days';
    } else {
      return 'Round started ${-difference} days ago';
    }
  }
}

class IsGameWeekZero {
  final int? numberOfWeeksActive;

  IsGameWeekZero(this.numberOfWeeksActive);

  // This method returns the appropriate text based on the gameweek status.
  String getGameWeekStatus() {
    if (numberOfWeeksActive == null) {
      return 'Not started yet';
    } else if (numberOfWeeksActive == 0) {
      return 'League Status: ACTIVE';
    } else if (numberOfWeeksActive == 1) {
      return 'Just Started';
    } else {
      return 'Gameweeks underway';
    }
  }

  // This method returns the appropriate styling based on the gameweek status.
  TextStyle getTextStyle() {
    if (numberOfWeeksActive == 0) {
      return const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      );
    } else if (numberOfWeeksActive == null) {
      return const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      );
    } else {
      return const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      );
    }
  }

  // This method returns the appropriate icon based on the gameweek status.
  Icon getIcon() {
    if (numberOfWeeksActive == 0) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 28,
      );
    } else if (numberOfWeeksActive == null) {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 28,
      );
    } else {
      return const Icon(
        Icons.play_circle,
        color: Colors.orange,
        size: 28,
      );
    }
  }
}
