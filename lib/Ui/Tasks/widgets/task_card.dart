import 'package:flutter/material.dart';
import '../../../Data/Models/task_item.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.item, required this.onToggle, required this.onTimerStart, required this.onTimerStop});
  final TaskItem item;
  final VoidCallback onToggle;
  final VoidCallback onTimerStart;
  final VoidCallback onTimerStop;

  @override
  Widget build(BuildContext context) {
    if (item.isPlaceholderEmpty) {
      return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      );
    }
    final badge = _priorityBadge(item.priority);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Checkbox(value: item.done, onChanged: (_) => onToggle()),
          const SizedBox(height: 6),
          Row(children: [
            IconButton(onPressed: onTimerStop, icon: const Icon(Icons.refresh, size: 18)),
            IconButton(onPressed: onTimerStart, icon: const Icon(Icons.play_arrow, size: 18)),
            Text(_formatTime(item.timerSeconds), style: const TextStyle(fontFeatures: [])),
          ])
        ]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, decoration: item.done ? TextDecoration.lineThrough : TextDecoration.none),
                ),
              ),
              badge,
            ]),
            if (item.desc.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(item.desc, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: -6, children: item.tags.map((t) => _chip(t)).toList()),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.schedule, size: 14, color: Color(0xFF98A2B3)),
              const SizedBox(width: 4),
              Text('دقيقة ${item.estimatedMin}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
              const Spacer(),
              Text(item.intlTimeLabel, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
              const SizedBox(width: 8),
              const Icon(Icons.more_horiz, size: 18),
            ])
          ]),
        )
      ]),
    );
  }

  Widget _chip(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6EAF2)), borderRadius: BorderRadius.circular(999)),
        child: Text(t, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
      );

  Widget _priorityBadge(String p) {
    Color bg = const Color(0xFF23408A);
    if (p == 'عالية') bg = const Color(0xFFE53E3E);
    if (p == 'منخفضة') bg = const Color(0xFF98A2B3);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: const Text('أولوية', style: TextStyle(fontSize: 10, color: Colors.white)),
    );
  }

  String _formatTime(int s) {
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}


