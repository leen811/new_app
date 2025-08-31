import 'package:equatable/equatable.dart';
import '../../Data/Models/settings_general.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.loading,
    required this.saving,
    required this.saveOk,
    required this.dirty,
    required this.model,
  });

  final bool loading;
  final bool saving;
  final bool saveOk;
  final bool dirty;
  final SettingsGeneral? model;

  factory SettingsState.initial() => const SettingsState(
        loading: true,
        saving: false,
        saveOk: false,
        dirty: false,
        model: null,
      );

  SettingsState copyWith({
    bool? loading,
    bool? saving,
    bool? saveOk,
    bool? dirty,
    SettingsGeneral? model,
  }) {
    return SettingsState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      saveOk: saveOk ?? this.saveOk,
      dirty: dirty ?? this.dirty,
      model: model ?? this.model,
    );
  }

  @override
  List<Object?> get props => [loading, saving, saveOk, dirty, model];
}


