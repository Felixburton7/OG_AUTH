import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/chat/domain/entities/messages.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';

class LeagueHeader extends StatelessWidget {
  final LeagueDetails leagueDetails;
  final VoidCallback onBackPressed;

  const LeagueHeader({
    Key? key,
    required this.leagueDetails,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          child: FadeInImage(
            placeholder:
                const AssetImage('assets/images/default_league_avatar.png'),
            image: leagueDetails.league.leagueAvatarUrl != null
                ? NetworkImage(leagueDetails.league.leagueAvatarUrl!)
                : const AssetImage('assets/images/default_league_avatar.png'),
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/default_league_avatar.png',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          top: 40,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: onBackPressed,
          ),
        ),
        Positioned(
          top: 40,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed: () async {
              final userId = Supabase.instance.client.auth.currentUser?.id;
              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You must be logged in to access the chat.'),
                  ),
                );
                return;
              }

              final leagueId = leagueDetails.league.leagueId;
              if (leagueId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('League ID is null. Cannot access chat.'),
                  ),
                );
                return;
              }

              final response = await Supabase.instance.client
                  .from('league_group_chat')
                  .select()
                  .eq('league_id', leagueId)
                  .maybeSingle();

              if (response == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat room not found for this league.'),
                  ),
                );
                return;
              }

              final groupChat = GroupChat.fromJson(response);
              context.push(
                Routes.chatRoomPage.path,
                extra: groupChat,
              );
            },
          ),
        ),
      ],
    );
  }
}
