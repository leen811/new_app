import 'package:flutter/material.dart';
import '../../../Data/Models/attendance_models.dart';

class DayWorkRow extends StatelessWidget {
  final EmployeeDayAttendance day;
  final int shiftMinutes;
  final VoidCallback? onTap;

  const DayWorkRow({
    super.key,
    required this.day,
    required this.shiftMinutes,
    this.onTap,
  });

  String _fmtH(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    int gross = 0, breaks = 0;
    for (final s in day.sessions) {
      // حماية لو صار outAt = inAt أو أخطاء بيانات
      final diff = s.outAt.difference(s.inAt).inMinutes;
      if (diff > 0) gross += diff;
      breaks += s.breaksMinutes;
    }

    final netMinutes = (gross - breaks).clamp(0, 24 * 60 * 2); // سقف احتياطي
    final net = Duration(minutes: netMinutes);
    final overtimeMin = (net.inMinutes - shiftMinutes) > 0
        ? (net.inMinutes - shiftMinutes)
        : 0;

    // شارة الحالة
    late final Color badgeColor;
    late final String badgeText;
    if (day.sessions.isEmpty) {
      badgeColor = const Color(0xFFEF4444); // أحمر
      badgeText = 'Absent';
    } else if (net.inMinutes >= shiftMinutes) {
      badgeColor = const Color(0xFF16A34A); // أخضر
      badgeText = 'Completed';
    } else {
      badgeColor = const Color(0xFFF59E0B); // برتقالي
      badgeText = 'Partial';
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E9F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس اليوم (اسم اليوم + التاريخ) بعرض البطاقة
            Row(
              children: [
                _DayChip(date: day.day),
                // صف القيم التفصيلية لليوم
                const SizedBox(width: 6),

                Expanded(
                  child: _ValueWithLabel(
                    value: _inStr(day.sessions),
                    label: 'الدخول',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _ValueWithLabel(
                    value: _fmtH(Duration(minutes: breaks)),
                    label: 'البريك',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _ValueWithLabel(
                    value: _outStr(day.sessions),
                    label: 'الخروج',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _ValueWithLabel(
                    value: _fmtH(Duration(minutes: overtimeMin)),
                    label: 'أوفر تايم',
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 56,
                  child: _ValueWithLabel(
                    value: _fmtH(Duration(minutes: net.inMinutes)),
                    label: 'إجمالي الساعات',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 0.6),
            const SizedBox(height: 8),
            // حالة الحضور كقسم ضمن نفس البطاقة (مكتمل/جزئي/غائب)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // أول Check-in
  String _inStr(List<AttendanceSession> sessions) {
    if (sessions.isEmpty) return '—';
    final first = sessions.reduce((a, b) => a.inAt.isBefore(b.inAt) ? a : b);
    final hh = first.inAt.hour.toString().padLeft(2, '0');
    final mm = first.inAt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  // أول Check-out (المقترن بأول سيشن)
  String _outStr(List<AttendanceSession> sessions) {
    if (sessions.isEmpty) return '—';
    final first = sessions.reduce((a, b) => a.inAt.isBefore(b.inAt) ? a : b);
    final hh = first.outAt.hour.toString().padLeft(2, '0');
    final mm = first.outAt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _ValueWithLabel extends StatelessWidget {
  final String value;
  final String label;
  const _ValueWithLabel({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  final DateTime date;
  const _DayChip({required this.date});

  @override
  Widget build(BuildContext context) {
    // Sun..Sat
    final dayShort = const [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ][(DateTime(date.year, date.month, date.day).weekday) % 7];

    final now = DateTime.now();
    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;

    // عطلة السعودية: جمعة/سبت
    final isFriSat = date.weekday == 5 || date.weekday == 6;

    final bg = isToday
        ? const Color(0xFFEFF6FF)
        : (isFriSat ? const Color(0xFFF3F4F6) : const Color(0xFFF3F6FC));

    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            dayShort,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            '${_monthShort(date.month)} ${date.day}',
            style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  String _monthShort(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(m - 1) % 12];
  }
}
