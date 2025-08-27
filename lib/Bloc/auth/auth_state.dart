import 'package:equatable/equatable.dart';
import '../../Data/Models/role.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthRoleState extends AuthState {
  final Role role;
  const AuthRoleState({this.role = Role.guest});
  AuthRoleState copyWith({Role? role}) => AuthRoleState(role: role ?? this.role);
  @override
  List<Object?> get props => [role];
}


