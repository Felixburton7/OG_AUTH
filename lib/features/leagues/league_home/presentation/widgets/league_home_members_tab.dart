/* import 'package:flutter/material.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/league_details/domain/entities/league_members_entity.dart';

/// Displays a vertical list of league members with their profile image and names.
class LeagueHomeMembersTab extends StatelessWidget {
  final LeagueDetails leagueDetails;

  const LeagueHomeMembersTab({
    Key? key,
    required this.leagueDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = leagueDetails.leagueMembers;

    // If there are no members, show a simple message
    if (members.isEmpty) {
      return const Center(
        child: Text('No members found in this league.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Adjusted padding to reduce space between title and list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '${members.length} members',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        // Expanded widget to ensure the ListView takes the remaining space
        Expanded(
          child: ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final LeagueMembersEntity member = members[index];

              // Combine first and last name
              final fullName =
                  '${member.firstName ?? ''} ${member.lastName ?? ''}'.trim();

              // Build fallback text if fullName is empty
              final displayName = fullName.isNotEmpty ? fullName : 'Unknown Member';

              return ListTile(
                leading: _buildAvatar(member),
                title: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Subtitle can show username or any other extra info
                subtitle: Text(member.username ?? 'No username'),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the avatar for each member, defaulting to a placeholder if `avatarUrl` is null or empty.
  Widget _buildAvatar(LeagueMembersEntity member) {
    final avatarUrl = member.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/images/placeholder_avatar.png'),
      );
    }
  }
}
 */

import 'package:flutter/material.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';

class LeagueHomeMembersTab extends StatelessWidget {
  final LeagueDetails leagueDetails;

  const LeagueHomeMembersTab({
    Key? key,
    required this.leagueDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = leagueDetails.leagueMembers;

    if (members.isEmpty) {
      return const Center(
        child: Text('No members found in this league.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with reduced vertical padding
        Padding(
          padding: const EdgeInsets.fromLTRB(
              16.0, 8.0, 16.0, 4.0), // Reduced bottom padding
          child: Text(
            '${members.length} members',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ),
        // List of members
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 0), // Ensure no top padding
            itemCount: members.length,
            itemBuilder: (context, index) {
              final LeagueMembersEntity member = members[index];
              final fullName =
                  '${member.firstName ?? ''} ${member.lastName ?? ''}'.trim();
              final displayName =
                  fullName.isNotEmpty ? fullName : 'Unknown Member';

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    leading: _buildAvatar(member),
                    title: Text(
                      displayName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    subtitle: Text(
                      member.username ?? 'No username',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: Theme.of(context).hintColor),
                    ),
                  ),
                  // Add a divider between items
                  if (index < members.length - 1)
                    Divider(
                      color: Theme.of(context).focusColor,
                      height: 1,
                      thickness: 1,
                      indent: 20.0, // Align with ListTile content
                      endIndent: 20.0,
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(LeagueMembersEntity member) {
    final avatarUrl = member.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/images/defaultProfile.png'),
      );
    }
  }
}
