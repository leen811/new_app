import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Data/Models/team_lead_models.dart';
import '../../../Common/press_fx.dart';

class TlTeamPerformance extends StatelessWidget {
  final List<MemberPerf> list;
  
  const TlTeamPerformance({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE6E9F0)),
      ),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // العنوان
            Row(
              children: [
                Text(
                  'نظرة عامة على أداء الفريق',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                Text(
                  'أداء أعضاء الفريق',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.groups_2_rounded,
                  size: 18,
                  color: const Color(0xFF6B7280),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // قائمة الأعضاء
            ...list.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              final isLast = index == list.length - 1;
              
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // يمكن إضافة تفاعل هنا لاحقاً
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                            // النسبة المئوية والشارة
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // النسبة المئوية
                                Text(
                                  '${member.score}%',
                                  style: GoogleFonts.cairo(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // شارة الأداء
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: member.badgeColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    member.badge,
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: member.badgeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // الاسم والدور
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    member.name,
                                    style: GoogleFonts.cairo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    member.role,
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      color: const Color(0xFF6B7280),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ).withPressFX(),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: const Color(0xFFEEF1F6),
                    ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
