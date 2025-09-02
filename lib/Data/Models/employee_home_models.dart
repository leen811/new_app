import 'package:equatable/equatable.dart';

class EmployeeSnapshot extends Equatable {
  final int coins;
  final int energyPct;
  final int performancePct;
  final String performanceBadge;
  final List<TodayActivity> todayActivities;
  final List<Achievement> achievements;

  const EmployeeSnapshot({
    required this.coins,
    required this.energyPct,
    required this.performancePct,
    required this.performanceBadge,
    required this.todayActivities,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
        coins,
        energyPct,
        performancePct,
        performanceBadge,
        todayActivities,
        achievements,
      ];
}

class TodayActivity extends Equatable {
  final String title;
  final String time;
  final ActivityStatus status;

  const TodayActivity({
    required this.title,
    required this.time,
    required this.status,
  });

  @override
  List<Object?> get props => [title, time, status];
}

enum ActivityStatus {
  completed,
  upcoming,
}

extension ActivityStatusExtension on ActivityStatus {
  String get displayText {
    switch (this) {
      case ActivityStatus.completed:
        return 'مكتمل';
      case ActivityStatus.upcoming:
        return 'قادم';
    }
  }

  String get statusColor {
    switch (this) {
      case ActivityStatus.completed:
        return '#2563EB';
      case ActivityStatus.upcoming:
        return '#F97316';
    }
  }
}

class Achievement extends Equatable {
  final String title;
  final String description;
  final String iconName;

  const Achievement({
    required this.title,
    required this.description,
    required this.iconName,
  });

  @override
  List<Object?> get props => [title, description, iconName];
}
