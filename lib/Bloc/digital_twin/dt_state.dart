import 'package:equatable/equatable.dart';

abstract class DtState extends Equatable {
  const DtState();
  @override
  List<Object?> get props => [];
}

class DtInitial extends DtState {}
class DtLoading extends DtState {}
class DtLoaded extends DtState {
  final Map<String, dynamic> summary;
  const DtLoaded(this.summary);
  @override
  List<Object?> get props => [summary];
}
class DtEmpty extends DtState {}
class DtError extends DtState {
  final String message;
  const DtError(this.message);
  @override
  List<Object?> get props => [message];
}

