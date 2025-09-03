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
