import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Data/Models/leave_models.dart';
import 'leave_balance_card.dart';

class LeaveBalanceSection extends StatelessWidget {
  final LeaveBalance balance;

  const LeaveBalanceSection({
    super.key,
    required this.balance,
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
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: Color(0xFF2E3A8C),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'رصيد الإجازات المتاح',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // بطاقات الرصيد
          Column(
            children: [
              LeaveBalanceCard(
                type: LeaveType.annual,
                remaining: balance.annual,
                total: 21, // TODO: جلب من API
              ),
              const SizedBox(height: 12),
              LeaveBalanceCard(
                type: LeaveType.sick,
                remaining: balance.sick,
                total: 5, // TODO: جلب من API
              ),
              const SizedBox(height: 12),
              LeaveBalanceCard(
                type: LeaveType.emergency,
                remaining: balance.emergency,
                total: 3, // TODO: جلب من API
              ),
            ],
          ),
        ],
      ),
    );
  }
}
