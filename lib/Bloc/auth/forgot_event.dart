import 'package:equatable/equatable.dart';

enum ForgotMethod { email, sms }

abstract class ForgotEvent extends Equatable {
  const ForgotEvent();
  @override
  List<Object?> get props => [];
}

class MethodSelected extends ForgotEvent {
  final ForgotMethod method;
  const MethodSelected(this.method);
  @override
  List<Object?> get props => [method];
}

class EmailInputChanged extends ForgotEvent {
  final String email;
  const EmailInputChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class SendCodePressed extends ForgotEvent {}


