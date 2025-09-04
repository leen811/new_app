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
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> with AutomaticKeepAliveClientMixin {
  int _index = 0;
  late final List<Widget> _pages;
  Role? _lastRole;
  
  @override
  bool get wantKeepAlive => true;
  
  // Method to update tab index from outside
  void updateTabIndex(int newIndex) {
    if (_index != newIndex) {
      setState(() {
        _index = newIndex;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    
    // إنشاء الصفحات مع الدور الافتراضي
    _pages = [
      HomeFactory.build(Role.employee), // سيتم تحديثه عند تغيير الدور
      const CompanyChatPage(),
      const AssistantPage(),
      const TasksPage(),
      const ProfilePage(),
    ];
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // تحديث الصفحة الرئيسية عند تغيير الدور
        print('🔍 AuthBloc state changed: $state');
        if (state is AuthRoleState) {
          final newRole = state.role;
          print('🔍 New role: $newRole, Last role: $_lastRole');
          if (_lastRole != newRole) {
            _lastRole = newRole;
            _pages[0] = HomeFactory.build(newRole);
            print('🔍 Updated home page for role: $newRole');
            setState(() {}); // تحديث UI فقط عند تغيير الدور
          }
        }
      },
      child: PageStorage(
        bucket: PageStorageBucket(),
        child: Scaffold(
        body: Stack(
          children: [
            // IndexedStack للتبويبات بدون سحب/أنيميشن
            IndexedStack(index: _index, children: _pages),
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
        ),
      ),
    );
  }
}


