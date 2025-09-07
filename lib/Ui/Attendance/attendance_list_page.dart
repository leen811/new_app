import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '../../Bloc/AttendanceList/attendance_list_bloc.dart';
import '../../Bloc/AttendanceList/attendance_list_event.dart';
import '../../Bloc/AttendanceList/attendance_list_state.dart';
import 'employee_attendance_page.dart';
import '_widgets/employee_presence_tile.dart';

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
                return const Center(child: CircularProgressIndicator());
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
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EmployeeAttendancePage(employeeId: it.id, name: it.name, avatarUrl: it.avatarUrl),
                          )),
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
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9F0)),
        ),
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('الكل')),
            DropdownMenuItem(value: 'present', child: Text('حاضرون')),
            DropdownMenuItem(value: 'absent', child: Text('غير حاضرون')),
          ],
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
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
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9F0)),
        ),
        child: DropdownButton<String>(
          value: departments.contains(value) ? value : 'جميع الأقسام',
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}


