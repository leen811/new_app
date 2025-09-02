import 'package:flutter/widgets.dart';
import '../../Data/Models/role.dart';
import 'Employee/employee_home_page.dart';

class HomeFactory {
  static Widget build(Role role) {
    // عرض EmployeeHomePage للجميع بغض النظر عن الدور
    return const EmployeeHomePage();
  }
}


