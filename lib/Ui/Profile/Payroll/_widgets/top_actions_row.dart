import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopActionsRow extends StatelessWidget {
  final String monthLabel;
  final VoidCallback onExport;
  final Function(int month, int year) onPickMonth;

  const TopActionsRow({
    super.key,
    required this.monthLabel,
    required this.onExport,
    required this.onPickMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          // زر التصدير (يسار)
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: onExport,
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: Text(
                'تصدير كشف الراتب',
                style: GoogleFonts.cairo(fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),

          const Spacer(),

          // اختيار الشهر (يمين)
          InkWell(
            onTap: () => _showMonthYearPicker(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE6E9F0)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    monthLabel,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.expand_more,
                    size: 18,
                    color: Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedMonth = DateTime.now().month;
        int selectedYear = DateTime.now().year;
        
        return AlertDialog(
          title: Text(
            'اختر الشهر والسنة',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // اختيار الشهر
                  DropdownButtonFormField<int>(
                    value: selectedMonth,
                    decoration: InputDecoration(
                      labelText: 'الشهر',
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      {'value': 1, 'label': 'يناير'},
                      {'value': 2, 'label': 'فبراير'},
                      {'value': 3, 'label': 'مارس'},
                      {'value': 4, 'label': 'أبريل'},
                      {'value': 5, 'label': 'مايو'},
                      {'value': 6, 'label': 'يونيو'},
                      {'value': 7, 'label': 'يوليو'},
                      {'value': 8, 'label': 'أغسطس'},
                      {'value': 9, 'label': 'سبتمبر'},
                      {'value': 10, 'label': 'أكتوبر'},
                      {'value': 11, 'label': 'نوفمبر'},
                      {'value': 12, 'label': 'ديسمبر'},
                    ].map((item) => DropdownMenuItem(
                      value: item['value'] as int,
                      child: Text(
                        item['label'] as String,
                        style: GoogleFonts.cairo(),
                      ),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMonth = value;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // اختيار السنة
                  DropdownButtonFormField<int>(
                    value: selectedYear,
                    decoration: InputDecoration(
                      labelText: 'السنة',
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: List.generate(10, (index) {
                      final year = DateTime.now().year - 5 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(
                          year.toString(),
                          style: GoogleFonts.cairo(),
                        ),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedYear = value;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPickMonth(selectedMonth, selectedYear);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'تأكيد',
                style: GoogleFonts.cairo(),
              ),
            ),
          ],
        );
      },
    );
  }
}
