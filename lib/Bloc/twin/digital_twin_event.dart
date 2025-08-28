import 'package:equatable/equatable.dart';

abstract class DigitalTwinEvent extends Equatable {
  const DigitalTwinEvent();
  @override
  List<Object?> get props => [];
}

class TwinOpened extends DigitalTwinEvent {}
class TwinTabChanged extends DigitalTwinEvent { final int index; const TwinTabChanged(this.index); @override List<Object?> get props => [index]; }
class TwinRefreshed extends DigitalTwinEvent {}


