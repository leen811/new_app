import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Models/rewards_models.dart';

abstract class RewardsAdminRepository {
  Future<(RewardsSummary, List<RewardReason>)> fetchSummary();
  Future<List<EmployeeTokenBalance>> fetchBalances({String query = ''});
  Future<List<RewardTransaction>> fetchTransactions();
  Future<void> grantTokens({
    required String employeeId,
    required int amount,
    required String reason,
    bool deduct = false,
  });
  Future<void> grantGroup({required String reasonId});
}

class MockRewardsAdminRepository implements RewardsAdminRepository {
  RewardsSummary _summary = const RewardsSummary(
    thisMonth: 15500,
    totalIssued: 125000,
    performancePoints: 2450,
    avgPerEmployee: 880,
  );

  late final List<RewardReason> _reasons = [
    const RewardReason(id: 'performance', title: 'أداء متميز', points: 100, icon: Icons.trending_up_rounded),
    const RewardReason(id: 'project', title: 'إكمال مشروع', points: 200, icon: Icons.task_alt_rounded),
    const RewardReason(id: 'innovation', title: 'ابتكار', points: 150, icon: Icons.lightbulb_outline_rounded),
    const RewardReason(id: 'teamwork', title: 'عمل جماعي', points: 75, icon: Icons.groups_rounded),
    const RewardReason(id: 'attendance', title: 'حضور مثالي', points: 50, icon: Icons.calendar_month_rounded),
    const RewardReason(id: 'other', title: 'سبب آخر', points: 0, icon: Icons.more_horiz_rounded),
  ];

  final List<EmployeeTokenBalance> _balances = [
    const EmployeeTokenBalance(
      id: 'e1',
      name: 'أحمد محمد',
      title: 'مهندس برمجيات',
      department: 'التكنولوجيا',
      points: 1240,
      earnedTotal: 3200,
      rating: 4.6,
      lastActivity: 'منح 200 توكينز (إكمال مشروع) منذ 3 أيام',
      avatarUrl: 'https://i.pravatar.cc/100?img=12',
    ),
    const EmployeeTokenBalance(
      id: 'e2',
      name: 'فاطمة علي',
      title: 'أخصائية موارد بشرية',
      department: 'الموارد البشرية',
      points: 980,
      earnedTotal: 2400,
      rating: 4.2,
      lastActivity: 'خصم 50 توكينز (تأخير) منذ 5 أيام',
      avatarUrl: 'https://i.pravatar.cc/100?img=5',
    ),
    const EmployeeTokenBalance(
      id: 'e3',
      name: 'سلمان الدوسري',
      title: 'قائد فريق',
      department: 'المبيعات',
      points: 1530,
      earnedTotal: 4100,
      rating: 4.8,
      lastActivity: 'منح 100 توكينز (أداء متميز) أمس',
      avatarUrl: 'https://i.pravatar.cc/100?img=3',
    ),
    const EmployeeTokenBalance(
      id: 'e4',
      name: 'نورة السبيعي',
      title: 'مصممة UX',
      department: 'التصميم',
      points: 860,
      earnedTotal: 1900,
      rating: 4.3,
      lastActivity: 'منح 75 توكينز (عمل جماعي) منذ أسبوع',
      avatarUrl: 'https://i.pravatar.cc/100?img=48',
    ),
    const EmployeeTokenBalance(
      id: 'e5',
      name: 'ياسر القحطاني',
      title: 'محلل نظم',
      department: 'التكنولوجيا',
      points: 720,
      earnedTotal: 1600,
      rating: 4.1,
      lastActivity: 'منح 50 توكينز (حضور مثالي) منذ يومين',
      avatarUrl: 'https://i.pravatar.cc/100?img=16',
    ),
  ];

  final List<RewardTransaction> _transactions = [
    RewardTransaction(
      id: 't1',
      employeeName: 'أحمد محمد',
      byUser: 'مدير النظام',
      amount: 200,
      isAdd: true,
      reason: 'إكمال مشروع',
      at: DateTime.now().subtract(const Duration(days: 3)),
    ),
    RewardTransaction(
      id: 't2',
      employeeName: 'سلمان الدوسري',
      byUser: 'قائد الفريق',
      amount: 100,
      isAdd: true,
      reason: 'أداء متميز',
      at: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RewardTransaction(
      id: 't3',
      employeeName: 'نورة السبيعي',
      byUser: 'مدير التصميم',
      amount: 75,
      isAdd: true,
      reason: 'عمل جماعي',
      at: DateTime.now().subtract(const Duration(days: 7)),
    ),
    RewardTransaction(
      id: 't4',
      employeeName: 'فاطمة علي',
      byUser: 'مسؤول الموارد',
      amount: 50,
      isAdd: false,
      reason: 'تأخير',
      at: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Future<(RewardsSummary, List<RewardReason>)> fetchSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<RewardReason> typed = List<RewardReason>.unmodifiable(_reasons);
    return (_summary, typed);
  }

  @override
  Future<List<EmployeeTokenBalance>> fetchBalances({String query = ''}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final q = query.trim();
    if (q.isEmpty) return List.unmodifiable(_balances);
    return _balances
        .where((e) => e.name.contains(q) || e.department.contains(q) || e.title.contains(q))
        .toList(growable: false);
  }

  @override
  Future<List<RewardTransaction>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 220));
    final sorted = [..._transactions]..sort((a, b) => b.at.compareTo(a.at));
    return sorted;
  }

  @override
  Future<void> grantTokens({
    required String employeeId,
    required int amount,
    required String reason,
    bool deduct = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 280));
    final idx = _balances.indexWhere((e) => e.id == employeeId);
    if (idx == -1) return;
    final current = _balances[idx];
    final delta = deduct ? -amount : amount;
    _balances[idx] = current.copyWith(points: max(0, current.points + delta));
    _transactions.add(RewardTransaction(
      id: 't${_transactions.length + 1}',
      employeeName: current.name,
      byUser: 'أنت',
      amount: amount,
      isAdd: !deduct,
      reason: reason,
      at: DateTime.now(),
    ));
    _summary = _summary.copyWith(
      thisMonth: max(0, _summary.thisMonth + delta),
      totalIssued: max(0, _summary.totalIssued + delta),
    );
  }

  @override
  Future<void> grantGroup({required String reasonId}) async {
    await Future.delayed(const Duration(milliseconds: 320));
    final reason = _reasons.firstWhere((r) => r.id == reasonId, orElse: () => const RewardReason(id: 'other', title: 'سبب آخر', points: 0, icon: Icons.more_horiz_rounded));
    final pts = reason.points;
    if (pts <= 0) return;
    for (var i = 0; i < _balances.length; i++) {
      final e = _balances[i];
      _balances[i] = e.copyWith(points: e.points + pts);
      _transactions.add(RewardTransaction(
        id: 't${_transactions.length + 1}',
        employeeName: e.name,
        byUser: 'توزيع جماعي',
        amount: pts,
        isAdd: true,
        reason: reason.title,
        at: DateTime.now(),
      ));
    }
    _summary = _summary.copyWith(
      thisMonth: _summary.thisMonth + (pts * _balances.length),
      totalIssued: _summary.totalIssued + (pts * _balances.length),
    );
  }
}

class DioRewardsAdminRepository implements RewardsAdminRepository {
  final Dio dio;

  DioRewardsAdminRepository(this.dio);

  @override
  Future<(RewardsSummary, List<RewardReason>)> fetchSummary() {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<EmployeeTokenBalance>> fetchBalances({String query = ''}) {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<RewardTransaction>> fetchTransactions() {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> grantGroup({required String reasonId}) {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> grantTokens({required String employeeId, required int amount, required String reason, bool deduct = false}) {
    // TODO: implement API call
    throw UnimplementedError();
  }
}


