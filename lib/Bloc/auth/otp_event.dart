import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();
  @override
  List<Object?> get props => [];
}

class OtpChanged extends OtpEvent {
  final String code;
  const OtpChanged(this.code);
  @override
  List<Object?> get props => [code];
}

class VerifyPressed extends OtpEvent {}
class ResendPressed extends OtpEvent {}


