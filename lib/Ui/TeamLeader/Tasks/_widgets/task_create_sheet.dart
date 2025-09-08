import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/TeamTasks/team_tasks_bloc.dart';
import '../../../../Bloc/TeamTasks/team_tasks_event.dart';
import '../../../../Data/Models/team_tasks_models.dart';

Future<void> showTaskCreateSheetFull(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) => const _CreateSheet(),
  );
}

class _CreateSheet extends StatefulWidget {
  const _CreateSheet();
  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _estimate = TextEditingController();
  final _category = TextEditingController();
  final _tags = <String>[];
  String _assigneeId = 'u1';
  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueAt = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _estimate.dispose();
    _category.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final f = FocusScope.of(context);
        if (!f.hasPrimaryFocus && f.focusedChild != null) f.unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFFE6E9F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFFE6E9F0))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFF2563EB), width: 2)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    const Expanded(child: Text('إنشاء مهمة جديدة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ]),
                  const SizedBox(height: 12),
                  TextField(controller: _title, decoration: const InputDecoration(hintText: 'عنوان المهمة')), 
                  const SizedBox(height: 8),
                  TextField(controller: _desc, maxLines: 3, decoration: const InputDecoration(hintText: 'الوصف')), 
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _assigneeId,
                    items: const [
                      DropdownMenuItem(value: 'u1', child: Text('سارة أحمد')),
                      DropdownMenuItem(value: 'u2', child: Text('محمد علي')),
                      DropdownMenuItem(value: 'u3', child: Text('فاطمة محمد')),
                    ],
                    onChanged: (v) => setState(() => _assigneeId = v ?? _assigneeId),
                    decoration: const InputDecoration(hintText: 'المكلّف'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<TaskPriority>(
                    value: _priority,
                    items: const [
                      DropdownMenuItem(value: TaskPriority.low, child: Text('منخفضة')),
                      DropdownMenuItem(value: TaskPriority.medium, child: Text('متوسطة')),
                      DropdownMenuItem(value: TaskPriority.high, child: Text('عالية')),
                    ],
                    onChanged: (v) => setState(() => _priority = v ?? _priority),
                    decoration: const InputDecoration(hintText: 'الأولوية'),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: _estimate, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'الساعات المقدّرة')), 
                  const SizedBox(height: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showDatePicker(context: context, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime.now().add(const Duration(days: 365 * 2)), initialDate: _dueAt);
                      if (picked != null) setState(() => _dueAt = picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(hintText: 'تاريخ الاستحقاق'),
                      child: Text(MaterialLocalizations.of(context).formatMediumDate(_dueAt)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: _category, decoration: const InputDecoration(hintText: 'الفئة (اختياري)')),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, children: [
                    InputChip(label: const Text('إضافة وسم'), onPressed: () async {
                      final c = TextEditingController();
                      final tag = await showDialog<String>(context: context, builder: (d) => AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        title: const Text('وسم جديد'),
                        content: TextField(controller: c, decoration: const InputDecoration(hintText: 'مثال: UI/UX')), 
                        actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(d, c.text.trim()), child: const Text('إضافة'))],
                      ));
                      if (tag != null && tag.isNotEmpty) setState(() => _tags.add(tag));
                    }),
                    ..._tags.map((t) => Chip(label: Text(t), onDeleted: () => setState(() => _tags.remove(t)))),
                  ]),
                  const SizedBox(height: 12),
                  if (_saving) const LinearProgressIndicator(minHeight: 2, backgroundColor: Color(0xFFE6EAF2), color: Color(0xFF2F56D9)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0xFFE6E9F0)),
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _saving ? null : () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _saving ? null : () async {
                            final title = _title.text.trim();
                            final desc = _desc.text.trim();
                            final estimate = int.tryParse(_estimate.text.trim() == '' ? '0' : _estimate.text.trim()) ?? 0;
                            if (title.isEmpty || desc.isEmpty || estimate <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إدخال جميع الحقول المطلوبة')));
                              return;
                            }
                            setState(() => _saving = true);
                            context.read<TeamTasksBloc>().add(TaskCreateSubmitted(
                              title: title,
                              description: desc,
                              assigneeId: _assigneeId,
                              priority: _priority,
                              estimateHours: estimate,
                              dueAt: _dueAt,
                              category: _category.text.trim().isEmpty ? null : _category.text.trim(),
                              tags: _tags,
                            ));
                            await Future<void>.delayed(const Duration(milliseconds: 250));
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء المهمة')));
                            }
                          },
                          child: const Text('إنشاء المهمة'),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


