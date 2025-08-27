import 'package:bloc/bloc.dart';

import '../../Data/Repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthRepository authRepository;
  LoginBloc(this.authRepository) : super(const LoginInitial()) {
    on<LoginEmailSelected>((event, emit) {
      final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
      emit(current.copyWith(method: LoginMethod.email));
    });
    on<LoginEmployeeIdSelected>((event, emit) {
      final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
      emit(current.copyWith(method: LoginMethod.employeeId));
    });
    on<RoleChipTapped>((event, emit) {
      final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
      emit(current.copyWith(role: event.role));
    });
    on<EmailChanged>((event, emit) {
      final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
      emit(current.copyWith(email: event.email));
    });
    on<PasswordChanged>((event, emit) {
      final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
      emit(current.copyWith(password: event.password));
    });
    on<Submitted>(_onSubmit);
  }

  Future<void> _onSubmit(Submitted event, Emitter<LoginState> emit) async {
    final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
    emit(LoginLoading());
    try {
      final user = await authRepository.login(email: current.email, password: current.password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(const LoginError('فشل تسجيل الدخول'));
    }
  }
}


