import 'package:dio/dio.dart';

import '../Models/kpi_overview.dart';
import '../Models/task_item.dart';
import '../Models/challenge_item.dart';
import '../Models/team_progress_item.dart';

abstract class ITasksRepository {
  Future<KpiOverview> fetchOverview();
  Future<List<TaskItem>> fetchDailyTasks();
  Future<void> toggleComplete(String id, bool done);
  Future<void> startTimer(String id);
  Future<void> stopTimer(String id, int seconds);
  Future<List<ChallengeItem>> fetchChallenges();
  Future<List<TeamProgressItem>> fetchTeamProgress();
}

class TasksRepository implements ITasksRepository {
  final Dio dio;
  TasksRepository(this.dio);
  @override
  Future<KpiOverview> fetchOverview() async {
    final resp = await dio.get('/v1/tasks/kpi-overview');
    return KpiOverview.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  @override
  Future<List<TaskItem>> fetchDailyTasks() async {
    final resp = await dio.get('/v1/tasks/daily');
    return List<Map<String, dynamic>>.from(resp.data as List).map(TaskItem.fromJson).toList();
  }

  @override
  Future<void> toggleComplete(String id, bool done) async {
    await dio.post('/v1/tasks/$id/toggle-complete', data: {'done': done});
  }

  @override
  Future<void> startTimer(String id) async {
    await dio.post('/v1/tasks/$id/timer/start');
  }

  @override
  Future<void> stopTimer(String id, int seconds) async {
    await dio.post('/v1/tasks/$id/timer/stop', data: {'seconds': seconds});
  }

  @override
  Future<List<ChallengeItem>> fetchChallenges() async {
    final resp = await dio.get('/v1/challenges/group');
    return List<Map<String, dynamic>>.from(resp.data as List).map(ChallengeItem.fromJson).toList();
  }

  @override
  Future<List<TeamProgressItem>> fetchTeamProgress() async {
    final resp = await dio.get('/v1/challenges/team-progress');
    return List<Map<String, dynamic>>.from(resp.data as List).map(TeamProgressItem.fromJson).toList();
  }
}


