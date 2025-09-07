import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Balance extends Equatable {
  final int coins;
  
  const Balance(this.coins);
  
  @override
  List<Object?> get props => [coins];
}

enum RewardCategory {
  internal,
  giftCards,
}

class RewardItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int priceCoins;
  final bool featured;
  final IconData? leadingIcon;
  
  const RewardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.priceCoins,
    this.featured = false,
    this.leadingIcon,
  });
  
  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    imageUrl,
    priceCoins,
    featured,
    leadingIcon,
  ];
}

class ActivityItem extends Equatable {
  final String title;
  final DateTime date;
  final int? coinsDelta;
  
  const ActivityItem({
    required this.title,
    required this.date,
    this.coinsDelta,
  });
  
  @override
  List<Object?> get props => [title, date, coinsDelta];
}

// ---------------- Admin Tokens & Rewards Models ----------------

class RewardsSummary extends Equatable {
  final int thisMonth;
  final int totalIssued;
  final int performancePoints;
  final int avgPerEmployee;

  const RewardsSummary({
    required this.thisMonth,
    required this.totalIssued,
    required this.performancePoints,
    required this.avgPerEmployee,
  });

  RewardsSummary copyWith({
    int? thisMonth,
    int? totalIssued,
    int? performancePoints,
    int? avgPerEmployee,
  }) => RewardsSummary(
        thisMonth: thisMonth ?? this.thisMonth,
        totalIssued: totalIssued ?? this.totalIssued,
        performancePoints: performancePoints ?? this.performancePoints,
        avgPerEmployee: avgPerEmployee ?? this.avgPerEmployee,
      );

  @override
  List<Object?> get props => [thisMonth, totalIssued, performancePoints, avgPerEmployee];
}

class RewardReason extends Equatable {
  final String id;
  final String title;
  final int points;
  final IconData icon;

  const RewardReason({
    required this.id,
    required this.title,
    required this.points,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, points, icon];
}

class EmployeeTokenBalance extends Equatable {
  final String id;
  final String name;
  final String title;
  final String department;
  final int points;
  final int earnedTotal;
  final double rating;
  final String? avatarUrl;
  final String lastActivity;

  const EmployeeTokenBalance({
    required this.id,
    required this.name,
    required this.title,
    required this.department,
    required this.points,
    required this.earnedTotal,
    required this.rating,
    required this.lastActivity,
    this.avatarUrl,
  });

  EmployeeTokenBalance copyWith({
    String? id,
    String? name,
    String? title,
    String? department,
    int? points,
    int? earnedTotal,
    double? rating,
    String? avatarUrl,
    String? lastActivity,
  }) => EmployeeTokenBalance(
        id: id ?? this.id,
        name: name ?? this.name,
        title: title ?? this.title,
        department: department ?? this.department,
        points: points ?? this.points,
        earnedTotal: earnedTotal ?? this.earnedTotal,
        rating: rating ?? this.rating,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        lastActivity: lastActivity ?? this.lastActivity,
      );

  @override
  List<Object?> get props => [id, name, title, department, points, earnedTotal, rating, avatarUrl, lastActivity];
}

class RewardTransaction extends Equatable {
  final String id;
  final String employeeName;
  final String byUser;
  final int amount;
  final bool isAdd;
  final String reason;
  final DateTime at;

  const RewardTransaction({
    required this.id,
    required this.employeeName,
    required this.byUser,
    required this.amount,
    required this.isAdd,
    required this.reason,
    required this.at,
  });

  @override
  List<Object?> get props => [id, employeeName, byUser, amount, isAdd, reason, at];
}