import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';
import '../Common/dashboard_entry_button.dart';
import '../../Data/Models/role.dart';

class HomeManagerPage extends StatelessWidget {
  const HomeManagerPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('👨‍💼 HomeManagerPage building...');
    return gradientBackground(
      child: Column(
        children: [
          // زر لوحة القيادة في أعلى الصفحة
          const DashboardEntryButton(allow: {Role.manager, Role.sysAdmin}),
          
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