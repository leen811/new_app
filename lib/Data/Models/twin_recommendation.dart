import 'package:equatable/equatable.dart';

class TwinCta extends Equatable {
  final String label;
  final String icon;
  final String? action;
  const TwinCta({required this.label, required this.icon, this.action});
  factory TwinCta.fromJson(Map<String, dynamic> j) => TwinCta(label: j['label'] as String, icon: j['icon'] as String, action: j['action'] as String?);
  @override
  List<Object?> get props => [label, icon, action];
}

class TwinRecommendation extends Equatable {
  final String id;
  final String priority; // "عالي|متوسط|منخفض"
  final String title;
  final String body;
  final List<TwinCta> ctas;
  const TwinRecommendation({required this.id, required this.priority, required this.title, required this.body, required this.ctas});
  factory TwinRecommendation.fromJson(Map<String, dynamic> j) => TwinRecommendation(
        id: j['id'] as String,
        priority: j['priority'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
        ctas: (j['ctas'] as List).map((e) => TwinCta.fromJson(Map<String, dynamic>.from(e as Map))).toList(),
      );
  @override
  List<Object?> get props => [id, priority, title, body, ctas];
}


