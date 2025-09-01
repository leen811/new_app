import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SegmentedTabsDelegate extends SliverPersistentHeaderDelegate {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  SegmentedTabsDelegate({
    required this.tabs,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  double get minExtent => 44;

  @override
  double get maxExtent => 44;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (tabs.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int count = tabs.length;
          final double w = constraints.maxWidth / count;
          final int safeIndex = currentIndex.clamp(0, count - 1).toInt();
          final double thumbStart = safeIndex * w;

          return Stack(
            children: [
              AnimatedPositionedDirectional(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                start: thumbStart,
                top: 0,
                bottom: 0,
                child: Container(
                  width: w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0B1524).withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(count, (i) {
                  final bool active = i == safeIndex;
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => onChanged(i),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.cairo(
                            fontSize: 12, // كبّريها 14 إن حبيتي
                            fontWeight: FontWeight.w700,
                            color: active ? const Color(0xFF2F56D9) : const Color(0xFF667085),
                          ),
                          child: Text(
                            tabs[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
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

  @override
  bool shouldRebuild(covariant SegmentedTabsDelegate old) {
    return old.currentIndex != currentIndex || old.tabs != tabs;
  }
}
