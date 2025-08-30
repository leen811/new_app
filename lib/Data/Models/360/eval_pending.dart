import 'package:equatable/equatable.dart';
import 'eval_user.dart';

class EvalPending extends Equatable {
  final String id;
  final String kind; // self|peer|manager|subordinate
  final String status; // في الانتظار | مكتمل
  final EvalUser target;
  const EvalPending({required this.id, required this.kind, required this.status, required this.target});
  factory EvalPending.fromJson(Map<String, dynamic> j) => EvalPending(
        id: j['id'] as String,
        kind: j['kind'] as String,
        status: j['status'] as String,
        target: EvalUser.fromJson(j['target'] as Map<String, dynamic>),
      );
  @override
  List<Object?> get props => [id, kind, status, target];
}


