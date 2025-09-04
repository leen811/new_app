import 'package:flutter/widgets.dart';
import '../../Data/Models/role.dart';
import 'Employee/employee_home_page.dart';
import 'home_hr_page.dart';
import 'home_team_page.dart';

class HomeFactory {
  static Widget build(Role role) {
    print('🏠 HomeFactory building page for role: $role');
    // عرض الصفحة المناسبة حسب الدور
    switch (role) {
      case Role.hr:
        print('🏠 Building HomeHrPage');
        return const HomeHrPage();
      case Role.teamLeader:
        print('🏠 Building HomeTeamPage');
        return const HomeTeamPage();
      case Role.employee:
      case Role.manager:
      case Role.finance:
      case Role.sysAdmin:
      case Role.guest:
        print('🏠 Building EmployeeHomePage');
        return const EmployeeHomePage();
    }
  }
}


