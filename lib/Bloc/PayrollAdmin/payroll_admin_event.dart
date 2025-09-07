import 'package:meta/meta.dart';

@immutable
sealed class AdminPayrollEvent {}

class AdminPayrollLoad extends AdminPayrollEvent {}

class AdminEmployeesSearchChanged extends AdminPayrollEvent {
  final String query;
  AdminEmployeesSearchChanged(this.query);
}

class AdminEmployeesFilterChanged extends AdminPayrollEvent {
  final String filter;
  AdminEmployeesFilterChanged(this.filter);
}

class AdminChangeTab extends AdminPayrollEvent {
  final int index;
  AdminChangeTab(this.index);
}


