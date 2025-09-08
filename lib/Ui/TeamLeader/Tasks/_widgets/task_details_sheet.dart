import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/TeamTasks/team_tasks_bloc.dart';
import '../../../../Bloc/TeamTasks/team_tasks_event.dart';
import '../../../../Data/Models/team_tasks_models.dart';
import 'pills_metric.dart';

Future<void> showTaskDetailsSheet(BuildContext context, {required String taskId}) async {
  // Load latest task by id
  final repo = context.read<TeamTasksBloc>().repository;
  TaskItem item = await repo.getById(taskId);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (ctx) => _TaskDetailsSheet(item: item),
  );
}

// Note: creation UI is implemented separately in task_create_sheet.dart

class _TaskDetailsSheet extends StatefulWidget {
  final TaskItem item;
  const _TaskDetailsSheet({required this.item});
  @override
  State<_TaskDetailsSheet> createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<_TaskDetailsSheet> {
  late TextEditingController _title;
  late TextEditingController _desc;
  late int _progress;
  late TaskStatus _status;
  late TaskPriority _priority;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.item.title);
    _desc = TextEditingController(text: widget.item.description);
    _progress = widget.item.progress;
    _status = widget.item.status;
    _priority = widget.item.priority;
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
          focus.unfocus();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('تفاصيل المهمة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                if (widget.item.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(widget.item.description, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                ],
                const SizedBox(height: 12),
                Row(children: [
                  CircleAvatar(radius: 16, backgroundColor: const Color(0xFFF1F5F9), child: Text(widget.item.assigneeName.characters.first)),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.item.assigneeName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    const Text('المكلّف بالمهمة', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  ])
                ]),
                const SizedBox(height: 12),
                // KPI pills 2x2
                GridView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.9),
                  children: [
                    PillsMetric(label: 'الأولوية', value: _priorityChip(_priority)),
                    PillsMetric(label: 'الحالة', value: _statusChip(_status)),
                    PillsMetric(label: 'الساعات', value: Text('${widget.item.spentHours}/${widget.item.estimateHours}', style: const TextStyle(fontWeight: FontWeight.w700))),
                    PillsMetric(label: 'التقدّم', value: Text('$_progress%', style: const TextStyle(fontWeight: FontWeight.w700))),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('معلومات المهمة', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _infoRow('الفئة', widget.item.tags.isNotEmpty ? widget.item.tags.first : '-'),
                _infoRow('تم الإنشاء', MaterialLocalizations.of(context).formatMediumDate(widget.item.createdAt)),
                _infoRow('الاستحقاق', MaterialLocalizations.of(context).formatMediumDate(widget.item.dueAt)),
                const SizedBox(height: 12),
                const Text('العلامات', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: -6, children: widget.item.tags.map((t) => _chip(t)).toList()),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: LinearProgressIndicator(value: (_progress / 100).clamp(0, 1), minHeight: 8, backgroundColor: const Color(0xFFF3F4F6), color: const Color(0xFF2F56D9))),
                  const SizedBox(width: 10),
                  Text('$_progress%'),
                ]),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (dctx) {
                          int tmp = _progress;
                          TaskStatus st = _status;
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            title: const Text('تحديث المهمة'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonFormField<TaskStatus>(
                                  value: st,
                                  items: const [
                                    DropdownMenuItem(value: TaskStatus.todo, child: Text('لم تبدأ')),
                                    DropdownMenuItem(value: TaskStatus.inProgress, child: Text('قيد العمل')),
                                    DropdownMenuItem(value: TaskStatus.review, child: Text('مراجعة')),
                                    DropdownMenuItem(value: TaskStatus.overdue, child: Text('متأخرة')),
                                    DropdownMenuItem(value: TaskStatus.done, child: Text('مكتملة')),
                                  ],
                                  onChanged: (v) => st = v ?? st,
                                ),
                                const SizedBox(height: 12),
                                Slider(value: tmp.toDouble(), min: 0, max: 100, divisions: 20, label: '$tmp%', onChanged: (v) => tmp = v.toInt()),
                              ],
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(dctx), child: const Text('إلغاء')),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                                onPressed: () { Navigator.pop(dctx, {'p': tmp, 's': st}); },
                                child: const Text('حفظ'),
                              ),
                            ],
                          );
                        },
                      ).then((res) {
                        if (res is Map) {
                          context.read<TeamTasksBloc>().add(TasksProgressChanged(widget.item.id, res['p'] as int));
                          context.read<TeamTasksBloc>().add(TaskStatusChanged(widget.item.id, res['s'] as TaskStatus));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث المهمة')));
                        }
                      });
                    },
                    child: const Text('تحديث المهمة'),
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: Color(0xFFE6E9F0)), foregroundColor: const Color(0xFF0F172A)),
                    onPressed: () async {
                    final msgCtrl = TextEditingController();
                    await showDialog(context: context, builder: (d) => AlertDialog(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: const Text('إرسال رسالة'),
                      content: TextField(controller: msgCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'اكتب رسالة قصيرة...')),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(d), child: const Text('إلغاء')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                          onPressed: () { Navigator.pop(d, msgCtrl.text.trim()); },
                          child: const Text('إرسال'),
                        ),
                      ],
                    ));
                    if (msgCtrl.text.trim().isNotEmpty) {
                      context.read<TeamTasksBloc>().add(TaskSendMessage(widget.item.id, msgCtrl.text.trim()));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الرسالة')));
                    }
                  }, child: const Text('إرسال رسالة'))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: Color(0xFFE6E9F0)), foregroundColor: const Color(0xFF0F172A)),
                    onPressed: () async {
                    await showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), builder: (bctx) {
                      int tmp = _progress;
                      return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(bctx).viewInsets.bottom), child: Container(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('تعديل التقدّم', style: TextStyle(fontWeight: FontWeight.w700)),
                        Slider(value: tmp.toDouble(), min: 0, max: 100, divisions: 20, label: '$tmp%', onChanged: (v) { tmp = v.toInt(); }),
                        const SizedBox(height: 12),
                        SizedBox(height: 44, width: double.infinity, child: ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                          onPressed: () { Navigator.pop(bctx, tmp); }, child: const Text('حفظ'))),
                      ])));
                    }).then((val) {
                      if (val is int) {
                        context.read<TeamTasksBloc>().add(TasksProgressChanged(widget.item.id, val));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث التقدّم')));
                      }
                    });
                  }, child: const Text('تعديل التقدّم'))),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6EAF2)), borderRadius: BorderRadius.circular(999)),
        child: Text(t, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
      );

  Widget _statusChip(TaskStatus s) {
    final label = () {
      switch (s) {
        case TaskStatus.todo: return 'لم تبدأ';
        case TaskStatus.inProgress: return 'قيد العمل';
        case TaskStatus.review: return 'مراجعة';
        case TaskStatus.overdue: return 'متأخرة';
        case TaskStatus.done: return 'مكتملة';
      }
    }();
    Color bg = const Color(0xFFE7F0FF);
    Color fg = const Color(0xFF0F172A);
    if (s == TaskStatus.inProgress) { bg = const Color(0xFFFFF3CD); }
    if (s == TaskStatus.review) { bg = const Color(0xFFF3E8FF); }
    if (s == TaskStatus.overdue) { bg = const Color(0xFFFFE8E8); fg = const Color(0xFFB91C1C); }
    if (s == TaskStatus.done) { bg = const Color(0xFFE8F5E9); fg = const Color(0xFF065F46); }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)), child: Text(label, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600)));
  }

  Widget _priorityChip(TaskPriority p) {
    String label = 'متوسطة';
    Color bg = const Color(0xFFF3E8FF);
    Color fg = const Color(0xFF0F172A);
    if (p == TaskPriority.low) { label = 'منخفضة'; bg = const Color(0xFFE7F0FF); }
    if (p == TaskPriority.high) { label = 'عالية'; bg = const Color(0xFFFFE8E8); fg = const Color(0xFFB91C1C); }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)), child: Text(label, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600)));
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [Text(label, style: const TextStyle(color: Color(0xFF6B7280))), const Spacer(), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))]),
      );
}


