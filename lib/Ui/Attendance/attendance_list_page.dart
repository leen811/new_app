import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '../../Bloc/AttendanceList/attendance_list_bloc.dart';
import '../../Bloc/AttendanceList/attendance_list_event.dart';
import '../../Bloc/AttendanceList/attendance_list_state.dart';
import 'employee_attendance_page.dart';
import '_widgets/employee_presence_tile.dart';
import '../../Core/Motion/swipe_transitions.dart';

class AttendanceListPage extends StatelessWidget {
  const AttendanceListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('تقارير الحضور', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => AttendanceListBloc(MockAttendanceDataRepository())..add(const LoadPresence()),
          child: BlocBuilder<AttendanceListBloc, AttendanceListState>(
            builder: (context, state) {
              if (state is AttendanceListLoading || state is AttendanceListInitial) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Container(height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12))),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(children: [
                        Expanded(child: Container(height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)))),
                        const SizedBox(width: 8),
                        Expanded(child: Container(height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)))),
                      ]),
                    ),
                    ...List.generate(8, (i) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Container(height: 72, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16))),
                    )),
                    const SizedBox(height: 24),
                  ],
                );
              }
              if (state is AttendanceListError) {
                return Center(child: Text(state.message));
              }
              final s = state as AttendanceListLoaded;
              return Column(
                children: [
                  // البحث أعلى الفلاتر
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث بالاسم أو القسم',
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      onSubmitted: (q) {
                        context.read<AttendanceListBloc>().add(LoadPresence(query: q, department: s.department, presence: s.presence));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        _PresenceFilter(
                          value: s.presence,
                          onChanged: (v) => context.read<AttendanceListBloc>().add(LoadPresence(query: s.query, department: s.department, presence: v)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _DepartmentFilter(
                            value: s.department,
                            onChanged: (dep) => context.read<AttendanceListBloc>().add(LoadPresence(query: s.query, department: dep, presence: s.presence)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // القائمة
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: s.list.length,
                      itemBuilder: (c, i) {
                        final it = s.list[i];
                        return EmployeePresenceTile(
                          item: it,
                          onTap: () => context.pushSwipe(
                            EmployeeAttendancePage(employeeId: it.id, name: it.name, avatarUrl: it.avatarUrl),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PresenceFilter extends StatelessWidget {
  final String value; // 'all' | 'present' | 'absent'
  final ValueChanged<String> onChanged;
  const _PresenceFilter({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: value,
      onSelected: (v) { if (v != null) onChanged(v); },
      label: const Text('التواجد'),
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
        DropdownMenuEntry(value: 'all', label: 'الكل', leadingIcon: Icon(Icons.filter_alt_rounded)),
        DropdownMenuEntry(value: 'present', label: 'حاضرون', leadingIcon: Icon(Icons.verified_rounded)),
        DropdownMenuEntry(value: 'absent', label: 'غير حاضرون', leadingIcon: Icon(Icons.pause_circle_rounded)),
      ],
    );
  }
}

class _DepartmentFilter extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _DepartmentFilter({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    // قائمة افتراضية للأقسام
    const departments = ['جميع الأقسام', 'التكنولوجيا', 'التسويق', 'المبيعات', 'الموارد البشرية', 'التصميم'];
    return DropdownMenu<String>(
      initialSelection: departments.contains(value) ? value : 'جميع الأقسام',
      onSelected: (v) { if (v != null) onChanged(v); },
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
      dropdownMenuEntries: departments.map((d) => DropdownMenuEntry(value: d, label: d, leadingIcon: const Icon(Icons.apartment_rounded))).toList(),
    );
  }
}


