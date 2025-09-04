import 'package:flutter/material.dart';
import '../../../Common/press_fx.dart';

/// تبويبات سريعة للوحة HR
class HrQuickTabs extends StatelessWidget {
  final List<String> labels;
  final int current;
  final ValueChanged<int> onChanged;
  
  const HrQuickTabs({
    super.key,
    required this.labels,
    required this.current,
    required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = index == current;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // أيقونة التبويب
                      Icon(
                        index == 0 ? Icons.assessment_rounded : Icons.psychology_rounded,
                        size: 16,
                        color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : const Color(0xFF9AA3B2),
                      ),
                      const SizedBox(width: 6),
                      // نص التبويب
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : const Color(0xFF9AA3B2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).withPressFX(),
          );
        }).toList(),
      ),
    );
  }
}
