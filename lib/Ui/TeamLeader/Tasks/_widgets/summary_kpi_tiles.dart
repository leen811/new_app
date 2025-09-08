import 'package:flutter/material.dart';
import '../../../../Data/Models/team_tasks_models.dart';

class SummaryKpiTiles extends StatelessWidget {
  final TasksSummary summary;
  const SummaryKpiTiles({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item('لم تبدأ', summary.todo, const Color(0xFFF3E8FF), Icons.playlist_remove_rounded),
      _Item('إجمالي المهام', summary.total, const Color(0xFFE7F0FF), Icons.list_alt_rounded),
      _Item('قيد العمل', summary.inProgress, const Color(0xFFFFF3CD), Icons.pending_actions_rounded),
      _Item('مراجعة', summary.review, const Color(0xFFE8F5E9), Icons.verified_user_rounded),
      _Item('متأخرة', summary.overdue, const Color(0xFFFFE8E8), Icons.warning_amber_rounded),
      _Item('مكتملة', summary.done, const Color(0xFFE8F5E9), Icons.check_circle_rounded),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final it = items[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE6E9F0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: it.bg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(it.icon, color: const Color(0xFF0F172A)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text('${it.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(it.label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Item {
  final String label;
  final int value;
  final Color bg;
  final IconData icon;
  const _Item(this.label, this.value, this.bg, this.icon);
}


