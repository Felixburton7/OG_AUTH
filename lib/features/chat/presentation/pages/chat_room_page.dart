import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/chat/domain/entities/messages.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomPage extends StatefulWidget {
  final GroupChat chat;

  const ChatRoomPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final Stream<List<ChatMessage>> _messagesStream;
  late final StreamSubscription<List<ChatMessage>> _messagesSubscription;
  late final ScrollController _chatScrollController;
  final Map<String, UserProfileDTO> _profileCache = {};

  @override
  void initState() {
    super.initState();
    _chatScrollController = ScrollController();
    final myUserId = Supabase.instance.client.auth.currentUser!.id;
    _messagesStream = Supabase.instance.client
        .from('league_chat_messages')
        .stream(primaryKey: ['id'])
        .eq('group_chat_id', widget.chat.id)
        .order('created_at')
        .map((maps) => maps
            .map((map) {
              try {
                return ChatMessage.fromJson(map: map, myUserId: myUserId);
              } catch (e) {
                return null;
              }
            })
            .where((message) => message != null)
            .cast<ChatMessage>()
            .toList());
    _updateReadStatus();
    // Store the subscription so we can cancel it later
    _messagesSubscription =
        _messagesStream.listen((messages) {}, onError: (error) {});
  }

  @override
  void dispose() {
    _messagesSubscription
        .cancel(); // Cancel the subscription to close the connection
    _chatScrollController.dispose();
    super.dispose();
  }

  Future<void> _updateReadStatus() async {
    final myUserId = Supabase.instance.client.auth.currentUser!.id;
    await Supabase.instance.client.from('league_chat_read_status').upsert({
      'group_chat_id': widget.chat.id,
      'profile_id': myUserId,
      'last_read_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _loadProfileCache(String profileId) async {
    if (_profileCache.containsKey(profileId)) return;
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('profile_id', profileId)
        .single();
    final profile = UserProfileDTO.fromJson(response);
    setState(() {
      _profileCache[profileId] = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.chat.leagueTitle ?? 'Chat Room',
            ),
            bottom: const TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFF1C8366), width: 4.0),
                insets: EdgeInsets.zero,
              ),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Chat'),
                Tab(text: 'Members'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _ChatView(
                messagesStream: _messagesStream,
                scrollController: _chatScrollController,
                loadProfileCache: _loadProfileCache,
                profileCache: _profileCache,
                chat: widget.chat,
              ),
              ChatMembersTab(chat: widget.chat),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chat conversation view.
class _ChatView extends StatefulWidget {
  final Stream<List<ChatMessage>> messagesStream;
  final ScrollController scrollController;
  final Future<void> Function(String) loadProfileCache;
  final Map<String, UserProfileDTO> profileCache;
  final GroupChat chat;

  const _ChatView({
    Key? key,
    required this.messagesStream,
    required this.scrollController,
    required this.loadProfileCache,
    required this.profileCache,
    required this.chat,
  }) : super(key: key);

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  bool _firstLoad = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<ChatMessage>>(
            stream: widget.messagesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final errorString = snapshot.error.toString();
                // Customize the error message for RealtimeSubscriptexception
                String friendlyMessage =
                    'Oops, something went wrong with the chat.';
                if (errorString.contains('RealtimeSubscriptexception')) {
                  friendlyMessage =
                      'Unable to connect to realtime updates. Please try again later.';
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        friendlyMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('Start your conversation now :)'));
              } else {
                final messages = List<ChatMessage>.from(snapshot.data!);
                messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                final Map<DateTime, List<ChatMessage>> groupedMessages = {};
                for (final message in messages) {
                  final dateKey = DateTime(
                    message.createdAt.year,
                    message.createdAt.month,
                    message.createdAt.day,
                  );
                  groupedMessages.putIfAbsent(dateKey, () => []).add(message);
                }

                final List<Widget> chatWidgets = [];
                final sortedKeys = groupedMessages.keys.toList()..sort();
                for (final dateKey in sortedKeys) {
                  final group = groupedMessages[dateKey]!;
                  chatWidgets.add(
                    _DateHeader(
                      groupDate: dateKey,
                      firstMessageTime: group.first.createdAt,
                    ),
                  );
                  for (final message in group) {
                    chatWidgets.add(
                      _ChatBubble(
                        message: message,
                        profile: widget.profileCache[message.profileId],
                      ),
                    );
                    widget.loadProfileCache(message.profileId);
                  }
                }

                // Scroll to bottom: On first load, jump instantly; thereafter, animate.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (widget.scrollController.hasClients) {
                    if (_firstLoad) {
                      widget.scrollController.jumpTo(
                        widget.scrollController.position.maxScrollExtent,
                      );
                      _firstLoad = false;
                    } else {
                      widget.scrollController.animateTo(
                        widget.scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  }
                });

                return ListView(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: chatWidgets,
                );
              }
            },
          ),
        ),
        _MessageBar(scrollController: widget.scrollController),
      ],
    );
  }
}

/// A chat bubble that displays a single message with long-press delete for your own messages.
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final UserProfileDTO? profile;

  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final showTime = DateTime.now().difference(message.createdAt) >=
        const Duration(hours: 1);

    Widget bubble = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Align(
        alignment:
            message.isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: message.isMine
                    ? Theme.of(context).colorScheme.primary
                    : isDarkMode
                        ? AppColors.grey900
                        : Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMine && profile != null)
                    Text(
                      profile!.username ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getRandomColor(profile!.profileId!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (!message.isMine && profile != null)
                    const SizedBox(height: 4),
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.isMine
                          ? Theme.of(context).colorScheme.onPrimary
                          : isDarkMode
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.black,
                    ),
                  ),
                  if (showTime) ...[
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        timeago.format(message.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: message.isMine
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.7)
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (message.isMine) {
      return GestureDetector(
        onLongPress: () async {
          HapticFeedback.mediumImpact();
          final bool? shouldDelete = await showModalBottomSheet<bool>(
            context: context,
            builder: (context) => ListTile(
              leading: const Icon(Icons.remove_circle, color: Colors.red),
              title: const Text("Delete Message"),
              onTap: () {
                Navigator.of(context).pop(true);
              },
            ),
          );
          if (shouldDelete == true) {
            try {
              final response = await Supabase.instance.client
                  .from('league_chat_messages')
                  .delete()
                  .eq('message_id', message.id);
              if (response != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response)),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error deleting message')),
              );
            }
          }
        },
        child: bubble,
      );
    } else {
      return bubble;
    }
  }
}

/// Returns a consistent color based on a profile ID.
Color _getRandomColor(String profileId) {
  final hash = profileId.hashCode;
  final colourList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.purple,
    Colors.orange,
  ];
  return colourList[hash % colourList.length];
}

/// Displays a header for a group of messages.
class _DateHeader extends StatelessWidget {
  final DateTime groupDate;
  final DateTime firstMessageTime;

  const _DateHeader({
    Key? key,
    required this.groupDate,
    required this.firstMessageTime,
  }) : super(key: key);

  String _formatHeader(DateTime groupDate, DateTime messageTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final groupDay = DateTime(groupDate.year, groupDate.month, groupDate.day);

    if (groupDay == today) {
      return 'Today';
    } else if (groupDay == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM HH:mm').format(messageTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          _formatHeader(groupDate, firstMessageTime),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Message input bar.
class _MessageBar extends StatefulWidget {
  final ScrollController scrollController;
  const _MessageBar({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    final text = _textController.text;
    final myUserId = Supabase.instance.client.auth.currentUser!.id;
    if (text.isEmpty) return;
    _textController.clear();
    try {
      final response =
          await Supabase.instance.client.from('league_chat_messages').insert({
        'league_id': context
            .findAncestorWidgetOfExactType<ChatRoomPage>()!
            .chat
            .leagueId,
        'group_chat_id':
            context.findAncestorWidgetOfExactType<ChatRoomPage>()!.chat.id,
        'profile_id': myUserId,
        'content': text,
      });
      if (response != null) throw response!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } on PostgrestException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: TextStyle(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    hintStyle: TextStyle(
                      color: isDarkMode
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.transparent
                        : const Color.fromARGB(255, 228, 228, 228),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: isDarkMode
                          ? BorderSide(
                              color: Theme.of(context).colorScheme.primary)
                          : BorderSide.none,
                    ),
                    focusedBorder: isDarkMode
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _submitMessage,
                icon: FaIcon(
                  FontAwesomeIcons.solidPaperPlane,
                  size: 24,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ----- MEMBERS TAB -----

class ChatMembersTab extends StatefulWidget {
  final GroupChat chat;

  const ChatMembersTab({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatMembersTab> createState() => _ChatMembersTabState();
}

class _ChatMembersTabState extends State<ChatMembersTab> {
  late Future<List<LeagueMembersEntity>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture = _loadMembers();
  }

  Future<List<LeagueMembersEntity>> _loadMembers() async {
    final response = await Supabase.instance.client
        .from('league_members')
        .select('*, profiles(*)')
        .eq('league_id', widget.chat.leagueId);

    final data = response as List<dynamic>;

    // Flatten nested profile data into top-level keys.
    List<LeagueMembersEntity> members = data.map((json) {
      final Map<String, dynamic> modifiedJson = Map<String, dynamic>.from(json);
      if (json['profiles'] != null) {
        final profiles = json['profiles'] as Map<String, dynamic>;
        modifiedJson['username'] = profiles['username'];
        modifiedJson['first_name'] = profiles['first_name'];
        modifiedJson['last_name'] = profiles['last_name'];
        modifiedJson['avatar_url'] = profiles['avatar_url'];
      }
      return LeagueMembersEntity.fromJson(modifiedJson);
    }).toList();

    // Sort alphabetically by username (or first name if missing)
    members.sort((a, b) {
      final aKey = (a.username ?? a.firstName ?? '').toLowerCase();
      final bKey = (b.username ?? b.firstName ?? '').toLowerCase();
      return aKey.compareTo(bKey);
    });
    return members;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeagueMembersEntity>>(
      future: _membersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading members: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No members found in this chat.'));
        } else {
          final members = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Members (N)"
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 18.0),
                child: Text(
                  'Members (${members.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return _buildMemberCard(member);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  /// Builds a card-like container for a single member.
  Widget _buildMemberCard(LeagueMembersEntity member) {
    final fullName =
        '${member.firstName ?? ''} ${member.lastName ?? ''}'.trim();
    final displayName = fullName.isNotEmpty ? fullName : 'Unknown Member';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Avatar on the left.
          CircleAvatar(
            radius: 24,
            backgroundImage:
                (member.avatarUrl != null && member.avatarUrl!.isNotEmpty)
                    ? NetworkImage(member.avatarUrl!)
                    : const AssetImage('assets/images/defaultProfile.png')
                        as ImageProvider,
          ),
          const SizedBox(width: 12),
          // Name details on the right.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                member.username ?? 'No username',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
