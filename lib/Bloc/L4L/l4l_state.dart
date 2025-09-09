import 'package:equatable/equatable.dart';
import '../../Data/Models/l4l_models.dart';
import 'package:flutter/material.dart';

abstract class L4LState extends Equatable {
  const L4LState();
  @override
  List<Object?> get props => [];
}

class L4LInitial extends L4LState {}
class L4LLoading extends L4LState {}

class L4LLoaded extends L4LState {
  final L4LPeriod period;
  final L4LCompare compare;
  final L4LLevel level;
  final String? levelId;
  final DateTimeRange range;
  final List<KpiDefinition> kpiDefs;
  final L4LSummary data;
  final List<L4LLevel> breadcrumb;

  const L4LLoaded({
    required this.period,
    required this.compare,
    required this.level,
    required this.levelId,
    required this.range,
    required this.kpiDefs,
    required this.data,
    required this.breadcrumb,
  });

  L4LLoaded copyWith({
    L4LPeriod? period,
    L4LCompare? compare,
    L4LLevel? level,
    String? levelId,
    DateTimeRange? range,
    List<KpiDefinition>? kpiDefs,
    L4LSummary? data,
    List<L4LLevel>? breadcrumb,
  }) {
    return L4LLoaded(
      period: period ?? this.period,
      compare: compare ?? this.compare,
      level: level ?? this.level,
      levelId: levelId ?? this.levelId,
      range: range ?? this.range,
      kpiDefs: kpiDefs ?? this.kpiDefs,
      data: data ?? this.data,
      breadcrumb: breadcrumb ?? this.breadcrumb,
    );
  }

  @override
  List<Object?> get props => [period, compare, level, levelId, range, kpiDefs, data, breadcrumb];
}

class L4LError extends L4LState {
  final String message;
  const L4LError(this.message);
  @override
  List<Object?> get props => [message];
}


