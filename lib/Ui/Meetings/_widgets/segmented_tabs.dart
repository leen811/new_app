import 'package:flutter/material.dart';
import '../../Leaves/_widgets/segmented_tabs.dart' as base;

class MySegmentedTabsDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  MySegmentedTabsDelegate({required this.height, required this.tabs, required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return base.SegmentedTabsDelegate(
      height: height,
      tabs: tabs,
      currentIndex: currentIndex,
      onChanged: onChanged,
    ).build(context, shrinkOffset, overlapsContent);
  }

  @override
  double get maxExtent => height;
  @override
  double get minExtent => height;
  @override
  bool shouldRebuild(covariant MySegmentedTabsDelegate oldDelegate) =>
      oldDelegate.currentIndex != currentIndex || oldDelegate.tabs != tabs || oldDelegate.height != height;
}


