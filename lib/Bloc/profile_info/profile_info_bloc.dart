import 'package:bloc/bloc.dart';
import 'profile_info_event.dart';
import 'profile_info_state.dart';
import '../../Data/Repositories/profile_repository.dart';
import '../../Data/Models/profile/personal_info.dart';

class ProfileInfoBloc extends Bloc<ProfileInfoEvent, ProfileInfoState> {
  final IProfileRepository repository;
  ProfileInfoBloc(this.repository) : super(ProfileInfoState.initial()) {
    on<ProfileInfoOpened>(_open);
    on<ProfileInfoEditToggled>((e, emit) => emit(state.copyWith(editing: e.editing, errors: {})));
    on<ProfileInfoFieldChanged>(_field);
    on<ProfileInfoAvatarPicked>(_avatar);
    on<ProfileInfoSubmitRequested>(_submit);
  }

  Future<void> _open(ProfileInfoOpened e, Emitter<ProfileInfoState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final res = await repository.personalInfo();
      final m = PersonalInfo.fromJson(Map<String, dynamic>.from(res));
      emit(state.copyWith(loading: false, model: m));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> _field(ProfileInfoFieldChanged e, Emitter<ProfileInfoState> emit) async {
    final m = state.model;
    if (m == null) return;
    final map = Map<String, dynamic>.from(m.toJson());
    map[e.key] = e.value;
    emit(state.copyWith(model: PersonalInfo.fromJson(map)));
  }

  Future<void> _avatar(ProfileInfoAvatarPicked e, Emitter<ProfileInfoState> emit) async {
    add(ProfileInfoFieldChanged('avatarUrl', e.path));
  }

  Future<void> _submit(ProfileInfoSubmitRequested e, Emitter<ProfileInfoState> emit) async {
    final m = state.model;
    if (m == null) return;
    final errs = <String, String>{};
    if (m.fullName.trim().length < 3) errs['fullName'] = 'الاسم مطلوب (3 أحرف على الأقل)';
    final emailRe = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRe.hasMatch(m.email)) errs['email'] = 'بريد إلكتروني غير صالح';
    final phoneRe = RegExp(r"^[+\d][\d\s+]{7,20}$");
    if (!phoneRe.hasMatch(m.phone)) errs['phone'] = 'رقم هاتف غير صالح';
    if (errs.isNotEmpty) {
      emit(state.copyWith(errors: errs));
      return;
    }
    emit(state.copyWith(saving: true));
    try {
      await repository.updatePersonalInfo(m.toJson());
      emit(state.copyWith(saving: false, saveOk: true, editing: false));
    } catch (_) {
      emit(state.copyWith(saving: false));
    }
  }
}


