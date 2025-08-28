import 'package:equatable/equatable.dart';

class PerformanceOverview extends Equatable {
  final int productivityPct;
  final int qualityPct;
  final int attendancePct;
  final int teamworkPct;

  const PerformanceOverview({
    required this.productivityPct,
    required this.qualityPct,
    required this.attendancePct,
    required this.teamworkPct,
  });

  factory PerformanceOverview.fromJson(Map<String, dynamic> json) => PerformanceOverview(
        productivityPct: (json['productivityPct'] as num).toInt(),
        qualityPct: (json['qualityPct'] as num).toInt(),
        attendancePct: (json['attendancePct'] as num).toInt(),
        teamworkPct: (json['teamworkPct'] as num).toInt(),
      );

  @override
  List<Object?> get props => [productivityPct, qualityPct, attendancePct, teamworkPct];
}


