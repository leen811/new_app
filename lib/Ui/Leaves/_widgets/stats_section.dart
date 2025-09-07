import 'package:flutter/material.dart';
import '../../../Data/Models/leaves_models.dart';

class StatsSection extends StatelessWidget {
  final List<LeaveRequest> data;
  const StatsSection({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final byType = <LeaveType, int>{};
    for (final e in data) {
      byType[e.type] = (byType[e.type] ?? 0) + 1;
    }
    final total = data.length == 0 ? 1 : data.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.insights_outlined, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Text(
                'إحصاءات سريعة',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: byType.entries
                .map(
                  (e) => _MiniCard(
                    label: _typeText(e.key),
                    pct: (e.value * 100 / total).round(),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE6E9F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'متوسط زمن الرد',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                SizedBox(height: 6),
                Text(
                  '12 ساعة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _typeText(LeaveType t) => switch (t) {
    LeaveType.annual => 'سنوية',
    LeaveType.sick => 'مرضية',
    LeaveType.unpaid => 'بدون راتب',
    LeaveType.urgent => 'طارئة',
    LeaveType.permission => 'استئذان',
  };
}

class _MiniCard extends StatelessWidget {
  final String label;
  final int pct;
  const _MiniCard({required this.label, required this.pct});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF1F5F9),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$pct%'),
            ],
          ),
        ],
      ),
    );
  }
}
