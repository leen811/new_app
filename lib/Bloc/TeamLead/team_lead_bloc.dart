import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/team_lead_repository.dart';
import 'team_lead_event.dart';
import 'team_lead_state.dart';

class TeamLeadBloc extends Bloc<TeamLeadEvent, TeamLeadState> {
  final TeamLeadRepository repository;
  
  TeamLeadBloc(this.repository) : super(const TLInitial()) {
    on<TLLoad>(_onLoad);
    on<TLChangeQuickTab>(_onChangeQuickTab);
  }
  
  Future<void> _onLoad(TLLoad event, Emitter<TeamLeadState> emit) async {
    emit(const TLLoading());
    
    try {
      final data = await repository.fetch();
      emit(TLLoaded(data: data, quickTab: 0));
    } catch (e) {
      emit(TLError(e.toString()));
    }
  }
  
  void _onChangeQuickTab(TLChangeQuickTab event, Emitter<TeamLeadState> emit) {
    if (state is TLLoaded) {
      final currentState = state as TLLoaded;
      emit(TLLoaded(
        data: currentState.data,
        quickTab: event.index,
      ));
    }
  }
}
