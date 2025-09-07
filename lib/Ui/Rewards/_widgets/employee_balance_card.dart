import 'package:flutter/material.dart';
import '../../../Data/Models/rewards_models.dart';

class EmployeeBalanceCard extends StatelessWidget {
  final EmployeeTokenBalance item;
  const EmployeeBalanceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          //  CircleAvatar(
          //       radius: 35,
          //       backgroundImage: item.avatarUrl != null
          //           ? NetworkImage(item.avatarUrl!)
          //           : null,
          //       child: item.avatarUrl == null ? const Icon(Icons.person) : null,
          //     ),
          Row(
            children: [
              const SizedBox(width: 12),
              // وسط: بيانات الموظف والأداء
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.title} • ${item.department}',
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 8),
                    const Text('الأداء'),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        color: const Color.fromARGB(255, 47, 152, 48),
                        value: (item.rating / 5).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF3F4F6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'آخر نشاط: ${item.lastActivity}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // يسار: الصورة والأزرار
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      side: const BorderSide(color: Color(0xFF667085)),
                      foregroundColor: const Color(0xFF667085),
                    ),
                    onPressed: () {},
                    child: const Text('عرض التفاصيل'),
                  ),
                  const SizedBox(height: 6),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {},
                    child: const Text('منح توكينز +'),
                  ),
                  Text(
                    '${item.points}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'المكسب الكلي',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                  Text(
                    '${item.earnedTotal}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
