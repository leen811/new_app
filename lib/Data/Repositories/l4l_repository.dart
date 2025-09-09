import 'dart:math';

import 'package:flutter/material.dart';

import '../Models/l4l_models.dart';

abstract class L4LRepository {
  Future<L4LSummary> fetch({
    required L4LPeriod period,
    required L4LCompare compare,
    required L4LLevel level,
    String? levelId,
    DateTimeRange? range,
    List<String> kpiKeys = const [
      'revenue_total',
      'revenue_by_department',
      'attendance_support',
      'avg_completion_time',
      'challenges_engagement',
    ],
  });
}

class MockL4LRepository implements L4LRepository {

  @override
  Future<L4LSummary> fetch({
    required L4LPeriod period,
    required L4LCompare compare,
    required L4LLevel level,
    String? levelId,
    DateTimeRange? range,
    List<String> kpiKeys = const [
      'revenue_total',
      'revenue_by_department',
      'attendance_support',
      'avg_completion_time',
      'challenges_engagement',
    ],
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final DateTimeRange usedRange = range ?? _defaultRangeFor(period);

    // Generate current series and baseline for each KPI
    final Map<String, List<TimeSeriesPoint>> series = {};
    final List<KpiValue> kpis = [];
    final List<HeatCell> heat = [];

    for (final key in kpiKeys) {
      final currentSeries = _genSeries(period, usedRange, seed: key.hashCode);
      final baselineSeries = _genBaseline(period, usedRange, compare, currentSeries, seed: key.hashCode + 7);

      series['$key.current'] = currentSeries;
      series['$key.baseline'] = baselineSeries;

      final double current = currentSeries.isEmpty ? 0 : currentSeries.last.v;
      final double baseline = baselineSeries.isEmpty ? 0 : baselineSeries.last.v;
      final double delta = current - baseline;
      final double deltaPct = baseline == 0 ? 0 : (delta / baseline) * 100.0;
      kpis.add(KpiValue(key: key, current: current, baseline: baseline, delta: delta, deltaPct: deltaPct));

      heat.addAll(_genHeat(period, usedRange, seed: key.hashCode + 97));
    }

    return L4LSummary(kpis: kpis, series: series, heat: heat);
  }

  DateTimeRange _defaultRangeFor(L4LPeriod p) {
    final now = DateTime.now();
    switch (p) {
      case L4LPeriod.day:
        return DateTimeRange(start: DateTime(now.year, now.month, now.day), end: DateTime(now.year, now.month, now.day, 23, 59, 59));
      case L4LPeriod.week:
        final start = now.subtract(Duration(days: now.weekday % 7));
        final end = start.add(const Duration(days: 6, hours: 23, minutes: 59));
        return DateTimeRange(start: DateTime(start.year, start.month, start.day), end: end);
      case L4LPeriod.month:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
      case L4LPeriod.year:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
    }
  }

  List<TimeSeriesPoint> _genSeries(L4LPeriod p, DateTimeRange r, {required int seed}) {
    final rnd = Random(seed);
    final List<TimeSeriesPoint> out = [];
    if (p == L4LPeriod.day) {
      final start = r.start;
      for (int h = 0; h < 24; h++) {
        out.add(TimeSeriesPoint(t: start.add(Duration(hours: h)), v: 50 + rnd.nextInt(50) + rnd.nextDouble()));
      }
    } else if (p == L4LPeriod.week) {
      for (int d = 0; d < 7; d++) {
        out.add(TimeSeriesPoint(t: r.start.add(Duration(days: d)), v: 200 + rnd.nextInt(200) + rnd.nextDouble()));
      }
    } else if (p == L4LPeriod.month) {
      final days = DateUtils.getDaysInMonth(r.start.year, r.start.month);
      for (int d = 0; d < days; d++) {
        out.add(TimeSeriesPoint(t: DateTime(r.start.year, r.start.month, d + 1), v: 150 + rnd.nextInt(250) + rnd.nextDouble()));
      }
    } else {
      for (int m = 0; m < 12; m++) {
        out.add(TimeSeriesPoint(t: DateTime(r.start.year, m + 1, 1), v: 1000 + rnd.nextInt(1500) + rnd.nextDouble()));
      }
    }
    return out;
  }

  List<TimeSeriesPoint> _genBaseline(
    L4LPeriod p,
    DateTimeRange r,
    L4LCompare compare,
    List<TimeSeriesPoint> current,
    {required int seed}
  ) {
    final rnd = Random(seed);
    final List<TimeSeriesPoint> base = [];

    switch (compare) {
      case L4LCompare.day_vs_same_day_last_year:
        for (final pt in current) {
          base.add(TimeSeriesPoint(t: DateTime(pt.t.year - 1, pt.t.month, pt.t.day, pt.t.hour), v: pt.v * (0.9 + rnd.nextDouble() * 0.2)));
        }
        break;
      case L4LCompare.week_vs_prev_week:
        for (final pt in current) {
          base.add(TimeSeriesPoint(t: pt.t.subtract(const Duration(days: 7)), v: pt.v * (0.92 + rnd.nextDouble() * 0.16)));
        }
        break;
      case L4LCompare.month_vs_prev_month:
        for (final pt in current) {
          base.add(TimeSeriesPoint(t: DateTime(pt.t.year, pt.t.month - 1, pt.t.day), v: pt.v * (0.93 + rnd.nextDouble() * 0.14)));
        }
        break;
      case L4LCompare.year_vs_last_year:
        for (final pt in current) {
          base.add(TimeSeriesPoint(t: DateTime(pt.t.year - 1, pt.t.month, pt.t.day), v: pt.v * (0.95 + rnd.nextDouble() * 0.12)));
        }
        break;
    }
    return base;
  }

  List<HeatCell> _genHeat(L4LPeriod p, DateTimeRange r, {required int seed}) {
    final rnd = Random(seed);
    final List<HeatCell> out = [];
    if (p == L4LPeriod.day) {
      for (int h = 0; h < 24; h++) {
        out.add(HeatCell(bucket: r.start.add(Duration(hours: h)), v: rnd.nextDouble()));
      }
    } else if (p == L4LPeriod.week) {
      for (int d = 0; d < 7; d++) {
        out.add(HeatCell(bucket: r.start.add(Duration(days: d)), v: rnd.nextDouble()));
      }
    } else if (p == L4LPeriod.month) {
      final days = DateUtils.getDaysInMonth(r.start.year, r.start.month);
      for (int d = 0; d < days; d++) {
        out.add(HeatCell(bucket: DateTime(r.start.year, r.start.month, d + 1), v: rnd.nextDouble()));
      }
    } else {
      for (int m = 0; m < 12; m++) {
        out.add(HeatCell(bucket: DateTime(r.start.year, m + 1, 1), v: rnd.nextDouble()));
      }
    }
    return out;
  }
}


