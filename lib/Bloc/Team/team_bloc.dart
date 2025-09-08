import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Repositories/team_repository.dart';
import 'team_event.dart';
import 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository repository;
  String _query = '';

  TeamBloc(this.repository) : super(const TeamInitial()) {
    on<TeamLoad>(_onLoad);
    on<TeamSearchChanged>(_onSearch);
    on<TeamUpdateMember>(_onUpdateMember);
    on<TeamOpenMember>((event, emit) {}); // يُدار من الواجهة
    on<TeamAddMember>((event, emit) {}); // يُدار من الواجهة
  }

  Future<void> _fetch(Emitter<TeamState> emit) async {
    emit(const TeamLoading());
    try {
      final (kpis, list) = await repository.fetchTeam(query: _query);
      emit(TeamLoaded(kpis: kpis, members: list, query: _query));
    } catch (e) {
      emit(TeamError(e.toString()));
    }
  }

  Future<void> _onLoad(TeamLoad event, Emitter<TeamState> emit) async {
    await _fetch(emit);
  }

  Future<void> _onSearch(TeamSearchChanged event, Emitter<TeamState> emit) async {
    _query = event.q;
    await _fetch(emit);
  }

  Future<void> _onUpdateMember(TeamUpdateMember event, Emitter<TeamState> emit) async {
    final current = state;
    if (current is TeamLoaded) {
      // تحديث تفاؤلي
      final updatedMembers = current.members.map((m) {
        if (m.id != event.id) return m;
        return m.copyWith(
          title: event.title,
          availability: event.availability,
          skills: event.skills,
        );
      }).toList();
      emit(current.copyWith(members: updatedMembers));
    }
    try {
      await repository.updateMember(
        event.id,
        title: event.title,
        availability: event.availability,
        skills: event.skills,
      );
      // مزامنة
      if (current is TeamLoaded) {
        final (kpis, list) = await repository.fetchTeam(query: _query);
        emit(TeamLoaded(kpis: kpis, members: list, query: _query));
      }
    } catch (e) {
      emit(TeamError(e.toString()));
    }
  }
}


