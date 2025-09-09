import 'package:flutter/material.dart';
import '../../../widgets/skeleton_box.dart';

class L4LSkeleton extends StatelessWidget {
  const L4LSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SkeletonBox(height: 44),
        SizedBox(height: 12),
        SkeletonBox(height: 44),
        SizedBox(height: 16),
        SkeletonBox(height: 160),
        SizedBox(height: 12),
        SkeletonBox(height: 220),
        SizedBox(height: 12),
        SkeletonBox(height: 220),
      ],
    );
  }
}


