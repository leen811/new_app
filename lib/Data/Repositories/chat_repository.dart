import 'package:dio/dio.dart';
import '../Models/chat_item.dart';

abstract class IChatRepository {
  Future<List<ChatItem>> fetchConversations();
  Future<void> togglePinned(String id);
  Future<void> markRead(String id);
}

class ChatRepository implements IChatRepository {
  final Dio dio;
  ChatRepository(this.dio);

  @override
  Future<List<ChatItem>> fetchConversations() async {
    final resp = await dio.get('chat/conversations');
    return List<Map<String, dynamic>>.from(resp.data as List).map(ChatItem.fromJson).toList();
  }

  @override
  Future<void> togglePinned(String id) async {
    await dio.post('chat/pin', data: {'id': id});
  }

  @override
  Future<void> markRead(String id) async {
    await dio.post('chat/mark-read', data: {'id': id});
  }
}


