import 'package:equatable/equatable.dart';

class TrainingAlert extends Equatable {
  final String id;
  final String title;
  final String severity; // عالي | متوسط | منخفض
  final String body;
  final String ctaLabel;
  final String recommend;
  const TrainingAlert({required this.id, required this.title, required this.severity, required this.body, required this.ctaLabel, required this.recommend});
  factory TrainingAlert.fromJson(Map<String, dynamic> j) => TrainingAlert(
        id: j['id'] as String,
        title: j['title'] as String,
        severity: j['severity'] as String,
        body: j['body'] as String,
        ctaLabel: j['ctaLabel'] as String,
        recommend: j['recommend'] as String,
      );
  @override
  List<Object?> get props => [id, title, severity, body, ctaLabel, recommend];
}


