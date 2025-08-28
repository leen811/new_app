import 'package:dio/dio.dart';

import '../../Bloc/chat/detail/chat_detail_state.dart';

abstract class IChatDetailRepository {
  Future<ChatHistory> fetchHistory({required String conversationId, DateTime? before});
  Future<SentResult> sendMessage({required String conversationId, required String text, String? replyToId});
  Future<void> markRead(String conversationId);
}

class ChatDetailRepository implements IChatDetailRepository {
  final Dio dio;
  ChatDetailRepository(this.dio);

  @override
  Future<ChatHistory> fetchHistory({required String conversationId, DateTime? before}) async {
    final resp = await dio.get('/v1/chat/history', queryParameters: {
      'convId': conversationId,
      if (before != null) 'before': before.toIso8601String(),
    });
    final list = List<Map<String, dynamic>>.from(resp.data as List);
    final messages = list.map(_fromMap).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final canLoadMore = list.length >= 20; // heuristic for mock paging
    final oldestTs = messages.isNotEmpty ? messages.first.createdAt : null;
    return ChatHistory(messages: messages, canLoadMore: canLoadMore, oldestTs: oldestTs);
  }

  @override
  Future<SentResult> sendMessage({required String conversationId, required String text, String? replyToId}) async {
    final resp = await dio.post('/v1/chat/send', data: {
      'convId': conversationId,
      'text': text,
      if (replyToId != null) 'replyToId': replyToId,
    });
    final map = Map<String, dynamic>.from(resp.data as Map);
    return SentResult(id: map['id'].toString(), at: DateTime.parse(map['at'] as String));
  }

  @override
  Future<void> markRead(String conversationId) async {
    await dio.post('/v1/chat/mark-read', data: {'convId': conversationId});
  }

  Message _fromMap(Map<String, dynamic> m) {
    return Message(
      id: m['id'].toString(),
      authorId: m['authorId'].toString(),
      authorName: m['authorName'] as String,
      isMe: m['isMe'] as bool,
      text: m['text'] as String,
      createdAt: DateTime.parse(m['createdAt'] as String),
      replyToId: m['replyToId']?.toString(),
    );
  }
}

class ChatHistory {
  ChatHistory({required this.messages, required this.canLoadMore, required this.oldestTs});
  final List<Message> messages;
  final bool canLoadMore;
  final DateTime? oldestTs;
}

class SentResult {
  SentResult({required this.id, required this.at});
  final String id;
  final DateTime at;
}


