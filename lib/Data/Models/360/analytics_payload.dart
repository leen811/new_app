import 'package:equatable/equatable.dart';

class AnalyticsPayload extends Equatable {
  final double improvementDelta;
  final int completionPct;
  final int improvementPoints;
  final List<String> strengths;
  final List<String> improvements;
  final List<String> recommendations;
  const AnalyticsPayload({required this.improvementDelta, required this.completionPct, required this.improvementPoints, required this.strengths, required this.improvements, required this.recommendations});
  factory AnalyticsPayload.fromJson(Map<String, dynamic> j) => AnalyticsPayload(
        improvementDelta: (j['improvementDelta'] as num).toDouble(),
        completionPct: (j['completionPct'] as num).toInt(),
        improvementPoints: (j['improvementPoints'] as num).toInt(),
        strengths: List<String>.from(j['strengths'] as List),
        improvements: List<String>.from(j['improvements'] as List),
        recommendations: List<String>.from(j['recommendations'] as List),
      );
  @override
  List<Object?> get props => [improvementDelta, completionPct, improvementPoints, strengths, improvements, recommendations];
}


