import 'package:flutter/material.dart';
import '../../../../Data/Models/team_tasks_models.dart';
import 'progress_bar.dart';
import 'task_details_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/TeamTasks/team_tasks_bloc.dart';
import '../../../../Bloc/TeamTasks/team_tasks_event.dart';

class TaskCard extends StatelessWidget {
  final TaskItem item;
  const TaskCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: const [BoxShadow(color: Color(0x0F0B1524), blurRadius: 10, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
              _statusChip(item.status),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: const Color(0xFFF1F5F9), child: Text(item.assigneeName.characters.first)),
              const SizedBox(width: 8),
              Text('المكلّف: ${item.assigneeName}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ],
          const SizedBox(height: 8),
          if (item.tags.isNotEmpty)
            Wrap(spacing: 6, runSpacing: -6, children: item.tags.map((t) => _chip(t)).toList()),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(_statusText(item.status), style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
              const SizedBox(width: 8),
              Text(_priorityText(item.priority), style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
              const Spacer(),
              Text('ساعات ${item.spentHours}/${item.estimateHours}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: AppProgressBar(value: item.progress / 100)), const SizedBox(width: 10), Text('${item.progress}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 8),
          Row(children: _quickActions(context, item)),
        ],
      ),
    );
  }

  Widget _chip(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6EAF2)), borderRadius: BorderRadius.circular(999)),
        child: Text(t, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
      );

  Widget _statusChip(TaskStatus s) {
    final label = _statusText(s);
    Color bg = const Color(0xFFE7F0FF);
    Color fg = const Color(0xFF0F172A);
    if (s == TaskStatus.inProgress) { bg = const Color(0xFFFFF3CD); }
    if (s == TaskStatus.review) { bg = const Color(0xFFF3E8FF); }
    if (s == TaskStatus.overdue) { bg = const Color(0xFFFFE8E8); fg = const Color(0xFFB91C1C); }
    if (s == TaskStatus.done) { bg = const Color(0xFFE8F5E9); fg = const Color(0xFF065F46); }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600)),
    );
  }

  String _statusText(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo: return 'لم تبدأ';
      case TaskStatus.inProgress: return 'قيد العمل';
      case TaskStatus.review: return 'مراجعة';
      case TaskStatus.overdue: return 'متأخرة';
      case TaskStatus.done: return 'مكتملة';
    }
  }

  String _priorityText(TaskPriority p) {
    switch (p) {
      case TaskPriority.low: return 'منخفضة';
      case TaskPriority.medium: return 'متوسطة';
      case TaskPriority.high: return 'عالية';
    }
  }

  List<Widget> _quickActions(BuildContext context, TaskItem item) {
    final style = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      side: const BorderSide(color: Color(0xFFE6EAF2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      foregroundColor: const Color(0xFF0F172A),
    );
    switch (item.status) {
      case TaskStatus.todo:
        return [
          OutlinedButton.icon(onPressed: () => context.read<TeamTasksBloc>().add(TaskStatusChanged(item.id, TaskStatus.inProgress)), icon: const Icon(Icons.play_arrow_rounded, size: 18), label: const Text('بدء'), style: style),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () => showTaskDetailsSheet(context, taskId: item.id), icon: const Icon(Icons.tune_rounded, size: 18), label: const Text('تفاصيل'), style: style),
        ];
      case TaskStatus.inProgress:
        return [
          OutlinedButton.icon(onPressed: () => context.read<TeamTasksBloc>().add(TaskStatusChanged(item.id, TaskStatus.review)), icon: const Icon(Icons.verified_rounded, size: 18), label: const Text('اعتماد'), style: style),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () => context.read<TeamTasksBloc>().add(TaskStatusChanged(item.id, TaskStatus.done)), icon: const Icon(Icons.check_circle_rounded, size: 18), label: const Text('إغلاق'), style: style),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () => showTaskDetailsSheet(context, taskId: item.id), icon: const Icon(Icons.tune_rounded, size: 18), label: const Text('تفاصيل'), style: style),
        ];
      case TaskStatus.review:
        return [
          OutlinedButton.icon(onPressed: () => context.read<TeamTasksBloc>().add(TaskStatusChanged(item.id, TaskStatus.done)), icon: const Icon(Icons.check_circle_rounded, size: 18), label: const Text('إغلاق'), style: style),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () => showTaskDetailsSheet(context, taskId: item.id), icon: const Icon(Icons.tune_rounded, size: 18), label: const Text('تفاصيل'), style: style),
        ];
      case TaskStatus.overdue:
        return [
          OutlinedButton.icon(onPressed: () => context.read<TeamTasksBloc>().add(TaskStatusChanged(item.id, TaskStatus.inProgress)), icon: const Icon(Icons.play_arrow_rounded, size: 18), label: const Text('استئناف'), style: style),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () => showTaskDetailsSheet(context, taskId: item.id), icon: const Icon(Icons.tune_rounded, size: 18), label: const Text('تفاصيل'), style: style),
        ];
      case TaskStatus.done:
        return [
          OutlinedButton.icon(onPressed: () => context.read<TeamTasksBloc>().add(TaskStatusChanged(item.id, TaskStatus.inProgress)), icon: const Icon(Icons.replay_rounded, size: 18), label: const Text('إعادة فتح'), style: style),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () => showTaskDetailsSheet(context, taskId: item.id), icon: const Icon(Icons.tune_rounded, size: 18), label: const Text('تفاصيل'), style: style),
        ];
    }
  }
}


