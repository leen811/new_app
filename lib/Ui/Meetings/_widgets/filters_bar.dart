import 'package:flutter/material.dart';

class FiltersBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQuery;
  final ValueChanged<String?> onPlatform;
  final ValueChanged<String?> onPriority;
  final ValueChanged<DateTimeRange?> onRange;
  const FiltersBar({super.key, required this.query, required this.onQuery, required this.onPlatform, required this.onPriority, required this.onRange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'البحث في الاجتماعات…',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6E9F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6E9F0))),
              focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFF2563EB))),
            ),
            onChanged: onQuery,
          ),
          const SizedBox(height: 8),
          Row(children: const []),
        ],
      ),
    );
  }
}


