import 'package:bloc/bloc.dart';
import 'manager_dashboard_event.dart';
import 'manager_dashboard_state.dart';
import '../../Data/Repositories/manager_dashboard_repository.dart';

class ManagerDashboardBloc extends Bloc<ManagerDashboardEvent, ManagerDashboardState> {
  final IManagerDashboardRepository repository;

  ManagerDashboardBloc({required this.repository}) : super(const ManagerInitial()) {
    on<ManagerLoad>(_onLoad);
  }

  Future<void> _onLoad(ManagerLoad event, Emitter<ManagerDashboardState> emit) async {
    emit(const ManagerLoading());
    
    try {
      final data = await repository.getManagerDashboardData();
      emit(ManagerLoaded(data: data));
    } catch (e) {
      emit(ManagerError(message: e.toString()));
    }
  }
}
