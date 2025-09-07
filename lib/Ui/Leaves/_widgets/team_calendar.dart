import 'package:flutter/material.dart';
import '../../../Data/Models/leaves_models.dart';

class TeamCalendar extends StatefulWidget {
  final List<LeaveRequest> monthEvents;
  final void Function(int year, int month) onMonthChanged;
  final ValueChanged<String> onTapRequest;
  const TeamCalendar({
    super.key,
    required this.monthEvents,
    required this.onMonthChanged,
    required this.onTapRequest,
  });
  @override
  State<TeamCalendar> createState() => _TeamCalendarState();
}

class _TeamCalendarState extends State<TeamCalendar> {
  late DateTime _cursor;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _cursor = DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final firstWeekday =
        DateTime(_cursor.year, _cursor.month, 1).weekday % 7; // 0 = الأحد
    final daysInMonth = DateUtils.getDaysInMonth(_cursor.year, _cursor.month);
    final cells = firstWeekday + daysInMonth;
    final rows = (cells / 7).ceil();
    final hasSixRows = rows >= 6;
    final aspect = hasSixRows ? 0.82 : 0.80; // زيادة ارتفاع الخلية عند 6 أسطر
    final spacing = hasSixRows ? 6.0 : 3.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: _prev,
                icon: const Icon(Icons.chevron_right),
              ),
              const Spacer(),
              Text(
                '${_cursor.year} / ${_cursor.month}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: _next,
                icon: const Icon(Icons.chevron_left),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(12, 0, 12, hasSixRows ? 8 : 12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspect,
          ),
          itemCount: rows * 4,
          itemBuilder: (context, i) {
            final dayNum = i - firstWeekday + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const SizedBox.shrink();
            }
            final date = DateTime(_cursor.year, _cursor.month, dayNum);
            final dayEvents = widget.monthEvents
                .where(
                  (e) =>
                      e.startAt.year == date.year &&
                      e.startAt.month == date.month &&
                      e.startAt.day == date.day,
                )
                .toList();
            return _DayCell(
              day: dayNum,
              events: dayEvents,
              onTapRequest: widget.onTapRequest,
            );
          },
        ),
      ],
    );
  }

  void _prev() {
    setState(() {
      _cursor = DateTime(_cursor.year, _cursor.month - 1, 1);
    });
    widget.onMonthChanged(_cursor.year, _cursor.month);
  }

  void _next() {
    setState(() {
      _cursor = DateTime(_cursor.year, _cursor.month + 1, 1);
    });
    widget.onMonthChanged(_cursor.year, _cursor.month);
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final List<LeaveRequest> events;
  final ValueChanged<String> onTapRequest;
  const _DayCell({
    required this.day,
    required this.events,
    required this.onTapRequest,
  });
  @override
  Widget build(BuildContext context) {
    final color = events.isEmpty
        ? const Color(0xFFF8FAFC)
        : const Color(0xFFEFF6FF);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:
            [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ]
              ..addAll(
                events
                    .take(2)
                    .map((e) => _Pill(e: e, onTap: () => onTapRequest(e.id)))
                    .toList(),
              )
              ..addAll(
                events.length > 2
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${events.length - 2} أخرى',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ]
                    : [],
              ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final LeaveRequest e;
  final VoidCallback onTap;
  const _Pill({required this.e, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = switch (e.type) {
      LeaveType.annual => const Color(0xFF22C55E),
      LeaveType.sick => const Color(0xFF3B82F6),
      LeaveType.unpaid => const Color(0xFFF59E0B),
      LeaveType.urgent => const Color(0xFFEF4444),
      LeaveType.permission => const Color(0xFF8B5CF6),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: c.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _label(e),
            style: TextStyle(fontSize: 8, color: c),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  String _label(LeaveRequest e) => e.isPermission
      ? 'استئذان ${_t(e.timeFrom)}-${_t(e.timeTo)}'
      : _typeText(e.type);
  String _typeText(LeaveType t) => switch (t) {
    LeaveType.annual => 'سنوية',
    LeaveType.sick => 'مرضية',
    LeaveType.unpaid => 'بدون راتب',
    LeaveType.urgent => 'طارئة',
    LeaveType.permission => 'استئذان',
  };
  String _t(TimeOfDay? t) => t == null
      ? ''
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
