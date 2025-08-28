import 'package:equatable/equatable.dart';

class TaskItem extends Equatable {
  final String id;
  final String title;
  final String desc;
  final String priority; // عالية | متوسطة | منخفضة
  final List<String> tags;
  final int estimatedMin;
  final String intlTimeLabel;
  final String category;
  final bool done;
  final int timerSeconds;
  final bool isRunning;

  const TaskItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.priority,
    required this.tags,
    required this.estimatedMin,
    required this.intlTimeLabel,
    required this.category,
    required this.done,
    required this.timerSeconds,
    this.isRunning = false,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        desc: json['desc'] as String? ?? '',
        priority: json['priority'] as String? ?? 'متوسطة',
        tags: List<String>.from((json['tags'] as List? ?? const []).map((e) => e.toString())),
        estimatedMin: (json['estimatedMin'] as num? ?? 0).toInt(),
        intlTimeLabel: json['intlTimeLabel'] as String? ?? '',
        category: json['category'] as String? ?? '',
        done: json['done'] as bool? ?? false,
        timerSeconds: (json['timerSeconds'] as num? ?? 0).toInt(),
        isRunning: json['isRunning'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'priority': priority,
        'tags': tags,
        'estimatedMin': estimatedMin,
        'intlTimeLabel': intlTimeLabel,
        'category': category,
        'done': done,
        'timerSeconds': timerSeconds,
        'isRunning': isRunning,
      };

  TaskItem copyWith({bool? done, int? timerSeconds, bool? isRunning}) => TaskItem(
        id: id,
        title: title,
        desc: desc,
        priority: priority,
        tags: tags,
        estimatedMin: estimatedMin,
        intlTimeLabel: intlTimeLabel,
        category: category,
        done: done ?? this.done,
        timerSeconds: timerSeconds ?? this.timerSeconds,
        isRunning: isRunning ?? this.isRunning,
      );

  bool get isPlaceholderEmpty => title.isEmpty && desc.isEmpty;

  @override
  List<Object?> get props => [id, title, desc, priority, tags, estimatedMin, intlTimeLabel, category, done, timerSeconds, isRunning];
}


