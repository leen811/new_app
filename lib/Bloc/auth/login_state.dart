import 'package:equatable/equatable.dart';
import '../../Data/Models/user_model.dart';
import 'login_event.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  final LoginMethod method;
  final UserRole selectedRole;
  final String email;
  final String password;
  const LoginInitial({
    this.method = LoginMethod.email,
    this.selectedRole = UserRole.staff,
    this.email = '',
    this.password = '',
  });

  LoginInitial copyWith({LoginMethod? method, UserRole? role, String? email, String? password}) => LoginInitial(
        method: method ?? this.method,
        selectedRole: role ?? selectedRole,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  List<Object?> get props => [method, selectedRole, email, password];
}

class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final UserModel user;
  const LoginSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
  @override
  List<Object?> get props => [message];
}


