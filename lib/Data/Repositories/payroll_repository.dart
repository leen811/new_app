import 'package:dio/dio.dart';
import '../Models/payroll_models.dart';
import 'package:flutter/material.dart';

abstract class PayrollRepository {
  Future<(PayrollSummary, PayrollBreakdown)> fetchByMonth({
    required int month,
    required int year,
  });
  
  Future<List<DeductionDetail>> fetchDetailsByMonth({
    required int month,
    required int year,
  });
  
  Future<List<PayrollHistoryEntry>> fetchHistory({int limit = 12});
}

class MockPayrollRepository implements PayrollRepository {
  @override
  Future<(PayrollSummary, PayrollBreakdown)> fetchByMonth({
    required int month,
    required int year,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data matching the screenshots exactly
    const summary = PayrollSummary(
      grossSalary: 8000,
      totalDeductions: 1650,
      allowances: 800,
    );
    
    const breakdown = PayrollBreakdown(
      basicSalary: 8000,
      allowances: 800,
      mandatory: [
        DeductionItem(title: 'التأمين الصحي', amount: 320),
        DeductionItem(title: 'ضريبة الدخل', amount: 800),
        DeductionItem(title: 'التقاعد', amount: 400),
      ],
      penalties: [
        DeductionItem(
          title: 'خصم التأخير',
          amount: 80,
          note: 'تأخر 15 دقيقة',
        ),
      ],
      optional: [
        DeductionItem(title: 'قرض شخصي', amount: 50),
      ],
    );
    
    return (summary, breakdown);
  }
  
  @override
  Future<List<DeductionDetail>> fetchDetailsByMonth({
    required int month,
    required int year,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Mock data matching the requirements exactly
    return [
      DeductionDetail(
        kind: DeductionKind.mandatory,
        title: "التأمين الصحي",
        description: "اشتراك التأمين الصحي الشهري",
        amount: 320,
        percentOfSalary: 0.04,
        frequency: Frequency.monthly,
        lastUpdate: DateTime.now().subtract(const Duration(days: 2)),
        icon: Icons.local_hospital_outlined,
      ),
      DeductionDetail(
        kind: DeductionKind.mandatory,
        title: "ضريبة الدخل",
        description: "ضريبة الدخل الشهرية",
        amount: 800,
        percentOfSalary: 0.10,
        frequency: Frequency.monthly,
        lastUpdate: DateTime.now().subtract(const Duration(days: 1)),
        icon: Icons.receipt_long_outlined,
      ),
      DeductionDetail(
        kind: DeductionKind.mandatory,
        title: "التقاعد",
        description: "اشتراك صندوق التقاعد",
        amount: 400,
        percentOfSalary: 0.05,
        frequency: Frequency.monthly,
        lastUpdate: DateTime.now().subtract(const Duration(days: 3)),
        icon: Icons.savings_outlined,
      ),
      DeductionDetail(
        kind: DeductionKind.penalty,
        title: "خصم التأخير",
        description: "خصم عن التأخير 3 مرات هذا الشهر",
        amount: 80,
        percentOfSalary: null,
        frequency: Frequency.once,
        lastUpdate: DateTime.now().subtract(const Duration(hours: 12)),
        icon: Icons.error_outline,
      ),
      DeductionDetail(
        kind: DeductionKind.optional,
        title: "قرض شخصي",
        description: "قسط شهري من القرض الشخصي",
        amount: 50,
        percentOfSalary: null,
        frequency: Frequency.monthly,
        lastUpdate: DateTime.now().subtract(const Duration(days: 5)),
        icon: Icons.attach_money,
      ),
    ];
  }

  @override
  Future<List<PayrollHistoryEntry>> fetchHistory({int limit = 12}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Mock data matching the requirements exactly
    final data = <PayrollHistoryEntry>[
      PayrollHistoryEntry(month: 1, year: 2024, grossSalary: 8000, totalDeductions: 1520),
      PayrollHistoryEntry(month: 12, year: 2023, grossSalary: 7800, totalDeductions: 1456),
      PayrollHistoryEntry(month: 11, year: 2023, grossSalary: 8200, totalDeductions: 1558),
      PayrollHistoryEntry(month: 10, year: 2023, grossSalary: 8000, totalDeductions: 1520),
      PayrollHistoryEntry(month: 9, year: 2023, grossSalary: 7900, totalDeductions: 1501),
    ];
    return data.take(limit).toList();
  }
}

class DioPayrollRepository implements PayrollRepository {
  final Dio dio;
  
  DioPayrollRepository(this.dio);
  
  @override
  Future<(PayrollSummary, PayrollBreakdown)> fetchByMonth({
    required int month,
    required int year,
  }) async {
    // TODO: Implement actual API call
    // For now, throw unimplemented error
    throw UnimplementedError('DioPayrollRepository not implemented yet');
  }
  
  @override
  Future<List<DeductionDetail>> fetchDetailsByMonth({
    required int month,
    required int year,
  }) async {
    // TODO: Implement actual API call
    // For now, throw unimplemented error
    throw UnimplementedError('DioPayrollRepository not implemented yet');
  }
  
  @override
  Future<List<PayrollHistoryEntry>> fetchHistory({int limit = 12}) async {
    // TODO: Implement actual API call
    // For now, throw unimplemented error
    throw UnimplementedError('DioPayrollRepository not implemented yet');
  }
}
