// // confirm_join_league_bottom_sheet.dart
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:panna_app/core/utils/underlined_text_stack.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

class ConfirmJoinLeagueBottomSheet extends StatefulWidget {
  final LeagueDetails leagueDetails;
  final VoidCallback onJoinSuccess;

  const ConfirmJoinLeagueBottomSheet({
    Key? key,
    required this.leagueDetails,
    required this.onJoinSuccess,
  }) : super(key: key);

  @override
  _ConfirmJoinLeagueBottomSheetState createState() =>
      _ConfirmJoinLeagueBottomSheetState();
}

class _ConfirmJoinLeagueBottomSheetState
    extends State<ConfirmJoinLeagueBottomSheet> {
  bool _isLoading = false;

  void _showJoinSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully joined the league'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _joinLeague() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final repository = getIt<ManageLeaguesRepository>();
      await repository.joinLeague(widget.leagueDetails.league.leagueId!);
      // Log event for successful join
      getIt<FirebaseAnalyticsService>().logEvent('league_joined', parameters: {
        'league_id': widget.leagueDetails.league.leagueId,
        'league_title': widget.leagueDetails.league.leagueTitle,
        'username': widget.leagueDetails.userProfile.username,
        'Full Name': {
          'first_name': widget.leagueDetails.userProfile.firstName,
          'last_name': widget.leagueDetails.userProfile.lastName
        },
      });
      _showJoinSuccessSnackbar(context);
      widget.onJoinSuccess();
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join the league: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final potTotal =
        '£${widget.leagueDetails.leagueSurvivorRounds.firstWhereOrNull((round) => round.isActiveStatus!)?.potTotal?.toStringAsFixed(2) ?? '0.00'}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Transform.scale(
              scaleX: 1,
              scaleY: 1.0,
              child: const Text(
                'Confirm Join League',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _joinLeague,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Join League',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: UnderlinedTextStack(
                  text: 'Cancel',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.black,
                  underlineColor:
                      Theme.of(context).textTheme.bodyMedium?.color ??
                          Colors.black,
                  underlineThickness: 7.0,
                  spacing: 6.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:panna_app/core/utils/underlined_text_stack.dart';
// import 'package:panna_app/core/value_objects/leagues/league_details.dart';
// import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';
// import 'package:panna_app/dependency_injection.dart';

// class ConfirmJoinLeagueBottomSheet extends StatefulWidget {
//   final LeagueDetails leagueDetails;
//   final VoidCallback onJoinSuccess;

//   const ConfirmJoinLeagueBottomSheet({
//     Key? key,
//     required this.leagueDetails,
//     required this.onJoinSuccess,
//   }) : super(key: key);

//   @override
//   _ConfirmJoinLeagueBottomSheetState createState() =>
//       _ConfirmJoinLeagueBottomSheetState();
// }

// class _ConfirmJoinLeagueBottomSheetState
//     extends State<ConfirmJoinLeagueBottomSheet> {
//   bool _isLoading = false;

//   // Method to show success snackbar
//   void _showJoinSuccessSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('You have successfully joined the league'),
//         duration: Duration(seconds: 3),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   Future<void> _joinLeague() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final repository = getIt<ManageLeaguesRepository>();
//       await repository.joinLeague(widget.leagueDetails.league.leagueId!);
//       _showJoinSuccessSnackbar(context);
//       widget.onJoinSuccess();
//       Navigator.of(context).pop(); // Close the bottom sheet
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to join the league: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Extract necessary details
//     final potTotal =
//         '£${widget.leagueDetails.leagueSurvivorRounds.firstWhereOrNull((round) => round.isActiveStatus!)?.potTotal?.toStringAsFixed(2) ?? '0.00'}';

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
//       child: SingleChildScrollView(
//         // To ensure the bottom sheet is scrollable if content overflows
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             // Title
//             Transform.scale(
//               scaleX: 1,
//               scaleY: 1.0,
//               child: const Text(
//                 'Confirm Join League',
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const SizedBox(height: 30),
//             // Join League Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _joinLeague,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       Theme.of(context).colorScheme.primary, // Adapts to theme
//                   foregroundColor:
//                       Theme.of(context).colorScheme.onPrimary, // Text color
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         'Join League',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // "Cancel" Link
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the bottom sheet
//                 },
//                 child: UnderlinedTextStack(
//                   text: 'Cancel',
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   textColor: Theme.of(context).textTheme.bodyMedium?.color ??
//                       Colors.black,
//                   underlineColor:
//                       Theme.of(context).textTheme.bodyMedium?.color ??
//                           Colors.black,
//                   underlineThickness: 7.0,
//                   spacing: 6.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:panna_app/core/utils/get_round_start_date.dart';
// import 'package:panna_app/core/value_objects/leagues/league_details.dart';
// import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
// import 'package:panna_app/dependency_injection.dart';
// import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

// class ConfirmJoinLeaguePage extends StatefulWidget {
//   final LeagueDetails leagueDetails;

//   const ConfirmJoinLeaguePage({super.key, required this.leagueDetails});

//   @override
//   State<ConfirmJoinLeaguePage> createState() => _ConfirmJoinLeagueState();
// }

// class _ConfirmJoinLeagueState extends State<ConfirmJoinLeaguePage> {
//   // Method to show success snackbar
//   void _showPaymentSnackbar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('You have successfully joined the league round'),
//         duration: Duration(seconds: 3),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Confirm Join League'),
//         elevation: 1,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'League Summary',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 15),

//             // Horizontally scrollable league information
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildInfoCard(
//                       'Mutuals', '${widget.leagueDetails.mutualMemberCount}'),
//                   _buildInfoCard('Buy-In',
//                       '£${widget.leagueDetails.league.buyIn?.toStringAsFixed(2) ?? '0'}'),
//                   _buildInfoCard('Pot Total',
//                       '£${widget.leagueDetails.totalPot?.toStringAsFixed(2) ?? '0'}'),
//                   _buildInfoCard(
//                       'Members', '${widget.leagueDetails.memberCount}'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 25),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'League Status: ACTIVE',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 Icon(
//                   Icons.check_circle,
//                   color: Colors.green,
//                   size: 28,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             const Text(
//               'A round has recently concluded, or the league has just begun. Pay the buy-in before the deadline to join this round.',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 15),

//             // Deadline Information
//             Card(
//               elevation: 1,
//               color: Colors.orange[50],
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'DEADLINE:',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 10),

//                     // Handle null check for `nextRoundStartDate`
//                     Text(
//                       widget.leagueDetails.nextRoundStartDate != null
//                           ? GetRoundStartDate(
//                                   widget.leagueDetails.nextRoundStartDate!)
//                               .getNextRoundText()
//                           : 'No upcoming round date available',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'You won’t be able to join after this round’s deadline has passed.',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             Text(
//               'Join now to be eligible to win the pot total of £${widget.leagueDetails.totalPot?.toStringAsFixed(2) ?? '0'}.',
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Spacer(),

//             // Join League Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     final repository = getIt<ManageLeaguesRepository>();
//                     await repository
//                         .joinLeague(widget.leagueDetails.league.leagueId!);
//                     _showPaymentSnackbar(context);
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Failed to join the league: $e')),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 18),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Join League',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper method to build each info card
//   Widget _buildInfoCard(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 5),
//       child: Card(
//         elevation: 1,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Container(
//           width: 110,
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }