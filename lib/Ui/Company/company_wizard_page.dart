import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/company/company_wizard_bloc.dart';
import '../../Bloc/company/company_wizard_event.dart';
import '../../Bloc/company/company_wizard_state.dart';
import '../../Data/Repositories/company_repository.dart';
import '../tokens.dart';
import '../widgets/app_button.dart';
import '../widgets/skeleton_box.dart';

class CompanyWizardPage extends StatelessWidget {
  const CompanyWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CompanyWizardBloc(ctx.read<ICompanyRepository>()),
      child: const _CompanyWizardView(),
    );
  }
}

class _CompanyWizardView extends StatelessWidget {
  const _CompanyWizardView();

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
                  constraints: const BoxConstraints(maxWidth: 640),
                  padding: const EdgeInsets.all(24),
                  decoration: glassDecoration(context),
                  child: BlocBuilder<CompanyWizardBloc, CompanyWizardState>(
                builder: (context, state) {
                  if (state is CompanyStep1State) {
                    if (state.loading) {
                      return const _WizardSkeleton();
                    }
                    return _Step1(meta: state.meta ?? {});
                  } else if (state is CompanyStep2State) {
                    if (state.loading) {
                      return const _WizardSkeleton();
                    }
                    return _Step2(meta: state.meta ?? {});
                  } else if (state is CompanyStep3State) {
                    return _Step3(meta: state.meta ?? {});
                  } else {
                    return const SizedBox.shrink();
                  }
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

class _StepHeader extends StatelessWidget {
  final int active; // 1..3
  const _StepHeader({required this.active});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [1, 2, 3].map((i) => _stepDot(i == active ? Colors.white : Colors.white54, i.toString())).toList(),
    );
  }

  Widget _stepDot(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: CircleAvatar(backgroundColor: color, radius: 12, child: Text(label, style: const TextStyle(color: Colors.black))),
    );
  }
}

class _Step1 extends StatefulWidget {
  final Map<String, List<Map<String, String>>> meta;
  const _Step1({required this.meta});
  @override
  State<_Step1> createState() => _Step1State();
}

class _Step1State extends State<_Step1> {
  final _formKey = GlobalKey<FormState>();
  String? _type;
  String? _sector;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepHeader(active: 1),
        const SizedBox(height: 8),
        Text('معلومات الشركة', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'أدخل اسم الشركة',
                  labelText: 'اسم الشركة',
                  prefixIcon: Icon(Icons.business, color: Colors.white70),
                  hintStyle: TextStyle(color: Colors.white70),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => context.read<CompanyWizardBloc>().add(Step1Changed(name: v)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'نوع الشركة',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                value: _type,
                items: widget.meta['types']!.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']!))).toList(),
                onChanged: (v) {
                  setState(() => _type = v);
                  context.read<CompanyWizardBloc>().add(Step1Changed(typeId: v));
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'القطاع',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                value: _sector,
                items: widget.meta['sectors']!.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']!))).toList(),
                onChanged: (v) {
                  setState(() => _sector = v);
                  context.read<CompanyWizardBloc>().add(Step1Changed(sectorId: v));
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'وصف الشركة',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                onChanged: (v) => context.read<CompanyWizardBloc>().add(Step1Changed(description: v)),
              ),
              const SizedBox(height: 16),
              AppButton(label: 'التالي', onPressed: () => context.read<CompanyWizardBloc>().add(Step1Next())),
            ],
          ),
        ),
      ],
    );
  }
}

class _Step2 extends StatefulWidget {
  final Map<String, List<Map<String, String>>> meta;
  const _Step2({required this.meta});

  @override
  State<_Step2> createState() => _Step2State();
}

class _Step2State extends State<_Step2> {
  String? _country;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepHeader(active: 2),
        const SizedBox(height: 8),
        Text('معلومات التواصل', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني للشركة',
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.email_outlined, color: Colors.white70),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => context.read<CompanyWizardBloc>().add(Step2Changed(email: v)),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            prefixIcon: Icon(Icons.phone_outlined, color: Colors.white70),
            hintText: '+966 5xxxxxxxx',
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.phone,
          onChanged: (v) => context.read<CompanyWizardBloc>().add(Step2Changed(phone: v)),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'العنوان',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => context.read<CompanyWizardBloc>().add(Step2Changed(address: v)),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            final countryField = DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'الدولة',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              value: _country,
              items: widget.meta['countries']!.map((e) => DropdownMenuItem(value: e['code'], child: Text(e['name']!))).toList(),
              onChanged: (v) {
                setState(() => _country = v);
                context.read<CompanyWizardBloc>().add(Step2Changed(countryCode: v));
              },
            );
            final cityField = TextFormField(
              decoration: const InputDecoration(
                labelText: 'المدينة',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => context.read<CompanyWizardBloc>().add(Step2Changed(city: v)),
            );

            if (isNarrow) {
              return Column(
                children: [
                  countryField,
                  const SizedBox(height: 12),
                  cityField,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: countryField),
                const SizedBox(width: 12),
                Expanded(child: cityField),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => context.read<CompanyWizardBloc>().add(Step2Prev()), child: const Text('السابق'))),
            const SizedBox(width: 12),
            Expanded(child: AppButton(label: 'التالي', onPressed: () => context.read<CompanyWizardBloc>().add(Step2Next()))),
          ],
        ),
      ],
    );
  }
}

class _Step3 extends StatefulWidget {
  final Map<String, List<Map<String, String>>> meta;
  const _Step3({required this.meta});
  @override
  State<_Step3> createState() => _Step3State();
}

class _Step3State extends State<_Step3> {
  final _adminName = TextEditingController();
  final _adminEmail = TextEditingController(text: 'admin@company.com');
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepHeader(active: 3),
        const SizedBox(height: 8),
        Text('حساب المدير', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        const SizedBox(height: 16),
        TextFormField(
          controller: _adminName,
          decoration: const InputDecoration(
            labelText: 'اسم المدير',
            hintText: 'الاسم الكامل للمدير',
            prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _adminEmail,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني للمدير',
            prefixIcon: Icon(Icons.mail_outline, color: Colors.white70),
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _password,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'كلمة المرور',
            hintText: 'كلمة مرور قوية',
            prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _confirm,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'تأكيد كلمة المرور',
            hintText: 'أعد إدخال كلمة المرور',
            prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => context.read<CompanyWizardBloc>().add(Step3Prev()), child: const Text('السابق'))),
            const SizedBox(width: 12),
            Expanded(child: AppButton(label: 'إنشاء الحساب', onPressed: () {})),
          ],
        ),
      ],
    );
  }
}

class _WizardSkeleton extends StatelessWidget {
  const _WizardSkeleton();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _StepHeader(active: 1),
        SizedBox(height: 16),
        SkeletonBox(height: 20),
        SizedBox(height: 12),
        SkeletonBox(height: 52),
        SizedBox(height: 12),
        SkeletonBox(height: 52),
        SizedBox(height: 12),
        SkeletonBox(height: 100),
        SizedBox(height: 16),
        SkeletonBox(height: 44),
      ],
    );
  }
}


