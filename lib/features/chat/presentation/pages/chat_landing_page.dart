import 'package:flutter/material.dart';
import 'package:panna_app/core/router/navigation/nav_drawer_navigator/navigation_drawer.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/chat/domain/entities/messages.dart';
import 'package:panna_app/features/chat/presentation/pages/chat_room_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatLandingPage extends StatefulWidget {
  const ChatLandingPage({super.key});

  @override
  _ChatLandingPageState createState() => _ChatLandingPageState();
}

class _ChatLandingPageState extends State<ChatLandingPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<GroupChat> _groupChats = [];
  Map<String, String> _leagueTitles = {};
  Map<String, String?> _leagueAvatars = {};
  Map<String, ChatMessage> _latestMessages = {};
  Map<String, int> _unreadCounts = {}; // Store unread counts per chat

  @override
  void initState() {
    super.initState();
    // Log screen view after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final analyticsService = getIt<FirebaseAnalyticsService>();
      analyticsService.setCurrentScreen('ChatLandingPage');
      analyticsService.logEvent('view_chat_landing');
    });
    _fetchGroupChats();
  }

  Future<void> _fetchGroupChats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User ID is null');

      // Fetch leagues the user is in.
      final privateLeaguesUserIsIn = await Supabase.instance.client
          .from('league_members')
          .select('league_id')
          .eq('profile_id', userId);
      if (privateLeaguesUserIsIn == null || privateLeaguesUserIsIn.isEmpty) {
        throw Exception('Error fetching league IDs or no leagues found');
      }
      final List leagueIds = privateLeaguesUserIsIn;
      final List<String> leagueIdList =
          leagueIds.map((entry) => entry['league_id'] as String).toList();

      if (leagueIdList.isNotEmpty) {
        // Fetch league titles and avatars.
        final leaguesResponse = await Supabase.instance.client
            .from('leagues')
            .select('league_id, league_title, league_avatar_url')
            .inFilter('league_id', leagueIdList);
        if (leaguesResponse == null || leaguesResponse.isEmpty) {
          throw Exception('Error fetching league titles or no titles found');
        }
        for (var league in leaguesResponse) {
          _leagueTitles[league['league_id']] = league['league_title'];
          _leagueAvatars[league['league_id']] = league['league_avatar_url'];
        }

        // Fetch group chats.
        final groupChatsResponse = await Supabase.instance.client
            .from('league_group_chat')
            .select()
            .inFilter('league_id', leagueIdList);
        if (groupChatsResponse == null || groupChatsResponse.isEmpty) {
          throw Exception('Error fetching group chats or no group chats found');
        }
        final List<GroupChat> groupChats = (groupChatsResponse as List)
            .map((data) => GroupChat.fromJson(data))
            .toList();

        // For each group chat, fetch the latest message and unread count.
        for (var chat in groupChats) {
          // Latest message.
          final latestMessageResponse = await Supabase.instance.client
              .from('league_chat_messages')
              .select()
              .eq('group_chat_id', chat.id)
              .order('created_at', ascending: false)
              .limit(1)
              .maybeSingle();
          if (latestMessageResponse != null) {
            _latestMessages[chat.id] = ChatMessage.fromJson(
                map: latestMessageResponse, myUserId: userId);
          }

          // Get the last read timestamp for this chat.
          final readStatusResponse = await Supabase.instance.client
              .from('league_chat_read_status')
              .select('last_read_at')
              .eq('group_chat_id', chat.id)
              .eq('profile_id', userId)
              .maybeSingle();
          DateTime lastReadAt = DateTime.fromMillisecondsSinceEpoch(0);
          if (readStatusResponse != null &&
              readStatusResponse['last_read_at'] != null) {
            lastReadAt = DateTime.parse(readStatusResponse['last_read_at']);
          }

          // Count messages in the chat that were created after the last read timestamp.
          final unreadResponse = await Supabase.instance.client
              .from('league_chat_messages')
              .select('message_id')
              .eq('group_chat_id', chat.id)
              .gt('created_at', lastReadAt);
          _unreadCounts[chat.id] = (unreadResponse as List).length;
        }

        setState(() {
          _groupChats = groupChats;
        });
      } else {
        setState(() {
          _groupChats = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch group chats. Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchGroupChats,
              child: Column(
                children: [
                  Expanded(
                    child: _groupChats.isEmpty
                        ? const Center(child: Text('No group chats found.'))
                        : ListView.builder(
                            itemCount: _groupChats.length,
                            itemBuilder: (context, index) {
                              final chat = _groupChats[index];
                              return GroupChatView(
                                chat: chat,
                                leagueTitle:
                                    _leagueTitles[chat.leagueId] ?? 'Unknown',
                                latestMessage:
                                    _latestMessages[chat.id]?.content ??
                                        'No messages yet',
                                latestMessageTime:
                                    _latestMessages[chat.id]?.createdAt ??
                                        DateTime.now(),
                                leagueAvatarUrl: _leagueAvatars[chat.leagueId],
                                unreadCount: _unreadCounts[chat.id] ?? 0,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatRoomPage(chat: chat),
                                    ),
                                  ).then((_) {
                                    // When returning from the chat room, refresh the group chats.
                                    _fetchGroupChats();
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

class GroupChatView extends StatelessWidget {
  final GroupChat chat;
  final String leagueTitle;
  final String latestMessage;
  final DateTime latestMessageTime;
  final String? leagueAvatarUrl;
  final int unreadCount;
  final VoidCallback? onTap; // Optional onTap callback

  const GroupChatView({
    Key? key,
    required this.chat,
    required this.leagueTitle,
    required this.latestMessage,
    required this.latestMessageTime,
    this.leagueAvatarUrl,
    required this.unreadCount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chat row that displays the avatar, details, time, and unread count.
    final Widget chatRow = InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomPage(chat: chat),
              ),
            );
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // League avatar.
            CircleAvatar(
              radius: 30,
              backgroundImage: leagueAvatarUrl != null
                  ? NetworkImage(leagueAvatarUrl!)
                  : const AssetImage('assets/images/default_league_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 16),
            // Chat details: league title and latest message.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leagueTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    latestMessage,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Time and unread count (if any) in a vertical column.
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeago.format(latestMessageTime),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (unreadCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: 22, // Fixed width for a circle.
                      height: 22, // Fixed height for a circle.
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );

    // Wrap the chat row with a divider that starts from the right of the avatar.
    return Column(
      children: [
        chatRow,
        // The divider is indented to start after the avatar and its following spacing.
        Padding(
          padding: const EdgeInsets.only(
              left: 16 + 60 + 16,
              right:
                  16), // 16 (left padding) + 60 (avatar diameter) + 16 spacing = 92.
          child: const Divider(
            thickness: 1,
            color: Color.fromARGB(255, 218, 218, 218),
          ),
        ),
      ],
    );
  }
}
