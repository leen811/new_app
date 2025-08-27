import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthRoleState()) {
    on<AuthRoleChanged>((event, emit) => emit(AuthRoleState(role: event.role)));
  }
}


