import 'package:flutter/material.dart';
import '../../../Data/Models/attendance_models.dart';

class EmployeePresenceTile extends StatelessWidget {
  final EmployeePresence item;
  final VoidCallback? onTap;
  const EmployeePresenceTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusBg = item.isCheckedIn ? const Color(0xFFE8F5E9) : const Color(0xFFF3F4F6);
    final statusFg = item.isCheckedIn ? const Color(0xFF16A34A) : const Color(0xFF9AA3B2);
    final statusIcon = item.isCheckedIn ? Icons.verified_rounded : Icons.remove_circle_outline;
    final timeText = item.lastCheckInAt != null
        ? TimeOfDay.fromDateTime(item.lastCheckInAt!).format(context).replaceAll('AM', 'ص').replaceAll('PM', 'م')
        : '-';
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E9F0)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE6E9F0),
              backgroundImage: item.avatarUrl != null ? NetworkImage(item.avatarUrl!) : null,
              child: item.avatarUrl == null ? Text(item.name.characters.first) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [Icon(statusIcon, color: statusFg, size: 18), const SizedBox(width: 4), Text(item.isCheckedIn ? 'حاضر الآن' : 'غير موجود', style: TextStyle(color: statusFg))]),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(item.department, style: const TextStyle(color: Color(0xFF6B7280))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text('آخر موقع: ${item.lastLocationName ?? '-'}', style: const TextStyle(color: Color(0xFF6B7280))),
                      ),
                      Text('آخر دخول: $timeText', style: const TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


