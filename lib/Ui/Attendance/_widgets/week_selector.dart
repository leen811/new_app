import 'package:flutter/material.dart';

class WeekSelector extends StatelessWidget {
  final List<DateTime> days; // length 7
  final int currentIndex;
  final ValueChanged<int> onChanged;
  const WeekSelector({super.key, required this.days, required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final labels = const ['السبت','الأحد','الإثنين','الثلاثاء','الأربعاء','الخميس','الجمعة'];
    return Container(
      height: 40,
      decoration: BoxDecoration(color: const Color(0xFFF3F6FC), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: List.generate(7, (i) {
          final selected = i == currentIndex;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))] : null,
                  ),
                  child: Center(
                    child: Text(labels[i], style: TextStyle(color: selected ? Colors.black : const Color(0xFF6B7280), fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}


