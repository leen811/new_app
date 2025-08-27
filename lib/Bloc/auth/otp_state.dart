import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();
  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {
  final String code;
  const OtpInitial({this.code = ''});
  OtpInitial copyWith({String? code}) => OtpInitial(code: code ?? this.code);
  @override
  List<Object?> get props => [code];
}

class OtpVerifying extends OtpState {}
class OtpVerified extends OtpState {}
class OtpError extends OtpState {
  final String message;
  const OtpError(this.message);
  @override
  List<Object?> get props => [message];
}
class OtpResent extends OtpState {}


