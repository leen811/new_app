import 'package:flutter/material.dart';

class LeavesSkeleton extends StatelessWidget {
  const LeavesSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.4,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              childCount: 4,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Column(
              children: [
                Container(height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: Container(height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)))),
                  const SizedBox(width: 8),
                  Container(width: 140, height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12))),
                ]),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}


