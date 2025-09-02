import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import '../../Data/Models/role.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthRoleState()) {
    on<AuthRoleChanged>((event, emit) => emit(AuthRoleState(role: event.role)));
    on<AuthLogoutRequested>((event, emit) => emit(const AuthRoleState(role: Role.guest)));
  }
}


