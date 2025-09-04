import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';
import '../Common/dashboard_entry_button.dart';
import '../../Data/Models/role.dart';

class HomeTeamPage extends StatelessWidget {
  const HomeTeamPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('👥 HomeTeamPage building...');
    return gradientBackground(
      child: Column(
        children: [
          // زر لوحة القيادة في أعلى الصفحة
          const DashboardEntryButton(allow: {Role.teamLeader, Role.sysAdmin}),
          
          // المحتوى الأصلي
          const Expanded(
            child: GlassCard(
              child: Text(
                'الرئيسية - فريق العمل', 
                style: TextStyle(color: Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
