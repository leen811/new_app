import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kpi_small_card.dart';
import '../../../../Bloc/attendance/attendance_bloc.dart';
import '../../../../Bloc/attendance/attendance_state.dart';

class WorkHoursCard extends StatelessWidget {
  final Duration shift;

  const WorkHoursCard({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        // استخدام إجمالي ساعات العمل من بيانات الحضور (مع الاستراحات)
        final worked = state.totalWorkDuration;
        final pct = (worked.inSeconds / shift.inSeconds).clamp(0.0, 1.0);
        final remaining = shift - worked;
        
        final workedHours = worked.inHours;
        final workedMinutes = worked.inMinutes % 60;
        final remainingHours = remaining.inHours;
        final remainingMinutes = remaining.inMinutes % 60;
        final shiftHours = shift.inHours;

        return KpiSmallCard(
          icon: Icons.schedule_rounded,
          iconColor: const Color(0xFF2563EB),
          iconBg: const Color(0xFFEFF6FF),
          title: 'ساعات الدوام اليوم',
          value: Text('$workedHoursس $workedMinutesد'),
          footer: LayoutBuilder(
            builder: (context, constraints) {
              // إظهار النص المساعد فقط على الشاشات الأوسع
              final showHelperText = constraints.maxHeight > 132;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 6,
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                      ),
                    ),
                  ),
                  if (showHelperText) ...[
                    const SizedBox(height: 4),
                    Text(
                      'متبقي $remainingHoursس $remainingMinutesد من $shiftHoursس',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }
}
