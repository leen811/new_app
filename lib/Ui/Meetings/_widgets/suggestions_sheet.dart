import 'package:flutter/material.dart';
import '../../../Data/Models/meetings_models.dart';

Future<SlotSuggestion?> showSuggestionsSheet(BuildContext context, List<SlotSuggestion> suggestions) async {
  return showModalBottomSheet<SlotSuggestion>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (ctx) => _SuggestionsSheet(suggestions: suggestions),
  );
}

class _SuggestionsSheet extends StatelessWidget {
  final List<SlotSuggestion> suggestions;
  const _SuggestionsSheet({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Expanded(child: Text('الأوقات المتاحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ]),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final s = suggestions[i];
                final label = '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(s.start), alwaysUse24HourFormat: true)} → ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(s.end), alwaysUse24HourFormat: true)}';
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context, s),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE6E9F0)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      const Icon(Icons.schedule_rounded, color: Color(0xFF0F172A)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}


