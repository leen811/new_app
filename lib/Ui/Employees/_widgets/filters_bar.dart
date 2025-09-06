import 'package:flutter/material.dart';
import '../../../Data/Models/employee_models.dart';

class FiltersBar extends StatefulWidget {
  final String query;
  final String department;
  final EmployeeStatus? status;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<EmployeeStatus?> onStatusChanged;

  const FiltersBar({
    super.key,
    required this.query,
    required this.department,
    required this.status,
    required this.onQueryChanged,
    required this.onDepartmentChanged,
    required this.onStatusChanged,
  });

  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant FiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query && widget.query != _searchCtrl.text) {
      final newText = widget.query;
      _searchCtrl.value = TextEditingValue(
        text: newText,
        selection: TextSelection.fromPosition(TextPosition(offset: newText.length)),
      );
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _searchCtrl,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'البحث بالاسم، البريد الإلكتروني أو القسم…',
              hintStyle: const TextStyle(fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF8FAFF),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFFE6E9F0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFFE6E9F0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
            onChanged: widget.onQueryChanged,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownMenu<String>(
                  initialSelection: widget.department.isEmpty ? 'جميع الأقسام' : widget.department,
                  onSelected: (v) { if (v != null) widget.onDepartmentChanged(v); },
                  label: const Text('جميع الأقسام'),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
                  menuStyle: MenuStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  inputDecorationTheme: const InputDecorationTheme(
                    filled: true,
                    fillColor: Color(0xFFF8FAFF),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE6E9F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE6E9F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'جميع الأقسام', label: 'جميع الأقسام', leadingIcon: Icon(Icons.apartment_rounded)),
                    DropdownMenuEntry(value: 'التكنولوجيا', label: 'التكنولوجيا', leadingIcon: Icon(Icons.memory_rounded)),
                    DropdownMenuEntry(value: 'التسويق', label: 'التسويق', leadingIcon: Icon(Icons.campaign_rounded)),
                    DropdownMenuEntry(value: 'المبيعات', label: 'المبيعات', leadingIcon: Icon(Icons.attach_money_rounded)),
                    DropdownMenuEntry(value: 'الموارد البشرية', label: 'الموارد البشرية', leadingIcon: Icon(Icons.group_rounded)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownMenu<EmployeeStatus?>(
                  initialSelection: widget.status,
                  onSelected: (v) => widget.onStatusChanged(v),
                  label: const Text('جميع الحالات'),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
                  menuStyle: MenuStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  inputDecorationTheme: const InputDecorationTheme(
                    filled: true,
                    fillColor: Color(0xFFF8FAFF),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE6E9F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE6E9F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry<EmployeeStatus?>(value: null, label: 'جميع الحالات', leadingIcon: Icon(Icons.filter_alt_rounded)),
                    DropdownMenuEntry<EmployeeStatus?>(value: EmployeeStatus.active, label: 'نشط', leadingIcon: Icon(Icons.verified_rounded)),
                    DropdownMenuEntry<EmployeeStatus?>(value: EmployeeStatus.onLeave, label: 'في إجازة', leadingIcon: Icon(Icons.beach_access_rounded)),
                    DropdownMenuEntry<EmployeeStatus?>(value: EmployeeStatus.inactive, label: 'غير نشط', leadingIcon: Icon(Icons.pause_circle_rounded)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


