import 'package:equatable/equatable.dart';

class EvalCategory extends Equatable {
  final String name;
  final int weightPct; // e.g., 20
  final double? score; // 0-5
  const EvalCategory({required this.name, required this.weightPct, this.score});
  factory EvalCategory.fromJson(Map<String, dynamic> j) => EvalCategory(
        name: j['name'] as String,
        weightPct: (j['weightPct'] as num).toInt(),
        score: (j['score'] as num?)?.toDouble(),
      );
  Map<String, dynamic> toJson() => {'name': name, 'weightPct': weightPct, 'score': score};
  @override
  List<Object?> get props => [name, weightPct, score];
}


