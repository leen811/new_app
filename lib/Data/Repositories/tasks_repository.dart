import 'package:dio/dio.dart';

abstract class ITasksRepository {
  Future<List<Map<String, dynamic>>> fetchTasks();
}

class TasksRepository implements ITasksRepository {
  final Dio dio;
  TasksRepository(this.dio);
  @override
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final resp = await dio.get('tasks');
    return List<Map<String, dynamic>>.from(resp.data as List);
  }
}


