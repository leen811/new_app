import 'package:flutter/material.dart';

class SkeletonMyMeetings extends StatelessWidget {
  const SkeletonMyMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(children: [
              _Bar(), SizedBox(height: 10), _Bar(), SizedBox(height: 10), _Bar(), SizedBox(height: 10), _Bar(),
            ]),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: _Field(),
          ),
        ),
        SliverList.separated(
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _Card(height: 110),
          ),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: 6,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar();
  @override
  Widget build(BuildContext context) => Container(height: 64, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)));
}
class _Field extends StatelessWidget {
  const _Field();
  @override
  Widget build(BuildContext context) => Container(height: 48, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)));
}
class _Card extends StatelessWidget {
  final double height; const _Card({required this.height});
  @override
  Widget build(BuildContext context) => Container(height: height, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)));
}


