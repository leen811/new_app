import 'package:equatable/equatable.dart';

abstract class EmployeeHomeEvent extends Equatable {
  const EmployeeHomeEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeHomeLoaded extends EmployeeHomeEvent {
  const EmployeeHomeLoaded();
}
