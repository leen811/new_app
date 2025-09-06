import 'package:flutter/material.dart';
import '../../../Data/Models/attendance_models.dart';

class SessionCard extends StatelessWidget {
  final AttendanceSession session;
  const SessionCard({super.key, required this.session});
  @override
  Widget build(BuildContext context) {
    String fmt(TimeOfDay t) => t.format(context).replaceAll('AM', 'ص').replaceAll('PM', 'م');
    final inTime = fmt(TimeOfDay.fromDateTime(session.inAt));
    final outTime = fmt(TimeOfDay.fromDateTime(session.outAt));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6E9F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Icon(Icons.login_rounded, color: Color(0xFF16A34A)),
            const SizedBox(width: 8),
            Expanded(child: Text('تشيك إن: $inTime • ${session.inLocation}')),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Expanded(child: Text('تشيك أوت: $outTime • ${session.outLocation}')),
          ]),
          if (session.note != null) ...[
            const SizedBox(height: 6),
            Text('تعليق: ${session.note}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          ],
        ],
      ),
    );
  }
}


