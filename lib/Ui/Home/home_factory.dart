import 'package:flutter/widgets.dart';
import '../../Data/Models/role.dart';
import 'home_employee_page.dart';
import 'home_manager_page.dart';
import 'home_leader_page.dart';
import 'home_hr_page.dart';
import 'home_guest_page.dart';

class HomeFactory {
  static Widget build(Role role) {
    switch (role) {
      case Role.employee:
        return const HomeEmployeePage();
      case Role.manager:
        return const HomeManagerPage();
      case Role.teamLeader:
        return const HomeLeaderPage();
      case Role.hr:
        return const HomeHrPage();
      default:
        return const HomeGuestPage();
    }
  }
}


