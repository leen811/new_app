import 'package:flutter/material.dart';

class StoreSkeleton extends StatelessWidget {
  const StoreSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .92),
            delegate: SliverChildBuilderDelegate(
              (c, i) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Expanded(child: Container(decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))))),
                    const SizedBox(height: 8),
                    Container(height: 14, margin: const EdgeInsets.symmetric(horizontal: 10), color: const Color(0xFFE5E7EB)),
                    const SizedBox(height: 6),
                    Container(height: 12, margin: const EdgeInsets.symmetric(horizontal: 10), color: const Color(0xFFE5E7EB)),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }
}


