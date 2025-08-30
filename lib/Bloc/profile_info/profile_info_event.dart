import 'package:equatable/equatable.dart';

abstract class ProfileInfoEvent extends Equatable {
  const ProfileInfoEvent();
  @override
  List<Object?> get props => [];
}

class ProfileInfoOpened extends ProfileInfoEvent {}
class ProfileInfoEditToggled extends ProfileInfoEvent { final bool editing; const ProfileInfoEditToggled(this.editing); @override List<Object?> get props => [editing]; }
class ProfileInfoFieldChanged extends ProfileInfoEvent { final String key; final dynamic value; const ProfileInfoFieldChanged(this.key, this.value); @override List<Object?> get props => [key, value]; }
class ProfileInfoAvatarPicked extends ProfileInfoEvent { final String path; const ProfileInfoAvatarPicked(this.path); @override List<Object?> get props => [path]; }
class ProfileInfoSubmitRequested extends ProfileInfoEvent {}


