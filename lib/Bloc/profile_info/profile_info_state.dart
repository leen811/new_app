import 'package:equatable/equatable.dart';
import '../../Data/Models/profile/personal_info.dart';

class ProfileInfoState extends Equatable {
  final bool loading;
  final bool editing;
  final PersonalInfo? model;
  final Map<String, String> errors;
  final bool saving;
  final bool saveOk;
  const ProfileInfoState({required this.loading, required this.editing, required this.model, required this.errors, required this.saving, required this.saveOk});
  factory ProfileInfoState.initial() => const ProfileInfoState(loading: true, editing: false, model: null, errors: {}, saving: false, saveOk: false);
  ProfileInfoState copyWith({bool? loading, bool? editing, PersonalInfo? model, Map<String, String>? errors, bool? saving, bool? saveOk}) => ProfileInfoState(loading: loading ?? this.loading, editing: editing ?? this.editing, model: model ?? this.model, errors: errors ?? this.errors, saving: saving ?? this.saving, saveOk: saveOk ?? this.saveOk);
  @override
  List<Object?> get props => [loading, editing, model, errors, saving, saveOk];
}


