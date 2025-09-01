import 'package:equatable/equatable.dart';

abstract class PayrollDeductionsEvent extends Equatable {
  const PayrollDeductionsEvent();

  @override
  List<Object?> get props => [];
}

class PayrollLoad extends PayrollDeductionsEvent {
  final int month;
  final int year;

  const PayrollLoad({
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [month, year];
}

class PayrollChangeTab extends PayrollDeductionsEvent {
  final int index;

  const PayrollChangeTab(this.index);

  @override
  List<Object?> get props => [index];
}
