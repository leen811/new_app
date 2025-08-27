import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Bloc/auth/forgot_bloc.dart';
import '../../Bloc/auth/forgot_event.dart';
import '../../Bloc/auth/forgot_state.dart';
import '../../Data/Repositories/auth_repository.dart';
import '../tokens.dart';
import '../widgets/app_button.dart';

class ForgotMethodPage extends StatelessWidget {
  const ForgotMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ForgotBloc(ctx.read<IAuthRepository>()),
      child: const _ForgotView(),
    );
  }
}

class _ForgotView extends StatelessWidget {
  const _ForgotView();
  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
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
                  constraints: const BoxConstraints(maxWidth: 640),
                  padding: const EdgeInsets.all(24),
                  decoration: glassDecoration(context),
              child: BlocConsumer<ForgotBloc, ForgotState>(
                listener: (context, state) {
                  if (state is ForgotCodeSent) {
                    context.go('/forgot/verify');
                  }
                },
                builder: (context, state) {
                  final initial = state is ForgotInitial ? state : const ForgotInitial();
                  final loading = state is ForgotLoading;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('استعادة كلمة المرور', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text('اختر طريقة الاستعادة:', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      RadioListTile<ForgotMethod>(
                        value: ForgotMethod.email,
                        groupValue: initial.method,
                        onChanged: (v) => context.read<ForgotBloc>().add(MethodSelected(v!)),
                        title: const Text('البريد الإلكتروني'),
                      ),
                      RadioListTile<ForgotMethod>(
                        value: ForgotMethod.sms,
                        groupValue: initial.method,
                        onChanged: (v) => context.read<ForgotBloc>().add(MethodSelected(v!)),
                        title: const Text('رسالة نصية'),
                      ),
                      if (initial.method == ForgotMethod.email) ...[
                        TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(hintText: 'أدخل بريدك الإلكتروني'),
                          onChanged: (v) => context.read<ForgotBloc>().add(EmailInputChanged(v)),
                        ),
                        const SizedBox(height: 12),
                      ],
                      AppButton(label: 'إرسال رمز التحقق', loading: loading, onPressed: () => context.read<ForgotBloc>().add(SendCodePressed())),
                    ],
                  );
                },
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


