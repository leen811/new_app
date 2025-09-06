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
      appBar: AppBar(title: const Text('تقارير الحضور'), centerTitle: true, leading: const BackButton()),
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
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
              );
            },
          ),
        ),
      ),
    );
  }
}


