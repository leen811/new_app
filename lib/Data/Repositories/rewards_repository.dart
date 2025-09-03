import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../Models/rewards_models.dart';

abstract class RewardsRepository {
  Future<(Balance, Map<RewardCategory, List<RewardItem>>, List<ActivityItem>)> fetchAll();
}

class MockRewardsRepository implements RewardsRepository {
  @override
  Future<(Balance, Map<RewardCategory, List<RewardItem>>, List<ActivityItem>)> fetchAll() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));
    
    final balance = const Balance(2450);
    
    final items = <RewardCategory, List<RewardItem>>{
      RewardCategory.internal: [
        RewardItem(
          id: 'dayoff',
          title: 'يوم إجازة إضافي',
          subtitle: 'احصل على يوم إجازة مدفوعة إضافية',
          imageUrl: 'https://picsum.photos/seed/dayoff/900/450',
          priceCoins: 1000,
          featured: true,
          leadingIcon: Icons.calendar_month_rounded,
        ),
        RewardItem(
          id: 'vip',
          title: 'ترقية مكتب VIP',
          subtitle: 'انتقل إلى مكتب أفضل لمدة شهر',
          imageUrl: 'https://picsum.photos/seed/office/900/450',
          priceCoins: 1500,
          leadingIcon: Icons.star_border_rounded,
        ),
        RewardItem(
          id: 'lunch',
          title: 'وجبة غداء مع الإدارة',
          subtitle: 'اجتماع غير رسمي مع فريق الإدارة',
          imageUrl: 'https://picsum.photos/seed/lunch/900/450',
          priceCoins: 800,
          leadingIcon: Icons.restaurant_rounded,
        ),
        RewardItem(
          id: 'course',
          title: 'دورة تدريبية مجانية',
          subtitle: 'اختر أي دورة تدريبية عبر الإنترنت',
          imageUrl: 'https://picsum.photos/seed/course/900/450',
          priceCoins: 1200,
          featured: true,
          leadingIcon: Icons.emoji_events_outlined,
        ),
      ],
      RewardCategory.giftCards: [
        RewardItem(
          id: 'gc-100',
          title: 'بطاقة شراء 100 ريال',
          subtitle: 'بطاقة هدايا للتسوق من المتاجر المحلية',
          imageUrl: 'https://picsum.photos/seed/gc100/1200/600',
          priceCoins: 500,
          featured: true,
          leadingIcon: Icons.shopping_cart_outlined,
        ),
        RewardItem(
          id: 'gc-250',
          title: 'بطاقة شراء 250 ريال',
          subtitle: 'بطاقة هدايا للتسوق من المتاجر المحلية',
          imageUrl: 'https://picsum.photos/seed/gc250/1200/600',
          priceCoins: 1100,
          leadingIcon: Icons.shopping_cart_outlined,
        ),
        RewardItem(
          id: 'fuel-20',
          title: 'خصم %20 على البنزين',
          subtitle: 'كوبون خصم لمحطات الوقود',
          imageUrl: 'https://picsum.photos/seed/fuel/1200/600',
          priceCoins: 300,
          leadingIcon: Icons.local_gas_station_outlined,
        ),
      ],
    };
    
    final activity = [
      ActivityItem(
        title: 'استبدلت بطاقة شراء 100 ريال',
        date: DateTime(2024, 2, 10),
      ),
      ActivityItem(
        title: 'حصلت على 50 كوينز من إكمال تحدي',
        date: DateTime(2024, 2, 9),
        coinsDelta: 50,
      ),
      ActivityItem(
        title: 'استبدلت يوم إجازة إضافي',
        date: DateTime(2024, 2, 8),
      ),
    ];
    
    return (balance, items, activity);
  }
}

class DioRewardsRepository implements RewardsRepository {
  final Dio dio;
  
  DioRewardsRepository(this.dio);
  
  @override
  Future<(Balance, Map<RewardCategory, List<RewardItem>>, List<ActivityItem>)> fetchAll() {
    // TODO: تنفيذ API calls
    throw UnimplementedError('DioRewardsRepository not implemented yet');
  }
}
