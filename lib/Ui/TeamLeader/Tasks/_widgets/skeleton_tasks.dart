import 'package:flutter/material.dart';

class SkeletonTasks extends StatelessWidget {
  const SkeletonTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(children: [
              _BarSkeleton(),
              SizedBox(height: 10),
              _BarSkeleton(),
              SizedBox(height: 10),
              _BarSkeleton(),
            ]),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: _FieldSkeleton(),
          ),
        ),
        SliverList.separated(
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _CardSkeleton(height: 140),
          ),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: 6,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _BarSkeleton extends StatelessWidget {
  const _BarSkeleton();
  @override
  Widget build(BuildContext context) => Container(
        height: 64,
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
      );
}

class _FieldSkeleton extends StatelessWidget {
  const _FieldSkeleton();
  @override
  Widget build(BuildContext context) => Container(height: 48, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)));
}

class _CardSkeleton extends StatelessWidget {
  final double height;
  const _CardSkeleton({required this.height});
  @override
  Widget build(BuildContext context) => Container(height: height, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)));
}


