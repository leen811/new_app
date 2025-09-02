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
import '../Joint/widgets/custom_bottom_nav.dart';
import '../../Bloc/attendance/attendance_bloc.dart';
import '../../Bloc/attendance/attendance_event.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '../../Data/Repositories/geofence_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/location_source.dart';

/// Shell محسن للتبويبات مع IndexedStack (بدون سحب)
class BottomShell extends StatefulWidget {
  const BottomShell({super.key, this.initialIndex = 0});
  final int initialIndex;
  
  @override
  State<BottomShell> createState() => _BottomShellState();
}

class _BottomShellState extends State<BottomShell> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }
  
  @override
  void didUpdateWidget(covariant BottomShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  /// تغيير التبويب فوري بدون أنيميشن
  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
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
          
          // تعريف الصفحات
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
                IndexedStack(index: _currentIndex, children: pages),
                
                // أزرار الحضور (إلا في تبويب المساعد)
                if (_currentIndex != 2) const AttendanceFABs(),
              ],
            ),
            
            // شريط التنقل السفلي
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onItemSelected: _onTabChanged,
            ),
          );
        },
      ),
    );
  }
}
