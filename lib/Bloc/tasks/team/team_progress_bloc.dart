import 'package:bloc/bloc.dart';

import '../../../Data/Repositories/tasks_repository.dart';
import 'team_progress_event.dart';
import 'team_progress_state.dart';

class TeamProgressBloc extends Bloc<TeamProgressEvent, TeamProgressState> {
  final ITasksRepository repository;
  TeamProgressBloc(this.repository) : super(TeamProgressInitial()) {
    on<TeamProgressFetch>(_onFetch);
    on<TeamProgressRefresh>(_onFetch);
  }

  Future<void> _onFetch(TeamProgressEvent event, Emitter<TeamProgressState> emit) async {
    emit(TeamProgressLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final items = await repository.fetchTeamProgress();
      if (items.isEmpty) emit(TeamProgressEmpty()); else emit(TeamProgressSuccess(items));
    } catch (e) {
      emit(const TeamProgressError('تعذر تحميل تقدم الفريق'));
    }
  }
}


