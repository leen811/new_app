import 'package:flutter/material.dart';
import '../../../Data/Models/meetings_models.dart';

class AvailabilityBadge extends StatelessWidget {
  final RoomAvailability? availability;
  final bool checking;
  const AvailabilityBadge({super.key, required this.availability, required this.checking});

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (checking) {
      content = Row(children: const [SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)), SizedBox(width: 8), Text('جارِ التحقق...', style: TextStyle(fontSize: 12))]);
    } else if (availability == null) {
      content = const Text('—', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)));
    } else if (availability!.isFree) {
      content = Row(children: const [Icon(Icons.check_circle, size: 14, color: Color(0xFF16A34A)), SizedBox(width: 6), Text('الغرفة متاحة', style: TextStyle(fontSize: 12, color: Color(0xFF0F172A)))]);
    } else {
      final n = availability!.conflicts.length;
      content = Row(children: [const Icon(Icons.error_outline, size: 14, color: Color(0xFFB91C1C)), const SizedBox(width: 6), Text('الغرفة مشغولة ($n)', style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))) ]);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6E9F0)),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: content,
    );
  }
}


