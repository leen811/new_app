import 'package:bloc/bloc.dart';
import '../../Data/Repositories/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final IAuthRepository authRepository;
  OtpBloc(this.authRepository) : super(const OtpInitial()) {
    on<OtpChanged>((event, emit) {
      final current = state is OtpInitial ? state as OtpInitial : const OtpInitial();
      emit(current.copyWith(code: event.code));
    });
    on<VerifyPressed>(_onVerify);
    on<ResendPressed>(_onResend);
  }

  Future<void> _onVerify(VerifyPressed event, Emitter<OtpState> emit) async {
    final current = state is OtpInitial ? state as OtpInitial : const OtpInitial();
    emit(OtpVerifying());
    try {
      final ok = await authRepository.verifyOtp(code: current.code);
      if (ok) {
        emit(OtpVerified());
      } else {
        emit(const OtpError('رمز غير صحيح'));
      }
    } catch (e) {
      emit(const OtpError('فشل التحقق'));
    }
  }

  Future<void> _onResend(ResendPressed event, Emitter<OtpState> emit) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    emit(OtpResent());
  }
}


