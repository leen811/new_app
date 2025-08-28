import 'package:equatable/equatable.dart';

class KpiOverview extends Equatable {
  final int tasksTodayDone;
  final int tasksTodayTotal;
  final int activeChallenges;
  final int workMinutes;
  final int achievementPct; // 0..100

  const KpiOverview({
    required this.tasksTodayDone,
    required this.tasksTodayTotal,
    required this.activeChallenges,
    required this.workMinutes,
    required this.achievementPct,
  });

  factory KpiOverview.fromJson(Map<String, dynamic> json) => KpiOverview(
        tasksTodayDone: (json['tasksTodayDone'] as num).toInt(),
        tasksTodayTotal: (json['tasksTodayTotal'] as num).toInt(),
        activeChallenges: (json['activeChallenges'] as num).toInt(),
        workMinutes: (json['workMinutes'] as num).toInt(),
        achievementPct: (json['achievementPct'] as num).toInt(),
      );

  @override
  List<Object?> get props => [tasksTodayDone, tasksTodayTotal, activeChallenges, workMinutes, achievementPct];
}


