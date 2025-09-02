import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Data/Models/leave_models.dart';

class PermissionHistoryItem extends StatelessWidget {
  final PermissionRecord record;

  const PermissionHistoryItem({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط الحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: record.status.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  record.status.displayName,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: record.status.color,
                  ),
                ),
              ),
              Icon(
                Icons.check_circle,
                color: record.status == RequestStatus.approved 
                    ? const Color(0xFF10B981) 
                    : const Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // نوع الاستئذان
          Text(
            record.type.displayName,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          
          // التفاصيل
          _buildDetailRow(
            'التاريخ:',
            '${record.date.year}/${record.date.month.toString().padLeft(2, '0')}/${record.date.day.toString().padLeft(2, '0')}',
          ),
          _buildDetailRow(
            'من',
            '${record.from.hour.toString().padLeft(2, '0')}:${record.from.minute.toString().padLeft(2, '0')}',
          ),
          _buildDetailRow(
            'إلى',
            '${record.to.hour.toString().padLeft(2, '0')}:${record.to.minute.toString().padLeft(2, '0')}',
          ),
          _buildDetailRow(
            'المدة:',
            record.durationText,
          ),
          _buildDetailRow(
            'السبب:',
            record.reason,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: const Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
