import 'package:flutter/material.dart';
import '../../../Data/Models/meetings_models.dart';
import 'edit_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/Meetings/meetings_bloc.dart';
import '../../../Bloc/Meetings/meetings_event.dart';

class MeetingCard extends StatelessWidget {
  final Meeting item;
  const MeetingCard({super.key, required this.item});

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
        if (item.description.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        ],
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.event, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 6),
          Text('${MaterialLocalizations.of(context).formatMediumDate(item.date)} • ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(item.date), alwaysUse24HourFormat: true)}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
          const Spacer(),
          const Icon(Icons.timelapse_rounded, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 4),
          Text('${item.durationMinutes}د', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.place_rounded, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 6),
          Expanded(child: Text(item.placeOrLink ?? '-', style: const TextStyle(fontSize: 12, color: Color(0xFF667085)), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.groups_rounded, size: 14, color: Color(0xFF98A2B3)),
          const SizedBox(width: 4),
          Text('${item.participantIds.length}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
          const Spacer(),
          OutlinedButton(onPressed: () => showEditMeetingSheet(context, item), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: Color(0xFFE6EAF2))), child: const Text('تعديل')),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: () async {
            final ok = await showDialog<bool>(context: context, builder: (d) => AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text('تأكيد الحذف'),
              content: const Text('هل تريد حذف هذا الاجتماع؟'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('إلغاء')),
                ElevatedButton(style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white), onPressed: () => Navigator.pop(d, true), child: const Text('حذف')),
              ],
            ));
            if (ok == true) {
              context.read<MeetingsBloc>().add(MeetingDelete(item.id));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف الاجتماع')));
            }
          }, style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: Color(0xFFE6EAF2))), child: const Text('حذف')),
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


