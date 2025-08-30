import 'package:dio/dio.dart';

abstract class ITrainingRepository {
  Future<List<Map<String, dynamic>>> alerts();
  Future<List<Map<String, dynamic>>> skills();
  Future<Map<String, dynamic>> courses({required String category, required int page});
  Future<Map<String, dynamic>> toggleBookmark(String id);
}

class TrainingRepository implements ITrainingRepository {
  final Dio dio;
  TrainingRepository(this.dio);
  @override
  Future<List<Map<String, dynamic>>> alerts() async => List<Map<String, dynamic>>.from((await dio.get('/v1/training/alerts')).data as List);
  @override
  Future<List<Map<String, dynamic>>> skills() async => List<Map<String, dynamic>>.from((await dio.get('/v1/training/skills-progress')).data as List);
  @override
  Future<Map<String, dynamic>> courses({required String category, required int page}) async => Map<String, dynamic>.from((await dio.get('/v1/training/courses', queryParameters: {'category': category, 'page': page})).data as Map);
  @override
  Future<Map<String, dynamic>> toggleBookmark(String id) async => Map<String, dynamic>.from((await dio.post('/v1/training/courses/$id/bookmark')).data as Map);
}


