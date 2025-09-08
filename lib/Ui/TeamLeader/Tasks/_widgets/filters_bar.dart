import 'package:flutter/material.dart';

class FiltersBar extends StatelessWidget {
  final String query;
  final String filter; // 'all' | 'todo' | 'inProgress' | 'review' | 'overdue' | 'done'
  final ValueChanged<String> onQuery;
  final ValueChanged<String> onFilter;

  const FiltersBar({super.key, required this.query, required this.filter, required this.onQuery, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'البحث في المهام…',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
            onChanged: onQuery,
          ),
          const SizedBox(height: 8),
          DropdownMenu<String>(
            width: double.infinity,
            initialSelection: filter,
            onSelected: (v) => onFilter(v ?? 'all'),
            label: const Text('التصفية'),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            menuStyle: MenuStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFF8FAFF),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFFE6E9F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFFE6E9F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFF2563EB))),
            ),
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'all', label: 'جميع المهام', leadingIcon: Icon(Icons.filter_alt_rounded)),
              DropdownMenuEntry(value: 'todo', label: 'لم تبدأ', leadingIcon: Icon(Icons.playlist_remove_rounded)),
              DropdownMenuEntry(value: 'inProgress', label: 'قيد العمل', leadingIcon: Icon(Icons.pending_actions_rounded)),
              DropdownMenuEntry(value: 'review', label: 'مراجعة', leadingIcon: Icon(Icons.verified_user_rounded)),
              DropdownMenuEntry(value: 'overdue', label: 'متأخرة', leadingIcon: Icon(Icons.warning_amber_rounded)),
              DropdownMenuEntry(value: 'done', label: 'مكتملة', leadingIcon: Icon(Icons.check_circle_rounded)),
            ],
          ),
        ],
      ),
    );
  }
}


