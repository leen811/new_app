import 'package:flutter/material.dart';
import '../../../Data/Models/employee_models.dart';
import 'employee_details_sheet.dart';

class EmployeeCard extends StatelessWidget {
  final Employee emp;
  const EmployeeCard({super.key, required this.emp});

  Color _statusTextColor(EmployeeStatus s) {
    switch (s) {
      case EmployeeStatus.active:
        return const Color(0xFF16A34A);
      case EmployeeStatus.onLeave:
        return const Color(0xFFFB8C00);
      case EmployeeStatus.inactive:
        return const Color(0xFF9AA3B2);
    }
  }

  Color _statusBgColor(EmployeeStatus s) {
    switch (s) {
      case EmployeeStatus.active:
        return const Color(0xFFE8F5E9);
      case EmployeeStatus.onLeave:
        return const Color(0xFFFFF3E0);
      case EmployeeStatus.inactive:
        return const Color(0xFFF3F4F6);
    }
  }

  String _statusLabel(EmployeeStatus s) {
    switch (s) {
      case EmployeeStatus.active:
        return 'نشط';
      case EmployeeStatus.onLeave:
        return 'في إجازة';
      case EmployeeStatus.inactive:
        return 'غير نشط';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showEmployeeDetailsSheet(context, emp),
      child: Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // أفاتار يمين
              _Avatar(name: emp.name, url: emp.avatarUrl),
              const SizedBox(width: 20),
              // الاسم والوظيفة بمحاذاة يمين
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emp.name,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${emp.roleTitle}\n${emp.department}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Color(0xFF6B7280), height: 1.2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Chip الحالة يسار
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusBgColor(emp.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusLabel(emp.status),
                  style: TextStyle(color: _statusTextColor(emp.status), fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEF1F6)),
          const SizedBox(height: 10),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(label: 'تقييم', value: emp.rating.toStringAsFixed(1)),
                _StatColumn(label: 'قيمة', value: emp.value.toString()),
                _StatColumn(label: 'حضور', value: '${emp.attendancePct}%'),
                _StatColumn(label: 'النقاط', value: emp.points.toString()),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? url;
  const _Avatar({required this.name, this.url});
  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '؟'
        : name.trim().split(' ').where((p) => p.isNotEmpty).take(2).map((e) => e.characters.first).join();
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFE6E9F0),
      backgroundImage: url != null ? NetworkImage(url!) : null,
      child: url == null
          ? Text(initials, style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold))
          : null,
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}


