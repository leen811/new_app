import 'package:flutter/material.dart';

class EmployeesFiltersBar extends StatefulWidget {
  final String query;
  final String filterLabel; // 'الكل' أو اسم قسم
  final List<String> departments;
  final ValueChanged<String> onQuery;
  final ValueChanged<String> onFilter;
  const EmployeesFiltersBar({super.key, required this.query, required this.filterLabel, required this.departments, required this.onQuery, required this.onFilter});

  @override
  State<EmployeesFiltersBar> createState() => _EmployeesFiltersBarState();
}

class _EmployeesFiltersBarState extends State<EmployeesFiltersBar> {
  late final TextEditingController _c;
  List<String> get _filters {
    final base = ['الكل'];
    final depts = widget.departments.toSet().toList()..sort();
    return [...base, ...depts];
  }

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant EmployeesFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query && _c.text != widget.query) {
      _c.text = widget.query;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _c,
            onChanged: widget.onQuery,
            decoration: const InputDecoration(
              hintText: 'البحث في الموظفين…',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filters.contains(widget.filterLabel) ? widget.filterLabel : _filters.first,
                borderRadius: BorderRadius.circular(12),
                items: _filters.map((f) => DropdownMenuItem<String>(value: f, child: Text(f))).toList(),
                onChanged: (v) {
                  if (v != null) widget.onFilter(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


