import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:new_app/Data/Models/payroll_models.dart';

class CardMandatory extends StatelessWidget {
  final List<DeductionItem> items;
  final bool dense;

  const CardMandatory({
    super.key,
    required this.items,
    this.dense = true,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern("ar");
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'الخصومات الإلزامية',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF374151),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: const Color(0xFF6B7280).withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // العناصر
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              
              return Column(
                children: [
                  ListTile(
                    dense: dense,
                    visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.title,
                      style: GoogleFonts.cairo(
                        fontSize: dense ? 14 : 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    trailing: Text(
                      'ريال ${numberFormat.format(item.amount)}',
                      style: GoogleFonts.cairo(
                        fontSize: dense ? 14 : 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE53935),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      color: const Color(0xFFEEF1F6),
                      height: 1,
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
