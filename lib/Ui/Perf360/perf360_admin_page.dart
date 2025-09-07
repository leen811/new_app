import 'package:flutter/material.dart';
import '../../Data/Repositories/perf360_admin_repository.dart';

class Perf360AdminPage extends StatefulWidget {
  const Perf360AdminPage({super.key});
  @override
  State<Perf360AdminPage> createState() => _Perf360AdminPageState();
}

class _Perf360AdminPageState extends State<Perf360AdminPage> {
  late final IPerf360AdminRepository repo;
  EvalCycleSummary? summary;
  List<EvalAssignmentItem>? items;
  EvalSettings? settings;
  String department = 'جميع الأقسام';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    repo = MockPerf360AdminRepository();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final s = await repo.getSummary();
    final list = await repo.listAssignments(department: department);
    final cfg = await repo.getSettings();
    setState(() {
      summary = s;
      items = list;
      settings = cfg;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('إدارة تقييم الأداء 360'),
      ),
      body: loading || summary == null || items == null || settings == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _SummaryCard(summary: summary!),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    settings: settings!,
                    onSave: (s) async {
                      await repo.saveSettings(s);
                      setState(() => settings = s);
                    },
                  ),
                  const SizedBox(height: 12),
                  _AssignmentsCard(
                    items: items!,
                    department: department,
                    onChangeDepartment: (d) async {
                      setState(() => department = d);
                      items = await repo.listAssignments(department: d);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final EvalCycleSummary summary;
  const _SummaryCard({required this.summary});
  @override
  Widget build(BuildContext context) {
    String fmt(DateTime d) => '${d.year}/${d.month}/${d.day}';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.dashboard_customize_outlined),
              SizedBox(width: 6),
              Text(
                'ملخص الدورة الحالية',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _metric('عدد الموظفين', summary.totalEmployees.toString()),
              _metric('المكلّفين بالتقييم', summary.assigned.toString()),
              _metric('المقيّمون (أرسلوا)', summary.submitted.toString()),
              _metric('عدد المقيمين', summary.reviewers.toString()),
              _metric(
                'الفترة',
                '${fmt(summary.period.start)} - ${fmt(summary.period.end)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE6EAF2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    ),
  );
}

class _AssignmentsCard extends StatelessWidget {
  final List<EvalAssignmentItem> items;
  final String department;
  final ValueChanged<String> onChangeDepartment;
  const _AssignmentsCard({
    required this.items,
    required this.department,
    required this.onChangeDepartment,
  });
  @override
  Widget build(BuildContext context) {
    const departments = [
      'جميع الأقسام',
      'التكنولوجيا',
      'التسويق',
      'المبيعات',
      'الموارد البشرية',
      'التصميم',
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.playlist_add_check_circle_outlined),
              SizedBox(width: 6),
              Text(
                'حالة التقييم حسب الموظفين',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('القسم:'),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownMenu<String>(
                  initialSelection: departments.contains(department) ? department : 'جميع الأقسام',
                  onSelected: (v) { if (v != null) onChangeDepartment(v); },
                  label: const Text('القسم'),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE6EAF2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE6EAF2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  dropdownMenuEntries: departments.map((d) => DropdownMenuEntry(value: d, label: d, leadingIcon: const Icon(Icons.apartment_rounded))).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (e) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6EAF2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          e.department,
                          style: const TextStyle(color: Color(0xFF667085)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (e.submitted
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFF3F4F6)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      e.submitted ? 'مكتمل' : 'لم يكتمل',
                      style: TextStyle(
                        color: e.submitted
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF9AA3B2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${e.receivedReviews}/${e.expectedReviews}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatefulWidget {
  final EvalSettings settings;
  final ValueChanged<EvalSettings> onSave;
  const _SettingsCard({required this.settings, required this.onSave});
  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  late bool self;
  late bool manager;
  late bool peers;
  late bool subs;
  late DateTimeRange period;

  @override
  void initState() {
    super.initState();
    self = widget.settings.self;
    manager = widget.settings.manager;
    peers = widget.settings.peers;
    subs = widget.settings.subordinates;
    period = widget.settings.period;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tune),
              SizedBox(width: 6),
              Text(
                'إعدادات التقييم',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('ذاتي'),
                selected: self,
                onSelected: (v) => setState(() => self = v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white,
                selectedColor: const Color.fromARGB(255, 172, 206, 174),
              ),
              FilterChip(
                label: const Text('المدير'),
                selected: manager,
                onSelected: (v) => setState(() => manager = v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white,
                selectedColor: const Color.fromARGB(255, 172, 206, 174),
              ),
              FilterChip(
                label: const Text('الزملاء'),
                selected: peers,
                onSelected: (v) => setState(() => peers = v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white,
                selectedColor: const Color.fromARGB(255, 172, 206, 174),
              ),
              FilterChip(
                label: const Text('المرؤوسون'),
                selected: subs,
                onSelected: (v) => setState(() => subs = v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white,
                selectedColor: const Color.fromARGB(255, 172, 206, 174),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('الفترة:'),
              const SizedBox(width: 4),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    locale: const Locale('ar'),
                  );
                  if (picked != null) setState(() => period = picked);
                },
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: Text(
                  '${period.start.year}/${period.start.month}/${period.start.day} - ${period.end.year}/${period.end.month}/${period.end.day}',
                ),
              ),
              const Spacer(),
             
            ],
          ),
           ElevatedButton.icon(
                onPressed: () => widget.onSave(
                  EvalSettings(
                    self: self,
                    manager: manager,
                    peers: peers,
                    subordinates: subs,
                    period: period,
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text('حفظ'),
              ),
        ],
      ),
    );
  }
}
