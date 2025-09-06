import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Employees/employees_bloc.dart';
import '../../Bloc/Employees/employees_event.dart';
import '../../Bloc/Employees/employees_state.dart';
import '../../Data/Repositories/employees_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '_widgets/filters_bar.dart';
import '_widgets/kpi_small_card.dart';
import '_widgets/employee_card.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الموظفين'),
          centerTitle: true,
          leading: const BackButton(),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: 'إضافة موظف جديد',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريبًا: إضافة موظف جديد')),
                );
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF16A34A)),
            ),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider(
            create: (_) => EmployeesBloc(MockEmployeesRepository())..add(const EmployeesLoad()),
            child: BlocBuilder<EmployeesBloc, EmployeesState>(
              builder: (ctx, st) {
                if (st is EmployeesLoading || st is EmployeesInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (st is EmployeesError) {
                  return Center(child: Text(st.message));
                }
                final s = st as EmployeesLoaded;

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: FiltersBar(
                        query: s.query,
                        department: s.department,
                        status: s.status,
                        onQueryChanged: (q) => ctx.read<EmployeesBloc>().add(EmployeesQueryChanged(q)),
                        onDepartmentChanged: (d) => ctx.read<EmployeesBloc>().add(EmployeesDepartmentChanged(d)),
                        onStatusChanged: (st) => ctx.read<EmployeesBloc>().add(EmployeesStatusChanged(st)),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      sliver: SliverList.list(children: [
                        Row(children: [
                          Expanded(child: KpiSmallCard(label: 'إجمالي الموظفين', value: s.summary.total.toString(), valueColor: const Color(0xFF2563EB))),
                          const SizedBox(width: 12),
                          Expanded(child: KpiSmallCard(label: 'الموظفين النشطين', value: s.summary.active.toString(), valueColor: const Color(0xFF16A34A))),
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(child: KpiSmallCard(label: 'في إجازة', value: s.summary.onLeave.toString(), valueColor: const Color(0xFFFF8A00))),
                          const SizedBox(width: 12),
                          Expanded(child: KpiSmallCard(label: 'غير نشط', value: s.summary.inactive.toString(), valueColor: const Color(0xFF9AA3B2))),
                        ]),
                      ]),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('قائمة الموظفين (${s.list.length})',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: s.list.length,
                      itemBuilder: (_, i) => EmployeeCard(emp: s.list[i]),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


