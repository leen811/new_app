import 'package:equatable/equatable.dart';
import '../../Data/Models/role.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthRoleChanged extends AuthEvent {
  final Role role;
  const AuthRoleChanged(this.role);
  @override
  List<Object?> get props => [role];
}


