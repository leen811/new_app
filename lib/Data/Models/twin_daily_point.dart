import 'package:equatable/equatable.dart';

class TwinDailyPoint extends Equatable {
  final String timeLabel;
  final int value;
  const TwinDailyPoint({required this.timeLabel, required this.value});
  factory TwinDailyPoint.fromJson(Map<String, dynamic> j) => TwinDailyPoint(timeLabel: j['timeLabel'] as String, value: (j['value'] as num).toInt());
  @override
  List<Object?> get props => [timeLabel, value];
}


