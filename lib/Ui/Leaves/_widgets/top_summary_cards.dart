import 'package:flutter/material.dart';

class TopSummaryCards extends StatelessWidget {
  final int pending;
  final int onLeaveNow;
  final int todayOut;
  final int avgHrs;

  const TopSummaryCards({
    super.key,
    required this.pending,
    required this.onLeaveNow,
    required this.todayOut,
    required this.avgHrs,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item('قيد المراجعة', pending, const Color(0xFFFFF3CD), Icons.pending_actions),
      _Item('على إجازة الآن', onLeaveNow, const Color(0xFFE8F5E9), Icons.beach_access),
      _Item('خارج اليوم', todayOut, const Color(0xFFE7F0FF), Icons.schedule),
      _Item('متوسط الرد (س)', avgHrs, const Color(0xFFF3E8FF), Icons.timelapse),
    ];
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.4,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) {
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
        childCount: items.length,
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


