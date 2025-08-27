import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Bloc/auth/login_bloc.dart';
import '../../Bloc/auth/login_event.dart';
import '../../Bloc/auth/login_state.dart';
import '../../Data/Repositories/auth_repository.dart';
import '../tokens.dart';
import '../widgets/app_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => LoginBloc(ctx.read<IAuthRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Hero(
              tag: 'glass-card',
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 560),
                  padding: const EdgeInsets.all(24),
                  decoration: glassDecoration(context),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text('تسجيل الدخول', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.white70),
                            hintText: 'أدخل بريدك الإلكتروني',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          ),
                          onChanged: (v) => context.read<LoginBloc>().add(EmailChanged(v)),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
                            hintText: 'أدخل كلمة المرور',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          ),
                          obscureText: true,
                          onChanged: (v) => context.read<LoginBloc>().add(PasswordChanged(v)),
                        ),
                        const SizedBox(height: 12),
                        _RoleChips(),
                        const SizedBox(height: 12),
                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginSuccess) {
                              context.go('/company/new');
                            }
                          },
                          builder: (context, state) {
                            final loading = state is LoginLoading;
                            return AppButton(
                              label: 'تسجيل الدخول',
                              loading: loading,
                              onPressed: () => context.read<LoginBloc>().add(Submitted()),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 8,
                          spacing: 12,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(foregroundColor: Colors.white),
                              onPressed: () => context.go('/forgot'),
                              child: const Text('نسيت كلمة المرور؟'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(foregroundColor: Colors.white),
                              onPressed: () => context.go('/company/new'),
                              child: const Text('إنشاء حساب جديد'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final roles = const [
      {'label': 'موظف', 'role': UserRole.staff, 'color': Color(0xFF2251FF)},
      {'label': 'مدير', 'role': UserRole.manager, 'color': Color(0xFFE11D48)},
      {'label': 'قائد فريق', 'role': UserRole.lead, 'color': Color(0xFF7C3AED)},
      {'label': 'موارد بشرية', 'role': UserRole.hr, 'color': Color(0xFF06B6D4)},
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles
          .map((r) => ChoiceChip(
                selected: false,
                label: Text(r['label'] as String),
                onSelected: (_) => context.read<LoginBloc>().add(RoleChipTapped(r['role'] as UserRole)),
                selectedColor: (r['color'] as Color).withOpacity(0.9),
                backgroundColor: (r['color'] as Color).withOpacity(0.6),
                labelStyle: const TextStyle(color: Colors.white),
                shape: RoundedRectangleBorder(borderRadius: RadiusTokens.chip),
              ))
          .toList(),
    );
  }
}


