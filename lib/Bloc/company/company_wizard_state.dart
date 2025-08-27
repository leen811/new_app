import 'package:equatable/equatable.dart';
import '../../Data/Models/company_model.dart';

abstract class CompanyWizardState extends Equatable {
  const CompanyWizardState();
  @override
  List<Object?> get props => [];
}

class CompanyStep1State extends CompanyWizardState {
  final CompanyStep1 data;
  final Map<String, List<Map<String, String>>>? meta;
  final bool loading;
  const CompanyStep1State({this.data = const CompanyStep1(), this.meta, this.loading = false});
  CompanyStep1State copyWith({CompanyStep1? data, Map<String, List<Map<String, String>>>? meta, bool? loading}) =>
      CompanyStep1State(data: data ?? this.data, meta: meta ?? this.meta, loading: loading ?? this.loading);
  @override
  List<Object?> get props => [data, meta, loading];
}

class CompanyStep2State extends CompanyWizardState {
  final CompanyStep1 step1;
  final CompanyStep2 data;
  final Map<String, List<Map<String, String>>>? meta;
  final bool loading;
  const CompanyStep2State({this.step1 = const CompanyStep1(), this.data = const CompanyStep2(), this.meta, this.loading = false});
  CompanyStep2State copyWith({CompanyStep1? step1, CompanyStep2? data, Map<String, List<Map<String, String>>>? meta, bool? loading}) =>
      CompanyStep2State(step1: step1 ?? this.step1, data: data ?? this.data, meta: meta ?? this.meta, loading: loading ?? this.loading);
  @override
  List<Object?> get props => [step1, data, meta, loading];
}

class CompanyStep3State extends CompanyWizardState {
  final CompanyStep1 step1;
  final CompanyStep2 step2;
  final Map<String, List<Map<String, String>>>? meta;
  const CompanyStep3State({this.step1 = const CompanyStep1(), this.step2 = const CompanyStep2(), this.meta});
  @override
  List<Object?> get props => [step1, step2, meta];
}

class CompanyWizardError extends CompanyWizardState {
  final String message;
  const CompanyWizardError(this.message);
  @override
  List<Object?> get props => [message];
}


