import 'package:flutter/material.dart';

class EmployeesSkeleton extends StatelessWidget {
  const EmployeesSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: _FieldSkeleton(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          sliver: SliverList.list(children: [
            Row(children: [
              Expanded(child: _CardSkeleton(height: 64)),
              const SizedBox(width: 12),
              Expanded(child: _CardSkeleton(height: 64)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _CardSkeleton(height: 64)),
              const SizedBox(width: 12),
              Expanded(child: _CardSkeleton(height: 64)),
            ]),
          ]),
        ),
        SliverList.separated(
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _CardSkeleton(height: 84),
          ),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: 8,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
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


