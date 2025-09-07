import 'package:flutter/material.dart';

class SegmentedTabsDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  SegmentedTabsDelegate({
    required this.height,
    required this.tabs,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bg = const Color(0xFFF3F6FC);
    final int count = tabs.length;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF0B1524).withOpacity(.08), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(count, (i) {
                    final active = i == safeIndex;
                    return Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onChanged(i),
                        child: SizedBox(
                          height: height,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 160),
                              style: TextStyle(
                                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                                color: active ? Theme.of(context).colorScheme.primary : const Color(0xFF9AA3B2),
                              ),
                              child: Text(
                                tabs[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SegmentedTabsDelegate oldDelegate) {
    return oldDelegate.currentIndex != currentIndex || oldDelegate.tabs != tabs || oldDelegate.height != height;
  }
}


