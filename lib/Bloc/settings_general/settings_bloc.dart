import 'package:bloc/bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import '../../Data/Repositories/settings_repository.dart';
import '../../Data/Models/settings_general.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ISettingsRepository repository;
  SettingsBloc(this.repository) : super(SettingsState.initial()) {
    on<SettingsOpened>(_opened);
    on<OptionChanged>(_option);
    on<ResetRequested>(_reset);
    on<SaveRequested>(_save);
  }

  Future<void> _opened(SettingsOpened e, Emitter<SettingsState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final res = await repository.general();
      final model = SettingsGeneral.fromJson(Map<String, dynamic>.from(res));
      emit(state.copyWith(loading: false, model: model, dirty: false));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> _option(OptionChanged e, Emitter<SettingsState> emit) async {
    final m = state.model;
    if (m == null) return;
    emit(state.copyWith(model: _updateByPath(m, e.path, e.value), dirty: true));
  }

  Future<void> _reset(ResetRequested e, Emitter<SettingsState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final res = await repository.general();
      final model = SettingsGeneral.fromJson(Map<String, dynamic>.from(res));
      emit(state.copyWith(loading: false, model: model, dirty: false));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> _save(SaveRequested e, Emitter<SettingsState> emit) async {
    final m = state.model;
    if (m == null) return;
    emit(state.copyWith(saving: true));
    try {
      await repository.updateGeneral(m.toJson());
      emit(state.copyWith(saving: false, saveOk: true, dirty: false));
    } catch (_) {
      emit(state.copyWith(saving: false));
    }
  }

  SettingsGeneral _updateByPath(SettingsGeneral model, String path, dynamic value) {
    final parts = path.split('.');
    switch (parts.first) {
      case 'language':
        return model.copyWith(language: value as String);
      case 'theme':
        return model.copyWith(theme: value as String);
      case 'region':
        final r = model.region;
        if (parts.length >= 2) {
          switch (parts[1]) {
            case 'calendar':
              return model.copyWith(region: r.copyWith(calendar: value as String));
            case 'timeFormat':
              return model.copyWith(region: r.copyWith(timeFormat: value as String));
            case 'weekStart':
              return model.copyWith(region: r.copyWith(weekStart: value as String));
          }
        }
        return model;
      case 'privacy':
        final p = model.privacy;
        if (parts.length >= 2) {
          switch (parts[1]) {
            case 'shareAnonymousAnalytics':
              return model.copyWith(privacy: p.copyWith(shareAnonymousAnalytics: value as bool));
          }
        }
        return model;
      case 'security':
        final s = model.security;
        if (parts.length >= 2 && parts[1] == 'mfaEnabled') {
          return model.copyWith(security: s.copyWith(mfaEnabled: value as bool));
        }
        return model;
      case 'data':
        final d = model.data;
        if (parts.length >= 2) {
          switch (parts[1]) {
            case 'backgroundRefresh':
              return model.copyWith(data: d.copyWith(backgroundRefresh: value as bool));
            case 'useCellularData':
              return model.copyWith(data: d.copyWith(useCellularData: value as bool));
            case 'cacheSizeMB':
              return model.copyWith(data: d.copyWith(cacheSizeMB: value as int));
          }
        }
        return model;
      default:
        return model;
    }
  }
}


