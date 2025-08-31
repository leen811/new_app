import 'package:flutter/material.dart';
import '../../Common/press_fx.dart';

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.index,
    required this.onChanged,
  });
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final labels = const [
      'المهام اليومية',
      'التحديات الجماعية',
      'تقدّم الفريق',
    ];
    final icons = const [
      Icons.check_box_outlined,
      Icons.emoji_events_outlined,
      Icons.flag_outlined,
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 227, 227, 232),
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth / 3;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                left: (2 - index) * w,
                right: index * w,
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Color(0x120B1524), blurRadius: 10),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(3, (i) {
                  final active = i == index;
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => onChanged(i),
                      child: SizedBox(
                        height: 44,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icons[i],
                                size: 18,
                                color: active
                                    ? const Color(0xFF2F56D9)
                                    : const Color(0xFF98A2B3),
                              ),
                              const SizedBox(width: 1),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 180),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? const Color(0xFF2F56D9)
                                      : const Color(0xFF667085),
                                ),
                                child: Text(labels[i]),
                              ),
                            ],
                          ),
                        ),
                      ).withPressFX(),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
