import 'package:equatable/equatable.dart';

abstract class CompanyWizardEvent extends Equatable {
  const CompanyWizardEvent();
  @override
  List<Object?> get props => [];
}

class Step1Changed extends CompanyWizardEvent {
  final String? name;
  final String? typeId;
  final String? sectorId;
  final String? description;
  const Step1Changed({this.name, this.typeId, this.sectorId, this.description});
}

class Step1Next extends CompanyWizardEvent {}

class Step2Changed extends CompanyWizardEvent {
  final String? email;
  final String? phone;
  final String? address;
  final String? countryCode;
  final String? city;
  const Step2Changed({this.email, this.phone, this.address, this.countryCode, this.city});
}

class Step2Prev extends CompanyWizardEvent {}
class Step2Next extends CompanyWizardEvent {}
class Step3Prev extends CompanyWizardEvent {}


