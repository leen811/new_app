import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PayrollSummary extends Equatable {
  final int grossSalary;
  final int totalDeductions;
  final int allowances;

  const PayrollSummary({
    required this.grossSalary,
    required this.totalDeductions,
    required this.allowances,
  });

  int get net => grossSalary - totalDeductions + allowances;

  @override
  List<Object?> get props => [grossSalary, totalDeductions, allowances];
}

class DeductionItem extends Equatable {
  final String title;
  final int amount;
  final String? note;

  const DeductionItem({
    required this.title,
    required this.amount,
    this.note,
  });

  @override
  List<Object?> get props => [title, amount, note];
}

class PayrollBreakdown extends Equatable {
  final int basicSalary;
  final int allowances;
  final List<DeductionItem> mandatory;
  final List<DeductionItem> penalties;
  final List<DeductionItem> optional;

  const PayrollBreakdown({
    required this.basicSalary,
    required this.allowances,
    required this.mandatory,
    required this.penalties,
    required this.optional,
  });

  @override
  List<Object?> get props => [basicSalary, allowances, mandatory, penalties, optional];
}

enum DeductionKind { mandatory, penalty, optional }
enum Frequency { monthly, once, weekly, daily }

class DeductionDetail {
  final DeductionKind kind;
  final String title;          // "التأمين الصحي"...
  final String description;    // "اشتراك التأمين الصحي الشهري"
  final int amount;            // 320 / 800 / 400 / 80 / 50
  final double? percentOfSalary; // 0.04, 0.10, 0.05, null, null
  final Frequency frequency;   // monthly/once
  final DateTime lastUpdate;   // استخدم تاريخ افتراضي
  final IconData icon;         // Icons.local_hospital_outlined, …
  
  const DeductionDetail({
    required this.kind,
    required this.title,
    required this.description,
    required this.amount,
    this.percentOfSalary,
    required this.frequency,
    required this.lastUpdate,
    required this.icon,
  });
}

class PayrollHistoryEntry {
  final int month;
  final int year;
  final num grossSalary;
  final num totalDeductions;
  
  num get netSalary => grossSalary - totalDeductions;
  double get netRatio => grossSalary == 0 ? 0 : (netSalary / grossSalary).toDouble();
  
  const PayrollHistoryEntry({
    required this.month,
    required this.year,
    required this.grossSalary,
    required this.totalDeductions,
  });
}
