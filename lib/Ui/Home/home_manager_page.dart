import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';
import '../Manager/Home/manager_dashboard_entry_button.dart';

class HomeManagerPage extends StatelessWidget {
  const HomeManagerPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('👨‍💼 HomeManagerPage building...');
    return gradientBackground(
      child: Column(
        children: [
          // زر لوحة القيادة في أعلى الصفحة
          const ManagerDashboardEntryButton(),
          
          // المحتوى الأصلي
          const Expanded(
            child: GlassCard(
              child: Text(
                'الرئيسية - الإدارة', 
                style: TextStyle(color: Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}