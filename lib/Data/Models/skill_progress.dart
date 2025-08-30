import 'package:equatable/equatable.dart';

class SkillProgress extends Equatable {
  final String skillName;
  final int currentPct;
  final int targetPct;
  final String? icon;
  const SkillProgress({required this.skillName, required this.currentPct, required this.targetPct, this.icon});
  factory SkillProgress.fromJson(Map<String, dynamic> j) => SkillProgress(skillName: j['skillName'] as String, currentPct: (j['currentPct'] as num).toInt(), targetPct: (j['targetPct'] as num).toInt(), icon: j['icon'] as String?);
  @override
  List<Object?> get props => [skillName, currentPct, targetPct, icon];
}


