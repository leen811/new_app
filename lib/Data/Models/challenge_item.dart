import 'package:equatable/equatable.dart';

class ChallengeItem extends Equatable {
  final String id;
  final String title;
  final String desc;
  final int teamProgress;
  final int total;
  final int meProgress;
  final String deadlineLabel;
  final int participants;

  const ChallengeItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.teamProgress,
    required this.total,
    required this.meProgress,
    required this.deadlineLabel,
    required this.participants,
  });

  factory ChallengeItem.fromJson(Map<String, dynamic> json) => ChallengeItem(
    id: json['id'] as String,
    title: json['title'] as String,
    desc: json['desc'] as String? ?? '',
    teamProgress: (json['teamProgress'] as num).toInt(),
    total: (json['total'] as num).toInt(),
    meProgress: (json['meProgress'] as num).toInt(),
    deadlineLabel: json['deadlineLabel'] as String,
    participants: (json['participants'] as num).toInt(),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    desc,
    teamProgress,
    total,
    meProgress,
    deadlineLabel,
    participants,
  ];
}
