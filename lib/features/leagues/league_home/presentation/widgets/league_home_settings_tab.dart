// league_home_settings_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:intl/intl.dart'; // For date formatting
import 'package:panna_app/core/router/navigation/bottom_navigator/cubit/bottom_navigation_bar_cubit.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/leagues/league_home/presentation/bloc/details/league_details_bloc.dart';

/// Simple tab for reporting or leaving/deleting a league.
class LeagueHomeSettingsTab extends StatelessWidget {
  final LeagueDetails leagueDetails;

  const LeagueHomeSettingsTab({
    Key? key,
    required this.leagueDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract admin usernames
    final adminUsernames = leagueDetails.leagueMembers
        .where((member) => member.admin == true)
        .map((member) => member.username ?? 'Unknown')
        .toList();

    // Join usernames with commas if multiple admins exist
    final adminUsernamesStr =
        adminUsernames.isNotEmpty ? adminUsernames.join(', ') : 'Unknown';

    // Find the earliest joinedAt date as the league creation date
    DateTime? leagueCreationDate;
    if (leagueDetails.leagueMembers.isNotEmpty) {
      leagueCreationDate = leagueDetails.leagueMembers
          .where((member) => member.joinedAt != null)
          .map((member) => member.joinedAt!)
          .reduce((a, b) => a.isBefore(b) ? a : b);
    }

    // Format the date (or fallback if null)
    final formattedDate = leagueCreationDate != null
        ? DateFormat('dd/MM/yyyy').format(leagueCreationDate)
        : 'Unknown Date';

    // Debug prints (optional)
    print('Admin Usernames: $adminUsernamesStr');
    print('League Creation Date: $formattedDate');

    // Determine if the current user is an admin
    final isAdmin = leagueDetails.isAdmin;

    // Set the button label based on admin status
    final leaveButtonLabel = isAdmin ? 'Delete League' : 'Leave League';

    // Set the confirmation title and detailed message based on admin status.
    final confirmationTitle = isAdmin ? 'Delete League' : 'Leave League';
    final confirmationMessage = isAdmin
        ? 'As the admin, if you delete the league, your admin privileges will be transferred to the league member who has been in the league the longest. If no other members are present, the league will be permanently deleted. Please confirm your action.'
        : 'By leaving the league, you will lose access to all league updates and features. Your membership will be removed and you will no longer be part of this league. Please confirm if you wish to proceed.';

    // Function to handle leave/delete action with a custom full-screen pop-up
    void _handleLeaveLeague(BuildContext context) async {
      final shouldProceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // User must tap a button
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(confirmationTitle,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Explanation message inside a scrollable area
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(confirmationMessage,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons aligned to the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancel
                        },
                        child: const Text('Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirm
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Confirm',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (shouldProceed == true) {
        // Dispatch LeaveLeagueEvent
        print(
            'UI: Dispatching LeaveLeagueEvent for League ID: ${leagueDetails.leagueId}');
        context.read<LeagueDetailsBloc>().add(
              LeaveLeagueEvent(
                leagueId: leagueDetails.leagueId,
              ),
            );

        // Navigate to the initial route.
        context.push(Routes.initial.path);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title: League Settings
          const Text(
            'League Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// Privacy Indicator (Private/Public)
          Row(
            children: [
              Icon(
                leagueDetails.leagueIsPrivate ? Icons.lock : Icons.lock_open,
                size: 24,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                leagueDetails.leagueIsPrivate ? 'Private' : 'Public',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              leagueDetails.leagueIsPrivate
                  ? 'Only members with a private league code can join and see who’s in the group.'
                  : 'Anyone can join and view the members of this league.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// Divider between privacy and history
          const Divider(),
          const SizedBox(height: 16),

          /// History Section
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 24,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              'This league was created by @$adminUsernamesStr on $formattedDate',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// Copy Invite Code Section
          if (leagueDetails.leagueIsPrivate || !leagueDetails.leagueIsPrivate)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Copy addCode to clipboard
                    if (leagueDetails.league.addCode != null) {
                      Clipboard.setData(
                        ClipboardData(text: leagueDetails.league.addCode!),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invite code copied to clipboard!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No invite code available.'),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.copy, size: 24, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Copy Invite Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: Text(
                    'Share this code to invite others to join the league.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
              ],
            ),

          /// Admin Panel Button (Visible only to admins)
          if (isAdmin)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  label: const Text('Go to Admin Panel'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the admin panel using GoRouter
                    context.push(
                      Routes.leagueAdminPanel.path,
                      extra: leagueDetails,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),

          /// Divider before action buttons
          const Divider(),
          const SizedBox(height: 16),

          /// Buttons: Report + Leave/Delete
          Center(
            child: Column(
              children: [
                /// Report League Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('League reported.')),
                      );
                    },
                    child: const Text(
                      'Report League',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Leave/Delete League Button
                BlocBuilder<LeagueDetailsBloc, LeagueDetailsState>(
                  builder: (context, state) {
                    final isLoading = state is LeaveLeagueLoading;
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                _handleLeaveLeague(context);
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              )
                            : Text(
                                leaveButtonLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
