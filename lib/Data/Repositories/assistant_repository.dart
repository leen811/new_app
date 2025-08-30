import 'package:dio/dio.dart';

abstract class IAssistantRepository {
  Future<Map<String, dynamic>> suggest();
  Future<Map<String, dynamic>> chat(String text);
  Future<Map<String, dynamic>> execute(String action);
}

class AssistantRepository implements IAssistantRepository {
  final Dio dio;
  AssistantRepository(this.dio);
  @override
  Future<Map<String, dynamic>> suggest() async {
    final r = await dio.get('/v1/ai/suggest');
    return Map<String, dynamic>.from(r.data as Map);
  }

  @override
  Future<Map<String, dynamic>> chat(String text) async {
    final r = await dio.post('/v1/ai/chat', data: {'text': text});
    return Map<String, dynamic>.from(r.data as Map);
  }

  @override
  Future<Map<String, dynamic>> execute(String action) async {
    final r = await dio.post('/v1/ai/execute', data: {'action': action});
    return Map<String, dynamic>.from(r.data as Map);
  }
}
