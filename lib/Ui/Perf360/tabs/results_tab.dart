import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/perf360/perf360_bloc.dart';
import '../../../Bloc/perf360/perf360_state.dart';
import '../widgets/result_category_card.dart';

class ResultsTab extends StatelessWidget {
  const ResultsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<Perf360Bloc, Perf360State>(builder: (context, state) {
        if (state is! Perf360Success) return const SizedBox.shrink();
        final s = state;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: s.results?.length == null ? 1 : s.results!.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: const [
                SizedBox(height: 6),
                Align(alignment: Alignment.centerRight, child: Text('نتائج التقييم المفصلة', style: TextStyle(fontWeight: FontWeight.w800))),
                SizedBox(height: 6),
                Divider(height: 1, color: Color(0xFFE6EAF2)),
                SizedBox(height: 10),
              ]);
            }
            final row = s.results![i - 1];
            return ResultCategoryCard(
              category: row.category,
              overall: row.overall,
              self: row.self,
              manager: row.manager,
              peers: row.peers,
              subs: row.subs,
            );
          },
        );
      }),
    );
  }
}


