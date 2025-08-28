import 'package:equatable/equatable.dart';

class TwinWeeklyPoint extends Equatable {
  final String dayAr;
  final int energy;
  final int productivity;
  const TwinWeeklyPoint({required this.dayAr, required this.energy, required this.productivity});
  factory TwinWeeklyPoint.fromJson(Map<String, dynamic> j) => TwinWeeklyPoint(dayAr: j['dayAr'] as String, energy: (j['energy'] as num).toInt(), productivity: (j['productivity'] as num).toInt());
  @override
  List<Object?> get props => [dayAr, energy, productivity];
}


