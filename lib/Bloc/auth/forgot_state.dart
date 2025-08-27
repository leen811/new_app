import 'package:equatable/equatable.dart';
import 'forgot_event.dart';

abstract class ForgotState extends Equatable {
  const ForgotState();
  @override
  List<Object?> get props => [];
}

class ForgotInitial extends ForgotState {
  final ForgotMethod method;
  final String email;
  const ForgotInitial({this.method = ForgotMethod.email, this.email = ''});
  ForgotInitial copyWith({ForgotMethod? method, String? email}) => ForgotInitial(
        method: method ?? this.method,
        email: email ?? this.email,
      );
  @override
  List<Object?> get props => [method, email];
}

class ForgotLoading extends ForgotState {}
class ForgotCodeSent extends ForgotState {}
class ForgotError extends ForgotState {
  final String message;
  const ForgotError(this.message);
  @override
  List<Object?> get props => [message];
}


