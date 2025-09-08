import 'package:flutter/material.dart';
import '../../../Data/Models/meetings_models.dart';

class MyMeetingCard extends StatelessWidget {
  final Meeting item;
  final ValueChanged<Meeting> onJoin;
  final ValueChanged<Meeting>? onAddCalendar;
  const MyMeetingCard({super.key, required this.item, required this.onJoin, this.onAddCalendar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: const [BoxShadow(color: Color(0x0F0B1524), blurRadius: 10, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800))),
          _priorityChip(item.priority),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.event, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 6),
          Text(
            '${MaterialLocalizations.of(context).formatMediumDate(item.date)} • ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(item.date), alwaysUse24HourFormat: true)}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
          const Spacer(),
          const Icon(Icons.timelapse_rounded, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 4),
          Text('${item.durationMinutes}د', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.link_rounded, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 6),
          Expanded(child: Text(item.placeOrLink ?? '-', style: const TextStyle(fontSize: 12, color: Color(0xFF667085)), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.groups_rounded, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 4),
          Text('${item.participantIds.length}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
          const Spacer(),
          FilledButton(
            onPressed: () => onJoin(item),
            style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('انضمام'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onAddCalendar == null ? null : () => onAddCalendar!(item),
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: Color(0xFFE6EAF2))),
            child: const Text('إضافة للتقويم'),
          ),
        ]),
      ]),
    );
  }

  Widget _priorityChip(MeetingPriority p) {
    String label = 'متوسطة';
    Color bg = const Color(0xFFF3E8FF);
    Color fg = const Color(0xFF0F172A);
    if (p == MeetingPriority.low) { label = 'منخفضة'; bg = const Color(0xFFE7F0FF); }
    if (p == MeetingPriority.high) { label = 'عالية'; bg = const Color(0xFFFFE8E8); fg = const Color(0xFFB91C1C); }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)), child: Text(label, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600)));
  }
}


