import 'package:equatable/equatable.dart';
import '../../Data/Models/l4l_models.dart';
import 'package:flutter/material.dart';

abstract class L4LEvent extends Equatable {
  const L4LEvent();
  @override
  List<Object?> get props => [];
}

class L4LLoad extends L4LEvent {
  const L4LLoad();
}

class L4LChangePeriod extends L4LEvent {
  final L4LPeriod period;
  const L4LChangePeriod(this.period);
  @override
  List<Object?> get props => [period];
}

class L4LChangeCompare extends L4LEvent {
  final L4LCompare compare;
  const L4LChangeCompare(this.compare);
  @override
  List<Object?> get props => [compare];
}

class L4LChangeLevel extends L4LEvent {
  final L4LLevel level;
  final String? id;
  const L4LChangeLevel(this.level, {this.id});
  @override
  List<Object?> get props => [level, id];
}

class L4LChangeRange extends L4LEvent {
  final DateTimeRange range;
  const L4LChangeRange(this.range);
  @override
  List<Object?> get props => [range];
}

class L4LRefresh extends L4LEvent {
  const L4LRefresh();
}


