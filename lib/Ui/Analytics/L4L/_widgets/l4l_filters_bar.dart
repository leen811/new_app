import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../../Leaves/_widgets/segmented_tabs.dart';
import '../../../../Data/Models/l4l_models.dart';

class L4LFiltersBar extends StatelessWidget {
  final int periodIndex;
  final ValueChanged<int> onPeriodChanged;
  final int compareIndex;
  final ValueChanged<int> onCompareChanged;
  final List<L4LLevel> breadcrumb;
  final ValueChanged<L4LLevel> onBreadcrumbTap;
  final L4LLevel level;
  final ValueChanged<L4LLevel> onLevelChanged;

  const L4LFiltersBar({
    super.key,
    required this.periodIndex,
    required this.onPeriodChanged,
    required this.compareIndex,
    required this.onCompareChanged,
    required this.breadcrumb,
    required this.onBreadcrumbTap,
    required this.level,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Period segmented tabs
        SegmentedTabsDelegate(
          height: 44,
          tabs: [s.l4l_period_day, s.l4l_period_week, s.l4l_period_month, s.l4l_period_year],
          currentIndex: periodIndex,
          onChanged: onPeriodChanged,
        ).build(context, 0, false),
        // Compare segmented tabs
        SegmentedTabsDelegate(
          height: 44,
          tabs: [
            s.l4l_compare_day_vs_ly,
            s.l4l_compare_week_vs_prev,
            s.l4l_compare_month_vs_prev,
            s.l4l_compare_year_vs_ly,
          ],
          currentIndex: compareIndex,
          onChanged: onCompareChanged,
        ).build(context, 0, false),
        // Level selector (as chips row)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
          child: Wrap(
            spacing: 8,
            children: L4LLevel.values.map((lv) {
              final selected = lv == level;
              return ChoiceChip(
                selected: selected,
                label: Text(_labelForLevel(lv)),
                onSelected: (_) => onLevelChanged(lv),
                selectedColor: Colors.white,
                backgroundColor: const Color(0xFFF3F6FC),
                labelStyle: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? const Color(0xFF2F56D9) : const Color(0xFF667085),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              );
            }).toList(),
          ),
        ),
        // Breadcrumb chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Wrap(
            spacing: 8,
            children: breadcrumb.map((e) => ActionChip(
              label: Text(_labelForLevel(e)),
              onPressed: () => onBreadcrumbTap(e),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: const Color(0xFFF3F6FC),
            )).toList(),
          ),
        ),
      ],
    );
  }

  String _labelForLevel(L4LLevel l) {
    switch (l) {
      case L4LLevel.organization:
        return 'Organization';
      case L4LLevel.branch:
        return 'Branch';
      case L4LLevel.department:
        return 'Department';
      case L4LLevel.team:
        return 'Team';
      case L4LLevel.employee:
        return 'Employee';
    }
  }
}


