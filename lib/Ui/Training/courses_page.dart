import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/training/courses/courses_bloc.dart';
import '../../Bloc/training/courses/courses_event.dart';
import '../../Bloc/training/courses/courses_state.dart';
import '../../Data/Repositories/training_repository.dart';
import 'widgets/course_filters_bar.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CoursesBloc(ctx.read<ITrainingRepository>())
        ..add(const CoursesOpened('all')),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'الكورسات المقترحة',
          style: TextStyle(color: Colors.black),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE6EAF2)),
        ),
      ),
      body: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is CoursesError) return Center(child: Text(state.message));
          final s = state as CoursesSuccess;
          final categories = const [
            'جميع الكورسات (5)',
            'الإدارة والقيادة (1)',
            'التكنولوجيا (1)',
            'المهارات الناعمة (1)',
            'التقني (1)',
            'الإنتاجية (1)',
          ];
          String _mapLabelToKey(String label) {
            if (label.startsWith('جميع')) return 'all';
            if (label.contains('الإدارة')) return 'management';
            if (label.contains('التكنولوجيا')) return 'technology';
            if (label.contains('الناعمة')) return 'soft';
            if (label.contains('التقني')) return 'engineering';
            if (label.contains('الإنتاجية')) return 'productivity';
            return 'all';
          }
          String _mapKeyToLabel(String key) {
            switch (key) {
              case 'management':
                return 'الإدارة والقيادة (1)';
              case 'technology':
                return 'التكنولوجيا (1)';
              case 'soft':
                return 'المهارات الناعمة (1)';
              case 'engineering':
                return 'التقني (1)';
              case 'productivity':
                return 'الإنتاجية (1)';
              case 'all':
              default:
                return 'جميع الكورسات (5)';
            }
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                context.read<CoursesBloc>().add(LoadMore());
              }
              return false;
            },
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: CourseFiltersBar(
                    categories: categories,
                    selected: _mapKeyToLabel(s.category),
                    onSelected: (c) =>
                        context.read<CoursesBloc>().add(FilterChanged(_mapLabelToKey(c))),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      // Give cards more vertical space on compact screens to avoid overflow
                          childAspectRatio: 0.83
                          ,
                    ),
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final c = s.items[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE6EAF2)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0B1524).withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    color: const Color(0xFFE9EDF4),
                                  ),
                                ),
                                PositionedDirectional(
                                  top: 8,
                                  start: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.65),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      c.priceLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                PositionedDirectional(
                                  top: 8,
                                  end: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'مطابق ${c.matchPct}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.provider,
                                    style: const TextStyle(
                                      color: Color(0xFF667085),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      c.reason,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF2F56D9),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: c.tags
                                        .map(
                                          (t) => Chip(
                                            label: Text(t),
                                            backgroundColor: const Color(
                                              0xFFF1F5F9,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.event,
                                        size: 16,
                                        color: Color(0xFF667085),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        c.startHijri,
                                        style: const TextStyle(
                                          color: Color(0xFF667085),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 34,
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          child: const Text('تفاصيل'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        height: 34,
                                        child: FilledButton(
                                          onPressed: () {},
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('ابدأ الآن'),
                                              SizedBox(width: 6),
                                              Icon(Icons.play_arrow, size: 16),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 34,
                                        width: 34,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => context
                                              .read<CoursesBloc>()
                                              .add(BookmarkToggled(c.id)),
                                          icon: Icon(
                                            c.isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: s.items.length),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
