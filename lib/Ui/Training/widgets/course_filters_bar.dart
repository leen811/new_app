import 'package:flutter/material.dart';

class CourseFiltersBar extends StatelessWidget {
  const CourseFiltersBar({super.key, required this.categories, required this.selected, required this.onSelected});
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final label = categories[i];
          final active = label == selected;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF2F56D9) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () => onSelected(label),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(color: active ? Colors.white : const Color(0xFF334155), fontWeight: FontWeight.w700),
                  child: Text(label),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


