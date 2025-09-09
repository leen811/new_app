import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';
import '../Common/dashboard_entry_button.dart';
import '../../Data/Models/role.dart';
import '../Common/press_fx.dart';
import '../../Presentation/Common/navigation/routes_constants.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';

class HomeTeamPage extends StatelessWidget {
  const HomeTeamPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('👥 HomeTeamPage building...');
    final s = S.of(context);
    return gradientBackground(
      child: Column(
        children: [
          // زر لوحة القيادة في أعلى الصفحة
          const DashboardEntryButton(allow: {Role.teamLeader, Role.sysAdmin}),
          
          Expanded(
            child: GlassCard(
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.video_chat_rounded, size: 18),
                  label: Text(s.home_employee_quick_meetings_title),
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
