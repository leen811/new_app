import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Data/Models/leave_models.dart';
import 'leave_history_item.dart';

class LeaveHistorySection extends StatelessWidget {
  final List<LeaveRecord> history;

  const LeaveHistorySection({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: Color(0xFF2E3A8C),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'تاريخ الإجازات',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // قائمة الإجازات أو رسالة فارغة
          if (history.isEmpty)
            _buildEmptyState()
          else
            ...history.map((record) => LeaveHistoryItem(record: record)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.beach_access_outlined,
            size: 48,
            color: const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد طلبات إجازة',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم تقم بإرسال أي طلبات إجازة بعد',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
