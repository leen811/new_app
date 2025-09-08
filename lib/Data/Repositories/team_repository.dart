import 'dart:async';

// no flutter imports here

import '../Models/team_models.dart';

abstract class TeamRepository {
  Future<(TeamKpis, List<TeamMember>)> fetchTeam({String query = ''});
  Future<TeamMember> getById(String id);
  Future<TeamMember> updateMember(
    String id, {
    String? title,
    MemberAvailability? availability,
    List<String>? skills,
  });
  Future<TeamMember> createMember({
    required String name,
    required String title,
    List<String> skills = const [],
  });
}

class MockTeamRepository implements TeamRepository {
  MockTeamRepository() {
    _members = [
      TeamMember(
        id: '1',
        name: 'سارة أحمد',
        title: 'مطور أول',
        avatarUrl: 'https://i.pravatar.cc/150?img=47',
        performancePct: 95,
        tasksCount: 24,
        availability: MemberAvailability.available,
        skills: const ['Node.js', 'TypeScript', 'React'],
        joinedAt: DateTime.now().subtract(const Duration(days: 620)),
      ),
      TeamMember(
        id: '2',
        name: 'محمد علي',
        title: 'مصمم UI/UX',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        performancePct: 90,
        tasksCount: 28,
        availability: MemberAvailability.busy,
        skills: const ['Figma', 'Prototyping', 'Design Systems'],
        joinedAt: DateTime.now().subtract(const Duration(days: 480)),
      ),
      TeamMember(
        id: '3',
        name: 'فاطمة محمد',
        title: 'محلل بيانات',
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
        performancePct: 88,
        tasksCount: 16,
        availability: MemberAvailability.offline,
        skills: const ['SQL', 'Python', 'Power BI'],
        joinedAt: DateTime.now().subtract(const Duration(days: 390)),
      ),
      TeamMember(
        id: '4',
        name: 'خالد الأحمد',
        title: 'مطور تطبيقات',
        avatarUrl: 'https://i.pravatar.cc/150?img=56',
        performancePct: 92,
        tasksCount: 22,
        availability: MemberAvailability.available,
        skills: const ['Dart', 'Flutter', 'Clean Architecture'],
        joinedAt: DateTime.now().subtract(const Duration(days: 710)),
      ),
      TeamMember(
        id: '5',
        name: 'ليلى حسين',
        title: 'مهندس جودة',
        avatarUrl: null,
        performancePct: 85,
        tasksCount: 18,
        availability: MemberAvailability.busy,
        skills: const ['Test Automation', 'Selenium', 'CI/CD'],
        joinedAt: DateTime.now().subtract(const Duration(days: 270)),
      ),
    ];
  }

  late List<TeamMember> _members;

  TeamKpis get _kpis => const TeamKpis(
        totalMembers: 5,
        activeMembers: 3,
        avgPerformancePct: 90,
      );

  @override
  Future<(TeamKpis, List<TeamMember>)> fetchTeam({String query = ''}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final normalized = query.trim();
    final filtered = normalized.isEmpty
        ? _members
        : _members
            .where((m) => m.name.contains(normalized) || m.title.contains(normalized))
            .toList();
    return (_kpis, filtered);
  }

  @override
  Future<TeamMember> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final found = _members.firstWhere((m) => m.id == id, orElse: () => throw StateError('Member not found'));
    return found;
  }

  @override
  Future<TeamMember> updateMember(
    String id, {
    String? title,
    MemberAvailability? availability,
    List<String>? skills,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _members.indexWhere((m) => m.id == id);
    if (index == -1) throw StateError('Member not found');
    final updated = _members[index].copyWith(
      title: title,
      availability: availability,
      skills: skills,
    );
    _members[index] = updated;
    return updated;
  }

  @override
  Future<TeamMember> createMember({
    required String name,
    required String title,
    List<String> skills = const [],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final newId = (int.parse(_members.last.id) + 1).toString();
    final member = TeamMember(
      id: newId,
      name: name,
      title: title,
      avatarUrl: null,
      performancePct: 85,
      tasksCount: 0,
      availability: MemberAvailability.available,
      skills: skills,
      joinedAt: DateTime.now(),
    );
    _members.add(member);
    return member;
  }
}


