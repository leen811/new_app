import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Bloc/auth/auth_bloc.dart';
import '../../../../Bloc/auth/auth_state.dart';
import '../../../../Data/Models/role.dart';
import '../../../Common/action_menu_sheet.dart';
import '../../../Common/action_menu_item.dart';
import '../../../Common/press_fx.dart';
import '../../../Dashboard/TeamLead/team_lead_dashboard_page.dart';

class GreetingStrip extends StatelessWidget {
  const GreetingStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final role = state is AuthRoleState ? state.role : Role.guest;
        final canSeeDashboard = _canSeeDashboard(role);
        
        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9EEF5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // زر لوحة القيادة (يظهر فقط للأدوار الإدارية)
                  if (canSeeDashboard)
                    _buildDashboardButton(role),
                  
                  const Spacer(),
                  
                  // زر القائمة الرئيسية
                  _MenuButton(),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // الترحيب
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFFFD700),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'مرحباً أحمد محمد',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // التاريخ والوقت
              Text(
                'الاثنين، 9 ربيع الأول ١٤٤٧ هـ في ٠٢:٤١ م',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  bool _canSeeDashboard(Role role) {
    return role == Role.manager || 
           role == Role.teamLeader || 
           role == Role.hr || 
           role == Role.finance;
  }
  
  Widget _buildDashboardButton(Role role) {
    return Builder(
      builder: (context) {
        VoidCallback onPressed;
        
        if (role == Role.teamLeader) {
          onPressed = () => _openTeamLeadDashboard(context);
        } else if (role == Role.manager) {
          onPressed = () => context.go('/manager/dashboard');
        } else {
          // لجميع الأدوار الأخرى (hr, sysAdmin, finance)
          onPressed = () => context.go('/hr/dashboard');
        }
        
        return OutlinedButton.icon(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 28),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          icon: const Icon(Icons.dashboard_outlined, size: 16),
          label: Text(
            'لوحة التحكم',
            style: GoogleFonts.cairo(fontSize: 12),
          ),
        ).withPressFX();
      },
    );
  }
  
  void _openTeamLeadDashboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TeamLeadDashboardPage(),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: IconButton(
        onPressed: () => _showActionMenu(context),
        icon: const Icon(
          Icons.apps_rounded,
          color: Color(0xFF3B82F6),
          size: 20,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ).withPressFX(),
    );
  }

  void _showActionMenu(BuildContext context) {
    final items = [
      ActionMenuItem(
        title: "متجر المكافآت",
        icon: Icons.card_giftcard_outlined,
        color: const Color(0xFFF59E0B),
        onTap: () => context.go("/rewards"),
      ),
      ActionMenuItem(
        title: "إشعارات الإيميل",
        icon: Icons.mail_outline,
        color: const Color(0xFF3B82F6),
        onTap: () => _showComingSoon(context, "إشعارات الإيميل"),
      ),
      ActionMenuItem(
        title: "التقارير",
        icon: Icons.description_outlined,
        color: const Color(0xFF8B5CF6),
        onTap: () => context.go("/reports"),
      ),
      ActionMenuItem(
        title: "طلبات الإجازة",
        icon: Icons.event_available_outlined,
        color: const Color(0xFF38BDF8),
        onTap: () => context.go("/leave"),
      ),
      ActionMenuItem(
        title: "مؤشرات الأداء",
        icon: Icons.show_chart_outlined,
        color: const Color(0xFF22C55E),
        onTap: () => context.go("/kpi"),
      ),
      ActionMenuItem(
        title: "تقييم 360",
        icon: Icons.emoji_events_outlined,
        color: const Color(0xFFF97316),
        onTap: () => context.go("/performance-360"),
      ),
      ActionMenuItem(
        title: "التوأم الرقمي",
        icon: Icons.memory_outlined,
        color: const Color(0xFFEC4899),
        onTap: () => context.go("/digital-twin"),
      ),
      ActionMenuItem(
        title: "التدريب الذكي",
        icon: Icons.school_outlined,
        color: const Color(0xFF06B6D4),
        onTap: () => context.go("/smart-training"),
      ),
    ];

    showActionMenuSheet(context, items);
  }

  void _showComingSoon(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('هذه الميزة ستكون متاحة قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ).withPressFX(),
        ],
      ),
    );
  }
}
