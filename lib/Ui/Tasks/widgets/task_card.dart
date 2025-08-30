import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/tasks/daily/daily_tasks_bloc.dart';
import '../../../Bloc/tasks/daily/daily_tasks_event.dart';
import '../../../Data/Models/task_item.dart';
import '../../widgets/app_button.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onTimerStart,
    required this.onTimerStop,
  });
  final TaskItem item;
  final VoidCallback onToggle;
  final VoidCallback onTimerStart;
  final VoidCallback onTimerStop;

  @override
  Widget build(BuildContext context) {
    if (item.isPlaceholderEmpty) {
      return Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6EAF2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F0B1524),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
      );
    }

    final badge = _priorityBadge(item.priority);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0B1524),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left controls column
          SizedBox(
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _SquareToggle(checked: item.done, onTap: onToggle),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SquareButton(icon: Icons.refresh, onTap: onTimerStop),
                    const SizedBox(width: 8),
                    if (item.isRunning)
                      _SquareButton(icon: Icons.pause, onTap: onTimerStop)
                    else
                      _SquareButton(
                        icon: Icons.play_arrow,
                        onTap: onTimerStart,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _TimeChip(text: _formatTime(item.timerSeconds)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          decoration: item.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    badge,
                  ],
                ),
                if (item.desc.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                if (item.tags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: -6,
                    children: item.tags.map((t) => _chip(t)).toList(),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.event, size: 14, color: Color(0xFF98A2B3)),
                    const SizedBox(width: 4),
                    Text(
                      item.intlTimeLabel.isEmpty
                          ? 'بدون تاريخ تسليم'
                          : item.intlTimeLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF667085),
                      ),
                    ),
                    const Spacer(),
                    _CircleIconButton(
                      icon: Icons.more_horiz,
                      onTap: () => _openDetailsDialog(context, item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE6EAF2)),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      t,
      style: const TextStyle(fontSize: 11, color: Color(0xFF667085)),
    ),
  );

  Widget _priorityBadge(String p) {
    Color bg = const Color(0xFF23408A); // متوسطة
    if (p == 'عالية') bg = const Color(0xFFE53E3E);
    if (p == 'منخفضة') bg = const Color(0xFF64748B);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        p,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTime(int s) {
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6EAF2)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF334155)),
      ),
    );
  }
}

class _SquareToggle extends StatelessWidget {
  const _SquareToggle({required this.checked, required this.onTap});
  final bool checked;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: checked ? const Color(0xFF2F56D9) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6EAF2)),
        ),
        child: Icon(
          checked ? Icons.check : Icons.crop_square,
          size: 16,
          color: checked ? Colors.white : const Color(0xFF334155),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6EAF2)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF23408A),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE6EAF2)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF334155)),
      ),
    );
  }
}

void _openDetailsDialog(BuildContext context, TaskItem item) async {
  final pageContext = context;
  final titleCtrl = TextEditingController(text: item.title);
  final descCtrl = TextEditingController(text: item.desc);
  String priority = item.priority;
  DateTimeRange? range; // سنستخدم الملصق الحالي إذا لم يحدد المستخدم جديدًا
  final Set<String> selectedWorks = {...item.tags};

  const Color darkBlue = Color(0xFF1E3A8A);
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'task_details',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, a1, a2) {
      final theme = Theme.of(ctx).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: darkBlue, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: darkBlue, width: 2),
          ),
        ),
      );
      return Center(
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE6E8F0)),
          ),
          child: Theme(
            data: theme,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    final rangeLabel = range == null
                        ? (item.intlTimeLabel.isEmpty
                              ? 'اختر المدة'
                              : item.intlTimeLabel)
                        : '${MaterialLocalizations.of(context).formatMediumDate(range!.start)} - ${MaterialLocalizations.of(context).formatMediumDate(range!.end)}';
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'تفاصيل المهمة',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                            hintText: 'عنوان المهمة',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'وصف المهمة (اختياري)',
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'أنواع العمل',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: -6,
                          children: [
                            for (final w in const [
                              'عمل',
                              'توثيق',
                              'تصميم',
                              'اجتماع',
                              'مراجعة',
                              'تطوير',
                            ])
                              FilterChip(
                                label: Text(w),
                                selected: selectedWorks.contains(w),
                                onSelected: (v) => setState(() {
                                  if (v)
                                    selectedWorks.add(w);
                                  else
                                    selectedWorks.remove(w);
                                }),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'المدة: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async {
                                final now = DateTime.now();
                                final r = await showDateRangePicker(
                                  context: context,
                                  firstDate: now.subtract(
                                    const Duration(days: 365),
                                  ),
                                  lastDate: now.add(
                                    const Duration(days: 365 * 3),
                                  ),
                                  initialDateRange:
                                      range ??
                                      DateTimeRange(
                                        start: now,
                                        end: now.add(const Duration(days: 1)),
                                      ),
                                );
                                if (r != null) setState(() => range = r);
                              },
                              child: Text(rangeLabel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: priority,
                          items: const [
                            DropdownMenuItem(
                              value: 'عالية',
                              child: Text('عالية'),
                            ),
                            DropdownMenuItem(
                              value: 'متوسطة',
                              child: Text('متوسطة'),
                            ),
                            DropdownMenuItem(
                              value: 'منخفضة',
                              child: Text('منخفضة'),
                            ),
                          ],
                          dropdownColor: Colors.white,
                          onChanged: (v) =>
                              setState(() => priority = v ?? item.priority),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text(
                                'إلغاء',
                                style: TextStyle(color: darkBlue),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppButton(
                                label: 'حفظ',
                                color: darkBlue,
                                height: 44,
                                radius: BorderRadius.circular(10),
                                onPressed: () {
                                  final label = range == null
                                      ? item.intlTimeLabel
                                      : '${MaterialLocalizations.of(context).formatMediumDate(range!.start)} - ${MaterialLocalizations.of(context).formatMediumDate(range!.end)}';
                                  final upd = TaskItem(
                                    id: item.id,
                                    title: titleCtrl.text.trim(),
                                    desc: descCtrl.text.trim(),
                                    priority: priority,
                                    tags: selectedWorks.toList(),
                                    estimatedMin: item.estimatedMin,
                                    intlTimeLabel: label,
                                    category: selectedWorks.isNotEmpty
                                        ? selectedWorks.first
                                        : item.category,
                                    done: item.done,
                                    timerSeconds: item.timerSeconds,
                                    isRunning: item.isRunning,
                                  );
                                  pageContext.read<DailyTasksBloc>().add(
                                    DailyTaskUpdated(upd),
                                  );
                                  Navigator.pop(ctx);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
