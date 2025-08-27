import 'package:equatable/equatable.dart';

abstract class DtEvent extends Equatable {
  const DtEvent();
  @override
  List<Object?> get props => [];
}

class DtFetch extends DtEvent {}


