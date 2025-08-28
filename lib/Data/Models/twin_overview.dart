import 'package:equatable/equatable.dart';

class TwinOverview extends Equatable {
  final int focusPct;
  final int energyPct;
  final int weeklyProdPct;
  final int lifeBalancePct;
  final double idealHours;
  final int stressPct;

  const TwinOverview({
    required this.focusPct,
    required this.energyPct,
    required this.weeklyProdPct,
    required this.lifeBalancePct,
    required this.idealHours,
    required this.stressPct,
  });

  factory TwinOverview.fromJson(Map<String, dynamic> j) => TwinOverview(
        focusPct: (j['focusPct'] as num).toInt(),
        energyPct: (j['energyPct'] as num).toInt(),
        weeklyProdPct: (j['weeklyProdPct'] as num).toInt(),
        lifeBalancePct: (j['lifeBalancePct'] as num).toInt(),
        idealHours: (j['idealHours'] as num).toDouble(),
        stressPct: (j['stressPct'] as num).toInt(),
      );

  @override
  List<Object?> get props => [focusPct, energyPct, weeklyProdPct, lifeBalancePct, idealHours, stressPct];
}


