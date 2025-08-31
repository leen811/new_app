import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/auth/otp_bloc.dart';
import '../../Bloc/auth/otp_event.dart';
import '../../Bloc/auth/otp_state.dart';
import '../../Data/Repositories/auth_repository.dart';
import '../tokens.dart';
import '../widgets/app_button.dart';
import '../Common/press_fx.dart';

class OtpVerifyPage extends StatelessWidget {
  const OtpVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => OtpBloc(ctx.read<IAuthRepository>()),
      child: const _OtpView(),
    );
  }
}

class _OtpView extends StatelessWidget {
  const _OtpView();

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
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
              child: BlocConsumer<OtpBloc, OtpState>(
                listener: (context, state) {
                  if (state is OtpVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التحقق')));
                  }
                },
                builder: (context, state) {
                  final loading = state is OtpVerifying;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('استعادة كلمة المرور', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('تم إرسال رمز التحقق إلى:', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: ctrl,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(counterText: '', hintText: 'أدخل رمز التحقق المكون من 6 أرقام'),
                        onChanged: (v) => context.read<OtpBloc>().add(OtpChanged(v)),
                      ),
                      const SizedBox(height: 12),
                      AppButton(label: 'تحقّق من الرمز', loading: loading, onPressed: () => context.read<OtpBloc>().add(VerifyPressed())),
                      const SizedBox(height: 8),
                      TextButton(onPressed: () => context.read<OtpBloc>().add(ResendPressed()), child: const Text('إعادة الإرسال')).withPressFX(),
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


