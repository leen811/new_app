import 'package:flutter/material.dart';
import '../../../Data/Models/leaves_models.dart';
import '../../Common/press_fx.dart';
import '../../Core/Theme/tokens.dart' as tokens;

class RequestCard extends StatelessWidget {
  final LeaveRequest data;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onReject;
  final ValueChanged<String> onView;
  final bool overlapWarning;

  const RequestCard({
    super.key,
    required this.data,
    required this.onApprove,
    required this.onReject,
    required this.onView,
    this.overlapWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(data.type);
    // final statusText = _statusText(data.status);
    final typeText = _typeText(data.type);
    final dateText = data.isPermission
        ? '${_d(data.startAt)}، ${_t(data.timeFrom)} → ${_t(data.timeTo)}'
        : 'من ${_d(data.startAt)} → إلى ${_d(data.endAt)}';

    return GestureDetector(
      onTap: () => onView(data.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: tokens.RadiusTokens.card,
          border: Border.all(color: const Color(0xFFE6E9F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (overlapWarning)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Color(0xFFB45309),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'تنبيه: يتعارض مع طلب مقبول سابق لنفس الموظف',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                _StatusChip(status: data.status),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_typeIcon(data.type), color: color, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        typeText,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
              data.employeeName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${data.title} • ${data.department}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                dateText,
                style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
              ),
            ),
            const SizedBox(height: 8),
            if (!data.isPermission) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الرصيد: ${data.balanceBefore} → ${data.balanceAfter}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    'الأيام: ${data.daysRequested}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (data.note != null)
              Text(
                'ملاحظة: ${data.note}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: data.status == LeaveStatus.pending
                        ? () => onReject(data.id)
                        : null,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFFB91C1C),
                    ),
                    label: const Text(
                      'رفض',
                      style: TextStyle(
                        color: Color(0xFFB91C1C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFECACA)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: data.status == LeaveStatus.pending
                        ? () => onApprove(data.id)
                        : null,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text(
                      'قبول',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).withPressFX(),
    );
  }

  String _d(DateTime d) {
    const months = [
      'ينا',
      'فبر',
      'مار',
      'أبر',
      'ماي',
      'يون',
      'يول',
      'أغس',
      'سبت',
      'أكت',
      'نوف',
      'ديس',
    ];
    return '${d.day} ${months[d.month - 1]}';
  }

  String _t(TimeOfDay? t) => t == null
      ? ''
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _typeText(LeaveType t) => switch (t) {
    LeaveType.annual => 'سنوية',
    LeaveType.sick => 'مرضية',
    LeaveType.unpaid => 'بدون راتب',
    LeaveType.urgent => 'طارئة',
    LeaveType.permission => 'استئذان',
  };
  Color _typeColor(LeaveType t) => switch (t) {
    LeaveType.annual => const Color(0xFF22C55E),
    LeaveType.sick => const Color(0xFF3B82F6),
    LeaveType.unpaid => const Color(0xFFF59E0B),
    LeaveType.urgent => const Color(0xFFEF4444),
    LeaveType.permission => const Color(0xFF8B5CF6),
  };
  IconData _typeIcon(LeaveType t) => switch (t) {
    LeaveType.annual => Icons.beach_access,
    LeaveType.sick => Icons.sick,
    LeaveType.unpaid => Icons.money_off_csred_rounded,
    LeaveType.urgent => Icons.notification_important,
    LeaveType.permission => Icons.timer,
  };
}

class _StatusChip extends StatelessWidget {
  final LeaveStatus status;
  const _StatusChip({required this.status});
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bg.withOpacity(.8)),
      ),
      child: Text(
        _text(status),
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }

  static (Color, Color) _colors(LeaveStatus s) => switch (s) {
    LeaveStatus.pending => (const Color(0xFFFEF3C7), const Color(0xFF92400E)),
    LeaveStatus.approved => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
    LeaveStatus.rejected => (const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
    LeaveStatus.cancelled => (const Color(0xFFE5E7EB), const Color(0xFF374151)),
  };
  static String _text(LeaveStatus s) => switch (s) {
    LeaveStatus.pending => 'قيد المراجعة',
    LeaveStatus.approved => 'مقبول',
    LeaveStatus.rejected => 'مرفوض',
    LeaveStatus.cancelled => 'ملغي',
  };
}
