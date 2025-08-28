import 'package:equatable/equatable.dart';

class TeamProgressItem extends Equatable {
  final String id;
  final String title;
  final int percent; // 0..100
  final String deadlineLabel;
  final int participants;

  const TeamProgressItem({
    required this.id,
    required this.title,
    required this.percent,
    required this.deadlineLabel,
    required this.participants,
  });

  factory TeamProgressItem.fromJson(Map<String, dynamic> json) => TeamProgressItem(
        id: json['id'] as String,
        title: json['title'] as String,
        percent: (json['percent'] as num).toInt(),
        deadlineLabel: json['deadlineLabel'] as String,
        participants: (json['participants'] as num).toInt(),
      );

  @override
  List<Object?> get props => [id, title, percent, deadlineLabel, participants];
}


