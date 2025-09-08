// no imports

enum MemberAvailability { available, busy, offline }

class TeamKpis {
  final int totalMembers;
  final int activeMembers;
  final int avgPerformancePct;

  const TeamKpis({
    required this.totalMembers,
    required this.activeMembers,
    required this.avgPerformancePct,
  });
}

class TeamMember {
  final String id;
  final String name;
  final String title;
  final String? avatarUrl;
  final int performancePct; // 0..100
  final int tasksCount; // عدد المهام
  final MemberAvailability availability;
  final List<String> skills; // مثل: Node.js, React...
  final DateTime joinedAt;

  const TeamMember({
    required this.id,
    required this.name,
    required this.title,
    this.avatarUrl,
    required this.performancePct,
    required this.tasksCount,
    required this.availability,
    required this.skills,
    required this.joinedAt,
  });

  TeamMember copyWith({
    String? title,
    MemberAvailability? availability,
    List<String>? skills,
  }) {
    return TeamMember(
      id: id,
      name: name,
      title: title ?? this.title,
      avatarUrl: avatarUrl,
      performancePct: performancePct,
      tasksCount: tasksCount,
      availability: availability ?? this.availability,
      skills: skills ?? this.skills,
      joinedAt: joinedAt,
    );
  }
}


