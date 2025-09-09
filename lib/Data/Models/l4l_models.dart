import 'package:flutter/material.dart';

enum L4LPeriod { day, week, month, year }

enum L4LCompare {
  day_vs_same_day_last_year,
  week_vs_prev_week,
  month_vs_prev_month,
  year_vs_last_year,
}

enum L4LLevel { organization, branch, department, team, employee }

class KpiDefinition {
  final String key;
  final String title;
  final bool isInverted;
  const KpiDefinition({required this.key, required this.title, this.isInverted = false});
}

class KpiValue {
  final String key;
  final double current;
  final double baseline;
  final double delta;
  final double deltaPct;
  const KpiValue({required this.key, required this.current, required this.baseline, required this.delta, required this.deltaPct});
}

class TimeSeriesPoint {
  final DateTime t;
  final double v;
  const TimeSeriesPoint({required this.t, required this.v});
}

class HeatCell {
  final DateTime bucket;
  final double v;
  const HeatCell({required this.bucket, required this.v});
}

class L4LSummary {
  final List<KpiValue> kpis;
  final Map<String, List<TimeSeriesPoint>> series;
  final List<HeatCell> heat;
  const L4LSummary({required this.kpis, required this.series, required this.heat});
}

@immutable
class DateTimeRangeExt {
  // Placeholder to ensure material import is used; real DateTimeRange is used in repository
  const DateTimeRangeExt();
}


