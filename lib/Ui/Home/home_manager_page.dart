import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';
import '../Common/dashboard_entry_button.dart';
import '../../Data/Models/role.dart';
import '../Common/press_fx.dart';
import '../../Presentation/Common/navigation/routes_constants.dart';
import 'package:go_router/go_router.dart';

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
          
          Expanded(
            child: GlassCard(
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.video_chat_rounded, size: 18),
                  label: const Text('اجتماعاتي'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => context.pushNamed(RoutesConstants.kMyMeetingsRouteName),
                ).withPressFX(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}