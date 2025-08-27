import 'package:bloc/bloc.dart';

import '../../Data/Models/company_model.dart';
import '../../Data/Repositories/company_repository.dart';
import 'company_wizard_event.dart';
import 'company_wizard_state.dart';

class CompanyWizardBloc extends Bloc<CompanyWizardEvent, CompanyWizardState> {
  final ICompanyRepository repository;
  CompanyWizardBloc(this.repository) : super(const CompanyStep1State(loading: true)) {
    on<Step1Changed>((event, emit) async {
      final current = state is CompanyStep1State ? state as CompanyStep1State : const CompanyStep1State();
      emit(current.copyWith(data: current.data.copyWith(
        name: event.name ?? current.data.name,
        typeId: event.typeId ?? current.data.typeId,
        sectorId: event.sectorId ?? current.data.sectorId,
        description: event.description ?? current.data.description,
      )));
    });

    on<Step1Next>(_onStep1Next);
    on<Step2Changed>((event, emit) {
      final current = state is CompanyStep2State ? state as CompanyStep2State : const CompanyStep2State();
      emit(current.copyWith(data: current.data.copyWith(
        email: event.email ?? current.data.email,
        phone: event.phone ?? current.data.phone,
        address: event.address ?? current.data.address,
        countryCode: event.countryCode ?? current.data.countryCode,
        city: event.city ?? current.data.city,
      )));
    });
    on<Step2Prev>((event, emit) {
      final current = state is CompanyStep2State ? state as CompanyStep2State : const CompanyStep2State();
      emit(CompanyStep1State(data: current.step1, meta: current.meta));
    });
    on<Step2Next>(_onStep2Next);
    on<Step3Prev>((event, emit) {
      if (state is CompanyStep3State) {
        final s = state as CompanyStep3State;
        emit(CompanyStep2State(step1: s.step1, data: s.step2, meta: s.meta));
      } else {
        emit(const CompanyStep2State());
      }
    });

    _loadMeta();
  }

  Future<void> _loadMeta() async {
    final meta = await repository.getMeta();
    emit(CompanyStep1State(data: const CompanyStep1(), meta: meta));
  }

  Future<void> _onStep1Next(Step1Next event, Emitter<CompanyWizardState> emit) async {
    final current = state is CompanyStep1State ? state as CompanyStep1State : const CompanyStep1State();
    emit(current.copyWith(loading: true));
    await repository.submitStep1(current.data);
    emit(CompanyStep2State(step1: current.data, meta: current.meta));
  }

  Future<void> _onStep2Next(Step2Next event, Emitter<CompanyWizardState> emit) async {
    final current = state is CompanyStep2State ? state as CompanyStep2State : const CompanyStep2State();
    emit(current.copyWith(loading: true));
    await repository.submitStep2(current.data);
    emit(CompanyStep3State(step1: current.step1, step2: current.data, meta: current.meta));
  }
}


