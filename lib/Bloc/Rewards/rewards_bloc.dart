import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/rewards_repository.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final RewardsRepository repository;
  
  RewardsBloc(this.repository) : super(const RewardsInitial()) {
    on<RewardsLoad>(_onRewardsLoad);
    on<RewardsChangeCategory>(_onRewardsChangeCategory);
  }
  
  Future<void> _onRewardsLoad(
    RewardsLoad event,
    Emitter<RewardsState> emit,
  ) async {
    emit(const RewardsLoading());
    
    try {
      final (balance, items, activity) = await repository.fetchAll();
      emit(RewardsLoaded(
        balance: balance,
        items: items,
        activity: activity,
        currentIndex: 0,
      ));
    } catch (e) {
      emit(RewardsError(e.toString()));
    }
  }
  
  void _onRewardsChangeCategory(
    RewardsChangeCategory event,
    Emitter<RewardsState> emit,
  ) {
    if (state is RewardsLoaded) {
      final currentState = state as RewardsLoaded;
      // التأكد من أن الفهرس صالح (0 أو 1 فقط)
      final validIndex = event.index.clamp(0, 1);
      emit(RewardsLoaded(
        balance: currentState.balance,
        items: currentState.items,
        activity: currentState.activity,
        currentIndex: validIndex,
      ));
    }
  }
}
