import 'package:equatable/equatable.dart';

enum LoginMethod { email, employeeId }
enum UserRole { staff, manager, lead, hr }

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginEmailSelected extends LoginEvent {}
class LoginEmployeeIdSelected extends LoginEvent {}
class RoleChipTapped extends LoginEvent {
  final UserRole role;
  const RoleChipTapped(this.role);
  @override
  List<Object?> get props => [role];
}
class EmailChanged extends LoginEvent {
  final String email;
  const EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}
class PasswordChanged extends LoginEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}
class Submitted extends LoginEvent {}


