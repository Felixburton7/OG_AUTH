class ChatMessage {
  ChatMessage({
    required this.id,
    required this.profileId,
    required this.leagueId,
    required this.content,
    required this.createdAt,
    required this.isMine,
  });

  /// ID of the message
  final String id;

  /// ID of the user who posted the message
  final String profileId;

  /// ID of the league that
  final String leagueId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime createdAt;

  /// Whether the message is sent by the user or not.
  final bool isMine;

  ChatMessage.fromJson({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'] ?? '',
        leagueId = map['league_id'] ?? '',
        profileId = map['profile_id'] ?? '',
        content = map['content'] ?? '',
        createdAt = DateTime.parse(map['created_at'] ?? ''),
        isMine = myUserId == map['profile_id'];
}

class GroupChat {
  final String id;
  final String leagueId;
  final DateTime createdAt;
  final String? leagueTitle;

  GroupChat({
    required this.id,
    required this.leagueId,
    required this.createdAt,
    this.leagueTitle,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) {
    return GroupChat(
        id: json['chat_id'],
        createdAt: DateTime.parse(json['created_at']),
        leagueId: json['league_id'],
        leagueTitle: json['league_title']);
  }
}

