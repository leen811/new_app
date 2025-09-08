import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../Models/team_tasks_models.dart';

abstract class TeamTasksRepository {
  Future<(TasksSummary, List<TaskItem>)> fetch({String query = '', String filter = 'all'});
  Future<TaskItem> getById(String id);
  Future<TaskItem> update(String id, {TaskStatus? status, int? progress});
  Future<TaskItem> create(TaskItem draft);
  Future<void> sendMessage(String id, String message);
}

class MockTeamTasksRepository implements TeamTasksRepository {
  final List<TaskItem> _items = [];

  MockTeamTasksRepository() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    final yest = now.subtract(const Duration(days: 1));
    _items.addAll([
      TaskItem(
        id: 't1',
        title: 'تصميم شاشة تسجيل الدخول',
        description: 'تحديث تجربة المستخدم وإضافة التحقق بخطوتين',
        assigneeId: 'u1',
        assigneeName: 'سارة أحمد',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 3)),
        dueAt: nextWeek,
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        tags: const ['UI/UX', 'Flutter'],
        spentHours: 12,
        estimateHours: 24,
        progress: 55,
      ),
      TaskItem(
        id: 't2',
        title: 'إصلاح أخطاء شاشة التقارير',
        description: 'تصحيح مشكلة التحميل البطيء وإصلاح Crash عند عدم وجود بيانات',
        assigneeId: 'u2',
        assigneeName: 'محمد علي',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 5)),
        dueAt: nextWeek.add(const Duration(days: 2)),
        status: TaskStatus.review,
        priority: TaskPriority.medium,
        tags: const ['Bugfix', 'Dio'],
        spentHours: 8,
        estimateHours: 16,
        progress: 80,
      ),
      TaskItem(
        id: 't3',
        title: 'تهيئة CI/CD',
        description: 'إعداد خطوط البناء والنشر التلقائي باستخدام GitHub Actions',
        assigneeId: 'u3',
        assigneeName: 'فاطمة محمد',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 7)),
        dueAt: nextWeek.add(const Duration(days: 4)),
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        tags: const ['DevOps', 'CI'],
        spentHours: 0,
        estimateHours: 20,
        progress: 0,
      ),
      TaskItem(
        id: 't4',
        title: 'إعادة تصميم صفحة الملف الشخصي',
        description: 'مراجعة التخطيط واعتماد مكونات Material3 الموحدة',
        assigneeId: 'u4',
        assigneeName: 'خالد الأحمد',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 2)),
        dueAt: yest,
        status: TaskStatus.overdue,
        priority: TaskPriority.high,
        tags: const ['UI', 'Refactor'],
        spentHours: 26,
        estimateHours: 40,
        progress: 65,
      ),
      TaskItem(
        id: 't5',
        title: 'بناء شاشة المتجر',
        description: 'قائمة المنتجات + البحث + السلة',
        assigneeId: 'u5',
        assigneeName: 'لينا يوسف',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 10)),
        dueAt: now.subtract(const Duration(days: 3)),
        status: TaskStatus.done,
        priority: TaskPriority.low,
        tags: const ['Store', 'UI'],
        spentHours: 30,
        estimateHours: 30,
        progress: 100,
      ),
      TaskItem(
        id: 't6',
        title: 'تكامل الإشعارات الفورية',
        description: 'تفعيل Firebase Cloud Messaging للرسائل والتنبيهات',
        assigneeId: 'u6',
        assigneeName: 'هادي سمير',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 1)),
        dueAt: nextWeek,
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        tags: const ['Firebase', 'Notifications'],
        spentHours: 6,
        estimateHours: 18,
        progress: 35,
      ),
      TaskItem(
        id: 't7',
        title: 'تحسين أداء قائمة المهام',
        description: 'استخدام ListView.builder والـshimmer وتقليل إعادة البناء',
        assigneeId: 'u7',
        assigneeName: 'ريم سعد',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 4)),
        dueAt: nextWeek,
        status: TaskStatus.review,
        priority: TaskPriority.medium,
        tags: const ['Performance', 'Flutter'],
        spentHours: 14,
        estimateHours: 22,
        progress: 70,
      ),
      TaskItem(
        id: 't8',
        title: 'إعداد نظام الأذونات RBAC',
        description: 'الأدوار والصلاحيات للمشرفين والمدراء وقادة الفرق',
        assigneeId: 'u8',
        assigneeName: 'أحمد حسام',
        assigneeAvatar: '',
        createdAt: now.subtract(const Duration(days: 6)),
        dueAt: nextWeek.add(const Duration(days: 1)),
        status: TaskStatus.todo,
        priority: TaskPriority.high,
        tags: const ['Security', 'RBAC'],
        spentHours: 0,
        estimateHours: 28,
        progress: 0,
      ),
    ]);
  }

  @override
  Future<(TasksSummary, List<TaskItem>)> fetch({String query = '', String filter = 'all'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    Iterable<TaskItem> list = _items;
    if (query.trim().isNotEmpty) {
      final q = query.trim();
      list = list.where((e) => e.title.contains(q) || e.description.contains(q) || e.assigneeName.contains(q) || e.tags.any((t) => t.contains(q)));
    }
    if (filter != 'all') {
      list = list.where((e) => describeEnum(e.status) == filter);
    }

    final total = _items.length;
    final inProgress = _items.where((e) => e.status == TaskStatus.inProgress).length;
    final todo = _items.where((e) => e.status == TaskStatus.todo).length;
    final review = _items.where((e) => e.status == TaskStatus.review).length;
    final overdue = _items.where((e) => e.status == TaskStatus.overdue).length;
    final done = _items.where((e) => e.status == TaskStatus.done).length;
    final summary = TasksSummary(total: total, inProgress: inProgress, todo: todo, review: review, overdue: overdue, done: done);
    return (summary, List<TaskItem>.unmodifiable(list.toList()));
  }

  @override
  Future<TaskItem> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final item = _items.firstWhere((e) => e.id == id);
    return item;
  }

  @override
  Future<TaskItem> update(String id, {TaskStatus? status, int? progress}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) throw StateError('Task not found');
    var current = _items[idx];
    if (progress != null) {
      final clamped = progress.clamp(0, 100);
      current = current.copyWith(progress: clamped);
      if (clamped == 100) {
        current = current.copyWith(status: TaskStatus.done);
      } else if (clamped > 0 && current.status == TaskStatus.todo) {
        current = current.copyWith(status: TaskStatus.inProgress);
      }
    }
    if (status != null) {
      current = current.copyWith(status: status);
    }
    _items[idx] = current;
    return current;
  }

  @override
  Future<TaskItem> create(TaskItem draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final id = 't${_items.length + 1}';
    final item = draft.copyWith(
      id: id,
      createdAt: draft.createdAt,
    );
    _items.add(item);
    return item;
  }

  @override
  Future<void> sendMessage(String id, String message) async {
    // mock send message: no-op with small delay
    await Future<void>.delayed(const Duration(milliseconds: 180));
  }
}

class DioTeamTasksRepository implements TeamTasksRepository {
  final Dio dio;
  DioTeamTasksRepository(this.dio);

  @override
  Future<(TasksSummary, List<TaskItem>)> fetch({String query = '', String filter = 'all'}) => Future.error(UnimplementedError());

  @override
  Future<TaskItem> getById(String id) => Future.error(UnimplementedError());

  @override
  Future<TaskItem> update(String id, {TaskStatus? status, int? progress}) => Future.error(UnimplementedError());

  @override
  Future<TaskItem> create(TaskItem draft) => Future.error(UnimplementedError());

  @override
  Future<void> sendMessage(String id, String message) => Future.error(UnimplementedError());
}


