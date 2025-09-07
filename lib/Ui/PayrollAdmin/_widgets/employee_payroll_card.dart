import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Data/Models/payroll_admin_models.dart';
import '../../Common/press_fx.dart';

class EmployeePayrollCard extends StatelessWidget {
  final EmployeePayrollRow row;
  const EmployeePayrollCard({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final ar = NumberFormat.decimalPattern('ar');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Name + meta + actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name and meta (RTL right aligned)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              row.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (row.active)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                              child: const Text('نشط', style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w700)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${row.title} • ${row.department}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Actions
                Row(
                  children: [
                    _OutlinedIconButton(
                      icon: Icons.visibility_outlined,
                      onPressed: () => _snack(context, 'عرض كشف الراتب'),
                    ),
                    const SizedBox(width: 8),
                    _OutlinedIconButton(
                      icon: Icons.settings_outlined,
                      onPressed: () => _snack(context, 'تعديل عناصر الراتب'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: breakdown + net salary block
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breakdown columns
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _SmallStat(label: 'الراتب الأساسي', value: '${ar.format(row.baseSalary)} ريال')),
                      const SizedBox(width: 8),
                      Expanded(child: _SmallStat(label: 'البدلات', value: '+${ar.format(row.allowances)}')),
                      const SizedBox(width: 8),
                      Expanded(child: _SmallStat(label: 'الخصومات', value: '-${ar.format(row.deductions)}')),
                      const SizedBox(width: 8),
                      Expanded(child: _SmallStat(label: 'المكافآت', value: '+${ar.format(row.bonuses)}')),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Net salary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(ar.format(row.net), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 4),
                    const Text('ريال', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).withPressFX();
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SmallStat extends StatelessWidget {
  final String label;
  final String value;
  const _SmallStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(value.isEmpty ? '-' : value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ),
        const SizedBox(height: 2),
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
      ],
    );
  }
}

class _OutlinedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _OutlinedIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: Color(0xFFE6E9F0)),
      ),
      child: Icon(icon, size: 20),
    ).withPressFX();
  }
}


