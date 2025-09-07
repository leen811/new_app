import 'package:flutter/material.dart';

class ManagerSkeleton extends StatelessWidget {
  const ManagerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        // Header hero placeholder
        const SliverToBoxAdapter(
          child: _BlockSkeleton(height: 140, margin: EdgeInsets.symmetric(horizontal: 16)),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        // KPI grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: const [
              _BlockSkeleton(height: 100),
              _BlockSkeleton(height: 100),
              _BlockSkeleton(height: 100),
              _BlockSkeleton(height: 100),
            ],
          ),
        ),
        // Sections list placeholders
        SliverList.separated(
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _BlockSkeleton(height: 70),
          ),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: 5,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _BlockSkeleton extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;
  const _BlockSkeleton({required this.height, this.margin});
  @override
  Widget build(BuildContext context) {
    final box = Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
    );
    if (margin != null) return Container(margin: margin, child: box);
    return box;
  }
}


