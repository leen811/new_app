import 'package:equatable/equatable.dart';

class EvalSummary extends Equatable {
  final String cycleName;
  final double overall;
  final double self;
  final double manager;
  final double peers;
  final int subs; // completed or pending count
  const EvalSummary({required this.cycleName, required this.overall, required this.self, required this.manager, required this.peers, required this.subs});
  factory EvalSummary.fromJson(Map<String, dynamic> j) => EvalSummary(
        cycleName: j['cycleName'] as String,
        overall: (j['overall'] as num).toDouble(),
        self: (j['self'] as num).toDouble(),
        manager: (j['manager'] as num).toDouble(),
        peers: (j['peers'] as num).toDouble(),
        subs: (j['subs'] as num).toInt(),
      );
  Map<String, dynamic> toJson() => {
        'cycleName': cycleName,
        'overall': overall,
        'self': self,
        'manager': manager,
        'peers': peers,
        'subs': subs,
      };
  @override
  List<Object?> get props => [cycleName, overall, self, manager, peers, subs];
}


