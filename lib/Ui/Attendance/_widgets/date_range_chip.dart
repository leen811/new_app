import 'package:flutter/material.dart';

class DateRangeChip extends StatelessWidget {
  final DateTimeRange? range;
  final VoidCallback onPick;
  const DateRangeChip({super.key, required this.range, required this.onPick});
  @override
  Widget build(BuildContext context) {
    final text = range == null
        ? 'اختر الفترة'
        : '${range!.start.year}/${range!.start.month}/${range!.start.day} → ${range!.end.year}/${range!.end.month}/${range!.end.day}';
    return OutlinedButton.icon(
      onPressed: onPick,
      icon: const Icon(Icons.calendar_today_rounded, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: Color(0xFFE6E9F0)),
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
      ),
    );
  }
}


