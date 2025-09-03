import 'package:flutter/material.dart';

class SegmentedCategoriesDelegate extends SliverPersistentHeaderDelegate {
  final List<String> labels;
  final int current;
  final ValueChanged<int> onChanged;
  
  SegmentedCategoriesDelegate({
    required this.labels,
    required this.current,
    required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(24),
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
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: const Color(0xFF0B1524).withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected 
                        ? const Color(0xFF2F56D9)
                        : const Color(0xFF667085),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  @override
  double get maxExtent => 60;
  
  @override
  double get minExtent => 60;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is SegmentedCategoriesDelegate &&
        (oldDelegate.current != current || oldDelegate.labels != labels);
  }
}
