import 'dart:async';

import 'package:dio/dio.dart';
import '../Models/meetings_models.dart';

abstract class MeetingsRepository {
  Future<(MeetingsKpis, List<Meeting>)> fetch({String q = '', MeetingStatus? tab});
  Future<Meeting> create(Meeting draft);
  Future<Meeting> update(String id, Meeting patch);
  Future<void> delete(String id);
}

class MockMeetingsRepository implements MeetingsRepository {
  final List<Meeting> _items = [];

  MockMeetingsRepository() {
    final now = DateTime.now();
    _items.addAll([
      Meeting(
        id: 'm1',
        title: 'اجتماع تخطيط الربع القادم',
        description: 'مناقشة الأهداف ومؤشرات الأداء للفصل القادم',
        date: now.add(const Duration(days: 1, hours: 2)),
        durationMinutes: 60,
        priority: MeetingPriority.high,
        type: MeetingType.online,
        placeOrLink: 'https://meet.google.com/abc-defg-hij',
        participantIds: const ['u1', 'u2', 'u3'],
        departmentIds: const ['tech'],
        status: MeetingStatus.upcoming,
        platform: 'Google Meet',
      ),
      Meeting(
        id: 'm2',
        title: 'مراجعة Sprint',
        description: 'عرض ما تم إنجازه واستعراض الملاحظات',
        date: now.add(const Duration(days: 2, hours: 3)),
        durationMinutes: 45,
        priority: MeetingPriority.medium,
        type: MeetingType.hybrid,
        placeOrLink: 'قاعة الاجتماعات - الدور 2 / Zoom',
        participantIds: const ['u1', 'u4'],
        departmentIds: const ['tech', 'design'],
        status: MeetingStatus.upcoming,
        platform: 'Zoom',
      ),
      Meeting(
        id: 'm3',
        title: 'جلسة تدريب على الأمان',
        description: 'توعية بالممارسات الأمنية وأفضل السياسات',
        date: now.add(const Duration(days: 3, hours: 1)),
        durationMinutes: 90,
        priority: MeetingPriority.low,
        type: MeetingType.onsite,
        placeOrLink: 'قاعة المؤتمرات A',
        participantIds: const ['u5', 'u6', 'u7', 'u8'],
        departmentIds: const ['hr'],
        status: MeetingStatus.upcoming,
        platform: 'Onsite',
      ),
      Meeting(
        id: 'm4',
        title: 'اجتماع متابعة حملة التسويق',
        description: 'تحليل النتائج الأولية وتعديل خطة الإطلاق',
        date: now.subtract(const Duration(days: 1, hours: 2)),
        durationMinutes: 30,
        priority: MeetingPriority.medium,
        type: MeetingType.online,
        placeOrLink: 'https://teams.microsoft.com/l/meetup-join/xyz',
        participantIds: const ['u2', 'u9'],
        departmentIds: const ['marketing'],
        status: MeetingStatus.completed,
        platform: 'Teams',
      ),
    ]);
  }

  @override
  Future<(MeetingsKpis, List<Meeting>)> fetch({String q = '', MeetingStatus? tab}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    Iterable<Meeting> list = _items;
    if (tab != null) list = list.where((e) => e.status == tab);
    if (q.trim().isNotEmpty) {
      list = list.where((e) => e.title.contains(q) || e.description.contains(q) || (e.placeOrLink ?? '').contains(q) || e.platform.contains(q));
    }
    final scheduled = _items.where((e) => e.status == MeetingStatus.upcoming).length;
    final completed = _items.where((e) => e.status == MeetingStatus.completed).length;
    final totalMinutes = _items.fold<int>(0, (p, c) => p + c.durationMinutes);
    final participants = _items.fold<int>(0, (p, c) => p + c.participantIds.length);
    final kpis = MeetingsKpis(scheduled: scheduled, completed: completed, totalMinutes: totalMinutes, participants: participants);
    return (kpis, List<Meeting>.unmodifiable(list.toList()));
  }

  @override
  Future<Meeting> create(Meeting draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final m = draft.copyWith(id: 'm${_items.length + 1}');
    _items.add(m);
    return m;
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    _items.removeWhere((e) => e.id == id);
  }

  @override
  Future<Meeting> update(String id, Meeting patch) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx == -1) throw StateError('Meeting not found');
    final cur = _items[idx];
    final upd = cur.copyWith(
      title: patch.title,
      description: patch.description,
      date: patch.date,
      durationMinutes: patch.durationMinutes,
      priority: patch.priority,
      type: patch.type,
      placeOrLink: patch.placeOrLink,
      participantIds: patch.participantIds,
      departmentIds: patch.departmentIds,
      status: patch.status,
      platform: patch.platform,
    );
    _items[idx] = upd;
    return upd;
  }
}

class DioMeetingsRepository implements MeetingsRepository {
  final Dio dio;
  DioMeetingsRepository(this.dio);

  @override
  Future<(MeetingsKpis, List<Meeting>)> fetch({String q = '', MeetingStatus? tab}) => Future.error(UnimplementedError());
  @override
  Future<Meeting> create(Meeting draft) => Future.error(UnimplementedError());
  @override
  Future<Meeting> update(String id, Meeting patch) => Future.error(UnimplementedError());
  @override
  Future<void> delete(String id) => Future.error(UnimplementedError());
}


