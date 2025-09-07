import 'package:flutter/material.dart';
import '../../../Data/Models/leaves_models.dart';

class RequestDetailsSheet extends StatelessWidget {
  final LeaveRequest data;
  const RequestDetailsSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(data.employeeName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('${_typeText(data.type)} • ${_statusText(data.status)}', style: const TextStyle(color: Color(0xFF6B7280))),
            const SizedBox(height: 12),
            _line('القسم', data.department),
            _line('الفترة', data.isPermission ? '${_d(data.startAt)}، ${_t(data.timeFrom)} → ${_t(data.timeTo)}' : 'من ${_d(data.startAt)} → إلى ${_d(data.endAt)}'),
            if (!data.isPermission) _line('الأيام', '${data.daysRequested}'),
            if (!data.isPermission) _line('الرصيد', '${data.balanceBefore} → ${data.balanceAfter}'),
            if (data.note != null) _line('ملاحظة الموظف', data.note!),
            _line('تاريخ الإنشاء', _dt(data.createdAt)),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.timeline, size: 18, color: Color(0xFF6B7280)),
                SizedBox(width: 8),
                Expanded(child: Text('إنشاء → مراجعة → قرار نهائي', style: TextStyle(color: Color(0xFF6B7280))))
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(v, textAlign: TextAlign.left)),
            const SizedBox(width: 8),
            Text(k, style: const TextStyle(color: Color(0xFF6B7280))),
          ],
        ),
      );

  String _d(DateTime d) {
    const months = ['ينا', 'فبر', 'مار', 'أبر', 'ماي', 'يون', 'يول', 'أغس', 'سبت', 'أكت', 'نوف', 'ديس'];
    return '${d.day} ${months[d.month - 1]}';
  }
  String _t(TimeOfDay? t) => t == null ? '' : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  String _dt(DateTime d) => '${_d(d)}، ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  String _statusText(LeaveStatus s) => switch (s) { LeaveStatus.pending => 'قيد المراجعة', LeaveStatus.approved => 'مقبول', LeaveStatus.rejected => 'مرفوض', LeaveStatus.cancelled => 'ملغي' };
  String _typeText(LeaveType t) => switch (t) { LeaveType.annual => 'سنوية', LeaveType.sick => 'مرضية', LeaveType.unpaid => 'بدون راتب', LeaveType.urgent => 'طارئة', LeaveType.permission => 'استئذان' };
}


