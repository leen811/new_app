import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsOpened extends SettingsEvent {}
class OptionChanged extends SettingsEvent { final String path; final dynamic value; const OptionChanged(this.path, this.value); @override List<Object?> get props => [path, value]; }
class ResetRequested extends SettingsEvent {}
class SaveRequested extends SettingsEvent {}


