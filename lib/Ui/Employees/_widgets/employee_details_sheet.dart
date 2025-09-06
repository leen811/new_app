import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../Data/Models/employee_models.dart';
import '../../Common/press_fx.dart';
import 'package:flutter/services.dart';

String _formatAr(DateTime dt, String pattern) {
  try {
    return DateFormat(pattern, 'ar').format(dt).replaceAll('AM', 'ص').replaceAll('PM', 'م');
  } catch (_) {
    return DateFormat(pattern).format(dt);
  }
}

String _formatNumAr(num value) {
  try {
    return NumberFormat.decimalPattern('ar').format(value);
  } catch (_) {
    return value.toString();
  }
}

Future<void> showEmployeeDetailsSheet(BuildContext ctx, Employee emp) async {
  final theme = Theme.of(ctx).copyWith(
    useMaterial3: true,
    textTheme: GoogleFonts.cairoTextTheme(Theme.of(ctx).textTheme),
  );
  await showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(ctx).size.height * 0.78,
    ),
    builder: (context) {
      return Theme(
        data: theme,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Directionality(
            textDirection: Directionality.of(ctx),
            child: _EmployeeDetails(emp: emp),
          ),
        ),
      );
    },
  );
}

class _EmployeeDetails extends StatefulWidget {
  final Employee emp;
  const _EmployeeDetails({required this.emp});
  @override
  State<_EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<_EmployeeDetails> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.emp;
    return Column(
      children: [
        // عناوين أعلى الشيت مثل الصور
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Column(
        //     children: const [
        //       Text('تفاصيل الموظف', style: TextStyle(fontWeight: FontWeight.w700)),
        //       SizedBox(height: 4),
        //       Text('عرض معلومات الموظف وتفاصيل الأداء', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: _HeaderCard(emp: emp),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _SegmentedTabs(controller: _tabController),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _PerformanceTab(emp: emp),
              _AttendanceTab(emp: emp),
              _LeavesTab(),
              _PermissionsTab(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, -2)),
          ]),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text('إغلاق'),
              ).withPressFX(),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قريبًا: تعديل الموظف'))),
                child: const Text('تعديل الموظف'),
              ).withPressFX(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Employee emp;
  const _HeaderCard({required this.emp});

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الحالة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: _statusBgColor(emp.status), borderRadius: BorderRadius.circular(12)),
            child: Text(_statusLabel(emp.status), style: TextStyle(color: _statusTextColor(emp.status), fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          // معلومات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(emp.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(emp.roleTitle, style: const TextStyle(color: Color(0xFF6B7280))),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    _miniInfo('الرقم', '4567'),
                    _miniInfo('انضم', _formatAr(DateTime.now(), 'yyyy/MM/dd')),
                    _miniInfo('هاتف', '966+ 123 50 4567'),
                    LayoutBuilder(builder: (context, constraints) {
                      return Row(mainAxisSize: MainAxisSize.max, children: [
                        const Icon(Icons.mail_rounded, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'ahmed.salem@company.com',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Color(0xFF111827)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(const ClipboardData(text: 'ahmed.salem@company.com'));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ البريد')));
                            }
                          },
                          icon: const Icon(Icons.content_copy_rounded, size: 18, color: Color(0xFF6B7280)),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ]);
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE6E9F0),
            backgroundImage: emp.avatarUrl != null ? NetworkImage(emp.avatarUrl!) : null,
            child: emp.avatarUrl == null
                ? Text(emp.name.trim().split(' ').where((p) => p.isNotEmpty).take(2).map((e) => e.characters.first).join(),
                    style: const TextStyle(fontWeight: FontWeight.bold))
                : null,
          ),
        ],
      ),
    );
  }

  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      ],
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final TabController controller;
  const _SegmentedTabs({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        labelColor: Colors.black,
        unselectedLabelColor: const Color(0xFF6B7280),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'الأداء'),
          Tab(text: 'الحضور'),
          Tab(text: 'الإجازات'),
          Tab(text: 'الصلاحيات'),
        ],
      ),
    );
  }
}

class _PerformanceTab extends StatelessWidget {
  final Employee emp;
  const _PerformanceTab({required this.emp});
  @override
  Widget build(BuildContext context) {
    // استخدام فورماتر آمن للأرقام عبر _formatNumAr
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Row(
          children: [
            Expanded(
              child: _MiniKpiCard(
                icon: Icons.monetization_on_outlined,
                iconColor: const Color(0xFFFF8A00),
                value: _formatNumAr(2450),
                label: 'كوين',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniKpiCard(
                icon: Icons.schedule_outlined,
                iconColor: const Color(0xFF7C3AED),
                value: _formatNumAr(45),
                label: 'مهمة مكتملة',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MiniKpiCard(
                icon: Icons.workspace_premium_outlined,
                iconColor: const Color(0xFF16A34A),
                value: emp.rating.toStringAsFixed(1),
                label: 'التقييم',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniKpiCard(
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF2563EB),
                value: _formatNumAr(98),
                label: 'مؤشر الأداء',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniKpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  const _MiniKpiCard({required this.icon, required this.iconColor, required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  final Employee emp;
  const _AttendanceTab({required this.emp});
  @override
  Widget build(BuildContext context) {
    final now = _formatAr(DateTime.now(), 'yyyy/MM/dd – hh:mm a');
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6E9F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('معدل الحضور: ${emp.attendancePct}%'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: (emp.attendancePct / 100).clamp(0, 1), backgroundColor: const Color(0xFFF3F4F6), color: const Color(0xFF2563EB)),
              const SizedBox(height: 12),
              const Text('معدل الحضور الإجمالي: 94%'),
              const SizedBox(height: 8),
              const LinearProgressIndicator(value: 0.94, backgroundColor: Color(0xFFF3F4F6), color: Color(0xFF2563EB)),
              const SizedBox(height: 12),
              Text('آخر نشاط: $now'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeavesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _LeaveCard(title: 'الإجازة السنوية', used: 8, total: 30),
            _LeaveCard(title: 'الإجازة المرضية', used: 2, total: 15),
          ],
        ),
      ],
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final String title;
  final int used;
  final int total;
  const _LeaveCard({required this.title, required this.used, required this.total});
  @override
  Widget build(BuildContext context) {
    final remain = (total - used).clamp(0, total);
    final availableWidth = MediaQuery.of(context).size.width - 16 - 16 - 12; // paddings + spacing
    final cardWidth = availableWidth / 2;
    return SizedBox(
      width: cardWidth,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6E9F0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('المستخدم', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text('$used أيام', style: const TextStyle(fontSize: 12)),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('المتاح', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text('$remain أيام', style: const TextStyle(fontSize: 12)),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('الإجمالي', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text('$total أيام', style: const TextStyle(fontSize: 12)),
            ]),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (used / total).clamp(0, 1), backgroundColor: const Color(0xFFF3F4F6), color: const Color(0xFF2563EB)),
          ],
        ),
      ),
    );
  }
}

class _PermissionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6E9F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('صلاحيات النظام — قريبًا', style: TextStyle(color: Color(0xFF6B7280))),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قريبًا: تعديل الصلاحيات'))),
                child: const Text('تعديل الصلاحيات'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


