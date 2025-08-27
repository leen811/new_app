import 'package:dio/dio.dart';

abstract class IChatRepository {
  Future<List<Map<String, dynamic>>> fetchMessages();
}

class ChatRepository implements IChatRepository {
  final Dio dio;
  ChatRepository(this.dio);

  @override
  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final resp = await dio.get('chat/messages');
    return List<Map<String, dynamic>>.from(resp.data as List);
  }
}


