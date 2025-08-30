import 'package:equatable/equatable.dart';
import 'eval_category.dart';

class EvalRequest extends Equatable {
  final String kind; // self|peer|manager|subordinate
  final String? targetId;
  final double overall;
  final List<EvalCategory> categories;
  const EvalRequest({required this.kind, required this.overall, required this.categories, this.targetId});
  Map<String, dynamic> toJson() => {
        'kind': kind,
        'targetId': targetId,
        'overall': overall,
        'categories': categories.map((e) => e.toJson()).toList(),
      };
  @override
  List<Object?> get props => [kind, targetId, overall, categories];
}


