import 'package:equatable/equatable.dart';

class EvalResultRow extends Equatable {
  final String category;
  final double overall;
  final double self;
  final double manager;
  final double peers;
  final double subs;
  const EvalResultRow({required this.category, required this.overall, required this.self, required this.manager, required this.peers, required this.subs});
  factory EvalResultRow.fromJson(Map<String, dynamic> j) => EvalResultRow(
        category: j['category'] as String,
        overall: (j['overall'] as num).toDouble(),
        self: (j['self'] as num).toDouble(),
        manager: (j['manager'] as num).toDouble(),
        peers: (j['peers'] as num).toDouble(),
        subs: (j['subs'] as num).toDouble(),
      );
  Map<String, dynamic> toJson() => {'category': category, 'overall': overall, 'self': self, 'manager': manager, 'peers': peers, 'subs': subs};
  @override
  List<Object?> get props => [category, overall, self, manager, peers, subs];
}


