import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';
import '../Common/dashboard_entry_button.dart';
import '../../Data/Models/role.dart';

class HomeHrPage extends StatelessWidget {
  const HomeHrPage({super.key});
  @override
  Widget build(BuildContext context) {
    print('🏢 HomeHrPage building...');
    return gradientBackground(
      child: Column(
        children: [
          // زر لوحة القيادة في أعلى الصفحة
          const DashboardEntryButton(allow: {Role.hr, Role.sysAdmin}),
          
          // المحتوى الأصلي
          const Expanded(
            child: GlassCard(
              child: Text(
                'الرئيسية - موارد بشرية', 
                style: TextStyle(color: Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}


