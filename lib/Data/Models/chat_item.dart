import 'package:equatable/equatable.dart';

class ChatItem extends Equatable {
  final String id;
  final String name;
  final bool isGroup;
  final String avatarEmoji;
  final String lastText;
  final DateTime lastAt;
  final int unread;
  final bool pinned;
  final bool online;

  const ChatItem({
    required this.id,
    required this.name,
    required this.isGroup,
    required this.avatarEmoji,
    required this.lastText,
    required this.lastAt,
    required this.unread,
    required this.pinned,
    required this.online,
  });

  ChatItem copyWith({int? unread, bool? pinned}) => ChatItem(
        id: id,
        name: name,
        isGroup: isGroup,
        avatarEmoji: avatarEmoji,
        lastText: lastText,
        lastAt: lastAt,
        unread: unread ?? this.unread,
        pinned: pinned ?? this.pinned,
        online: online,
      );

  factory ChatItem.fromJson(Map<String, dynamic> json) => ChatItem(
        id: json['id'] as String,
        name: json['name'] as String,
        isGroup: json['isGroup'] as bool? ?? false,
        avatarEmoji: json['avatarEmoji'] as String? ?? '💬',
        lastText: json['lastText'] as String? ?? '',
        lastAt: DateTime.parse(json['lastAt'] as String),
        unread: json['unread'] as int? ?? 0,
        pinned: json['pinned'] as bool? ?? false,
        online: json['online'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isGroup': isGroup,
        'avatarEmoji': avatarEmoji,
        'lastText': lastText,
        'lastAt': lastAt.toIso8601String(),
        'unread': unread,
        'pinned': pinned,
        'online': online,
      };

  @override
  List<Object?> get props => [id, name, isGroup, avatarEmoji, lastText, lastAt, unread, pinned, online];
}


