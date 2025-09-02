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
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
        try {
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
                TickerMode(
                  enabled: ModalRoute.of(context)?.isCurrent ?? true,
                  child: (_index != 2) ? const AttendanceFABs() : const SizedBox.shrink(),
                ),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _index,
              onItemSelected: _onTabChanged,
            ),
          );
        } catch (e) {
          print('❌ Error in HomeShell: $e');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('حدث خطأ في عرض الصفحة'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}


