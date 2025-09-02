import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Data/Models/employee_home_models.dart';

class TodayListSection extends StatelessWidget {
  final List<TodayActivity> activities;

  const TodayListSection({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: const Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'أنشطة اليوم',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // الوصف
          Text(
            'جدولك اليومي ومهامك',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // قائمة الأنشطة
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == activities.length - 1;
            
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    activity.title,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  subtitle: Text(
                    activity.time,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(activity.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      activity.status.displayText,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: const Color(0xFFE9EEF5),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Color _getStatusColor(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.completed:
        return const Color(0xFF2563EB);
      case ActivityStatus.upcoming:
        return const Color(0xFFF97316);
    }
  }
}
