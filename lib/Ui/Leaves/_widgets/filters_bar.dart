import 'package:flutter/material.dart';
import '../../../Data/Models/leaves_models.dart';

class FiltersBar extends StatelessWidget {
  final String query;
  final LeaveType? selectedType;
  final LeaveStatus? selectedStatus;
  final String? department;
  final DateTimeRange? range;
  final ValueChanged<String> onQuery;
  final ValueChanged<LeaveType?> onType;
  final ValueChanged<LeaveStatus?> onStatus;
  final ValueChanged<String?> onDept;
  final ValueChanged<DateTimeRange?> onRange;

  const FiltersBar({
    super.key,
    required this.query,
    required this.selectedType,
    required this.selectedStatus,
    required this.department,
    required this.range,
    required this.onQuery,
    required this.onType,
    required this.onStatus,
    required this.onDept,
    required this.onRange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو القسم أو العنوان',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE6E9F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            onSubmitted: onQuery,
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              DropdownMenu<LeaveType?>(
                width: double.infinity,
                initialSelection: selectedType,
                onSelected: (v) => onType(v),
                label: const Text('النوع'),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                menuStyle: MenuStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  surfaceTintColor: const MaterialStatePropertyAll(
                    Colors.white,
                  ),
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFFF8FAFF),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
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
                  DropdownMenuEntry<LeaveType?>(
                    value: null,
                    label: 'الكل',
                    leadingIcon: Icon(Icons.filter_alt_rounded),
                  ),
                  DropdownMenuEntry<LeaveType?>(
                    value: LeaveType.annual,
                    label: 'سنوية',
                    leadingIcon: Icon(Icons.beach_access_rounded),
                  ),
                  DropdownMenuEntry<LeaveType?>(
                    value: LeaveType.sick,
                    label: 'مرضية',
                    leadingIcon: Icon(Icons.sick_rounded),
                  ),
                  DropdownMenuEntry<LeaveType?>(
                    value: LeaveType.unpaid,
                    label: 'بدون راتب',
                    leadingIcon: Icon(Icons.money_off_rounded),
                  ),
                  DropdownMenuEntry<LeaveType?>(
                    value: LeaveType.urgent,
                    label: 'طارئة',
                    leadingIcon: Icon(Icons.notification_important_rounded),
                  ),
                  DropdownMenuEntry<LeaveType?>(
                    value: LeaveType.permission,
                    label: 'استئذان',
                    leadingIcon: Icon(Icons.timer_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownMenu<LeaveStatus?>(
                width: double.infinity,
                initialSelection: selectedStatus,
                onSelected: (v) => onStatus(v),
                label: const Text('الحالة'),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                menuStyle: MenuStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  surfaceTintColor: const MaterialStatePropertyAll(
                    Colors.white,
                  ),
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFFF8FAFF),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
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
                  DropdownMenuEntry<LeaveStatus?>(
                    value: null,
                    label: 'الكل',
                    leadingIcon: Icon(Icons.filter_alt_rounded),
                  ),
                  DropdownMenuEntry<LeaveStatus?>(
                    value: LeaveStatus.pending,
                    label: 'قيد المراجعة',
                    leadingIcon: Icon(Icons.hourglass_top_rounded),
                  ),
                  DropdownMenuEntry<LeaveStatus?>(
                    value: LeaveStatus.approved,
                    label: 'مقبول',
                    leadingIcon: Icon(Icons.verified_rounded),
                  ),
                  DropdownMenuEntry<LeaveStatus?>(
                    value: LeaveStatus.rejected,
                    label: 'مرفوض',
                    leadingIcon: Icon(Icons.close_rounded),
                  ),
                  DropdownMenuEntry<LeaveStatus?>(
                    value: LeaveStatus.cancelled,
                    label: 'ملغي',
                    leadingIcon: Icon(Icons.cancel_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownMenu<String?>(
                width: double.infinity,
                initialSelection: department,
                onSelected: (v) => onDept(v),
                label: const Text('القسم'),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                menuStyle: MenuStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  surfaceTintColor: const MaterialStatePropertyAll(
                    Colors.white,
                  ),
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFFF8FAFF),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
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
                  DropdownMenuEntry<String?>(
                    value: null,
                    label: 'جميع الأقسام',
                    leadingIcon: Icon(Icons.apartment_rounded),
                  ),
                  DropdownMenuEntry<String?>(
                    value: 'التكنولوجيا',
                    label: 'التكنولوجيا',
                    leadingIcon: Icon(Icons.memory_rounded),
                  ),
                  DropdownMenuEntry<String?>(
                    value: 'المبيعات',
                    label: 'المبيعات',
                    leadingIcon: Icon(Icons.attach_money_rounded),
                  ),
                  DropdownMenuEntry<String?>(
                    value: 'التسويق',
                    label: 'التسويق',
                    leadingIcon: Icon(Icons.campaign_rounded),
                  ),
                  DropdownMenuEntry<String?>(
                    value: 'الموارد البشرية',
                    label: 'الموارد البشرية',
                    leadingIcon: Icon(Icons.group_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _DateRangeChip(range: range, onChanged: onRange),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final T value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double? width;
  const _Dropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    final child = DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9F0)),
        ),
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
    if (width != null) return SizedBox(width: width, child: child);
    return child;
  }
}

class _DateRangeChip extends StatelessWidget {
  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;
  const _DateRangeChip({required this.range, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final label = range == null ? 'الفترة: الكل' : _fmt(range!);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year - 2),
          lastDate: DateTime(now.year + 2),
          initialDateRange: range,
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
        );
        onChanged(picked);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9F0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Color(0xFF111827), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTimeRange r) =>
      '${r.start.day}/${r.start.month} - ${r.end.day}/${r.end.month}';
}
