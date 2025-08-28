import 'package:equatable/equatable.dart';
import '../../Data/Models/twin_overview.dart';
import '../../Data/Models/twin_recommendation.dart';
import '../../Data/Models/twin_weekly_point.dart';
import '../../Data/Models/twin_daily_point.dart';

abstract class DigitalTwinState extends Equatable {
  const DigitalTwinState();
  @override
  List<Object?> get props => [];
}

class TwinLoading extends DigitalTwinState {}
class TwinError extends DigitalTwinState { final String message; const TwinError(this.message); @override List<Object?> get props => [message]; }

class TwinSuccess extends DigitalTwinState {
  final TwinOverview overview;
  final List<TwinRecommendation> recs;
  final List<TwinWeeklyPoint> weekly;
  final List<TwinDailyPoint> daily;
  final int tabIndex;
  final bool refreshing;
  const TwinSuccess({required this.overview, required this.recs, required this.weekly, required this.daily, required this.tabIndex, required this.refreshing});
  TwinSuccess copyWith({TwinOverview? overview, List<TwinRecommendation>? recs, List<TwinWeeklyPoint>? weekly, List<TwinDailyPoint>? daily, int? tabIndex, bool? refreshing}) => TwinSuccess(
    overview: overview ?? this.overview,
    recs: recs ?? this.recs,
    weekly: weekly ?? this.weekly,
    daily: daily ?? this.daily,
    tabIndex: tabIndex ?? this.tabIndex,
    refreshing: refreshing ?? this.refreshing,
  );
  @override
  List<Object?> get props => [overview, recs, weekly, daily, tabIndex, refreshing];
}


