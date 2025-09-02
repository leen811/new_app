import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Bloc/auth/auth_bloc.dart';
import '../../Bloc/auth/auth_state.dart';
import '../../Data/Models/role.dart';
import '../Home/home_factory.dart';
import '../Chat/company_chat_page.dart';
import '../Assistant/assistant_page.dart';
import '../Tasks/tasks_page.dart';
import '../Profile/profile_page.dart';
import '../_shared/attendance_fabs.dart';
import 'widgets/custom_bottom_nav.dart';
import '../../Bloc/attendance/attendance_bloc.dart';
import '../../Bloc/attendance/attendance_event.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '../../Data/Repositories/geofence_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/location_source.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = 0});
  final int initialIndex;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  
  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }
  
  @override
  void didUpdateWidget(covariant HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() => _index = widget.initialIndex);
    }
  }

  /// تغيير التبويب فوري بدون أنيميشن
  void _onTabChanged(int index) {
    if (_index != index) {
      setState(() => _index = index);
      // تحديث URL
      GoRouter.of(context).go('/?tab=$index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AttendanceBloc(
        attendanceRepository: ctx.read<IAttendanceRepository>(),
        geofenceRepository: ctx.read<IGeofenceRepository>(),
        policyRepository: ctx.read<IPolicyRepository>(),
        locationSource: ctx.read<ILocationSource>(),
      )..add(AttendanceInitRequested()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
        final role = state is AuthRoleState ? state.role : Role.guest;
        final pages = [
          HomeFactory.build(role),
          const CompanyChatPage(),
          const AssistantPage(),
          const TasksPage(),
          const ProfilePage(),
        ];
        return Scaffold(
          body: Stack(
            children: [
              // IndexedStack للتبويبات بدون سحب/أنيميشن
              IndexedStack(index: _index, children: pages),
              if (_index != 2) const AttendanceFABs(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _index,
            onItemSelected: _onTabChanged,
          ),
        );
      },
    ),
    );
  }
}


