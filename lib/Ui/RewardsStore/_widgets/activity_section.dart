import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Data/Models/rewards_models.dart';

class ActivitySection extends StatelessWidget {
  final List<ActivityItem> items;
  
  const ActivitySection({
    super.key,
    required this.items,
  });
  
  // لون موحد للعناصر
  Color _getItemColor(int index) {
    return const Color(0xFFF59E0B); // برتقالي موحد
  }
  
  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd', 'ar');
    
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1524).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ترويسة القسم
            Row(
              children: [
                const Icon(
                  Icons.history_toggle_off,
                  size: 18,
                  color: Color(0xFF667085),
                ),
                const SizedBox(width: 6),
                const Text(
                  'النشاط الأخير',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // عناصر النشاط
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final itemColor = _getItemColor(index);
              
              return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: itemColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: itemColor.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:                       Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                  ),
                  Row(
                    children: [
                      if (item.coinsDelta != null && item.coinsDelta! > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: itemColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${item.coinsDelta} كوينز',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: itemColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        dateFormatter.format(item.date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
            }).toList(),
          ],
        ),
      );
    }
  }

