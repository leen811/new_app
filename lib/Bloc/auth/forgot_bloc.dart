import 'package:bloc/bloc.dart';
import '../../Data/Repositories/auth_repository.dart';
import 'forgot_event.dart';
import 'forgot_state.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  final IAuthRepository authRepository;
  ForgotBloc(this.authRepository) : super(const ForgotInitial()) {
    on<MethodSelected>((event, emit) {
      final current = state is ForgotInitial ? state as ForgotInitial : const ForgotInitial();
      emit(current.copyWith(method: event.method));
    });
    on<EmailInputChanged>((event, emit) {
      final current = state is ForgotInitial ? state as ForgotInitial : const ForgotInitial();
      emit(current.copyWith(email: event.email));
    });
    on<SendCodePressed>(_onSend);
  }

  Future<void> _onSend(SendCodePressed event, Emitter<ForgotState> emit) async {
    final current = state is ForgotInitial ? state as ForgotInitial : const ForgotInitial();
    emit(ForgotLoading());
    try {
      await authRepository.startForgot(method: current.method.name, email: current.email);
      emit(ForgotCodeSent());
    } catch (e) {
      emit(const ForgotError('فشل الإرسال'));
    }
  }
}


