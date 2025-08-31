import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Repositories/profile_repository.dart';

import '../../../Bloc/profile_info/profile_info_bloc.dart';
import '../../../Bloc/profile_info/profile_info_event.dart';
import '../../../Bloc/profile_info/profile_info_state.dart';

import 'widgets/section_header.dart';
import 'widgets/labeled_text_field.dart';
import 'widgets/read_only_row.dart';
import 'widgets/avatar_stack.dart';
import '../../Common/press_fx.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          ProfileInfoBloc(ctx.read<IProfileRepository>())
            ..add(ProfileInfoOpened()),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('المعلومات الشخصية'),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
        builder: (context, state) {
          if (state.loading) return const SizedBox.shrink();
          if (!state.editing) {
            return FloatingActionButton.extended(
              backgroundColor: const Color(0xFF2F56D9),
              onPressed: () => context.read<ProfileInfoBloc>().add(
                ProfileInfoEditToggled(true),
              ),
              foregroundColor: Colors.white,

              label: const Text('تعديل'),
              icon: const Icon(Icons.edit),
            ).withPressFX();
          }
          return FloatingActionButton.extended(
            backgroundColor: const Color(0xFF16A34A),
            onPressed: () => context.read<ProfileInfoBloc>().add(
              ProfileInfoSubmitRequested(),
            ),
            foregroundColor: Colors.white,

            label: const Text('حفظ'),
            icon: const Icon(Icons.check),
          ).withPressFX();
        },
      ),
      body: SafeArea(
        child: BlocConsumer<ProfileInfoBloc, ProfileInfoState>(
          listener: (context, state) {
            if (state.saveOk) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حفظ التغييرات'),
                  backgroundColor: Color(0xFF16A34A),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.loading || state.model == null) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              );
            }
            final m = state.model!;
            final nameCtrl = TextEditingController(text: m.fullName);
            final emailCtrl = TextEditingController(text: m.email);
            final phoneCtrl = TextEditingController(text: m.phone);
            final cityCtrl = TextEditingController(text: m.city);
            // final countryCtrl = TextEditingController(text: m.country);
            final addrCtrl = TextEditingController(text: m.address);
            final roleCtrl = TextEditingController(text: m.role);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE6EAF2)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsetsDirectional.only(
                        start: 12,
                        end: 8,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Row(
                        children: [
                          AvatarStack(
                            imageUrl: m.avatarUrl,
                            onEdit: () => context.read<ProfileInfoBloc>().add(
                              const ProfileInfoAvatarPicked(
                                'assets/mock/local_avatar.png',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    m.fullName,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${m.role} — ${m.dept}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEF2FF),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text('المستوى ${m.level}'),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFE6EAF2),
                                        ),
                                      ),
                                      child: Text('${m.coins} 🪙'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (!state.editing)
                            FittedBox(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF2F56D9),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () => context
                                    .read<ProfileInfoBloc>()
                                    .add(ProfileInfoEditToggled(true)),
                                child: const Text('تعديل'),
                              ).withPressFX(),
                            )
                          else
                            FittedBox(
                              child: TextButton(
                                onPressed: () => context
                                    .read<ProfileInfoBloc>()
                                    .add(ProfileInfoEditToggled(false)),
                                child: const Text('إلغاء'),
                              ).withPressFX(),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SectionHeader(title: 'البيانات الأساسية'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE6EAF2)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          state.editing
                              ? LabeledTextField(
                                  label: 'الاسم الكامل',
                                  controller: nameCtrl,
                                  onChanged: (v) =>
                                      context.read<ProfileInfoBloc>().add(
                                        ProfileInfoFieldChanged('fullName', v),
                                      ),
                                  error: state.errors['fullName'],
                                )
                              : ReadOnlyRow(
                                  label: 'الاسم الكامل',
                                  value: m.fullName,
                                ),
                          const SizedBox(height: 12),
                          ReadOnlyRow(label: 'رقم الموظف', value: m.employeeNo),
                          const SizedBox(height: 12),
                          state.editing
                              ? LabeledTextField(
                                  label: 'البريد الإلكتروني',
                                  controller: emailCtrl,
                                  onChanged: (v) => context
                                      .read<ProfileInfoBloc>()
                                      .add(ProfileInfoFieldChanged('email', v)),
                                  error: state.errors['email'],
                                )
                              : ReadOnlyRow(
                                  label: 'البريد الإلكتروني',
                                  value: m.email,
                                ),
                          const SizedBox(height: 12),
                          state.editing
                              ? LabeledTextField(
                                  label: 'رقم الهاتف',
                                  controller: phoneCtrl,
                                  onChanged: (v) => context
                                      .read<ProfileInfoBloc>()
                                      .add(ProfileInfoFieldChanged('phone', v)),
                                  keyboardType: TextInputType.phone,
                                  error: state.errors['phone'],
                                )
                              : ReadOnlyRow(
                                  label: 'رقم الهاتف',
                                  value: m.phone,
                                ),
                          const SizedBox(height: 12),
                          ReadOnlyRow(
                            label: 'تاريخ الانضمام',
                            value: m.joinDate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SectionHeader(title: 'العمل'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE6EAF2)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsetsDirectional.only(
                        start: 12,
                        end: 12,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        children: [
                          state.editing
                              ? LabeledTextField(
                                  label: 'الدور الوظيفي',
                                  controller: roleCtrl,
                                  onChanged: (v) => context
                                      .read<ProfileInfoBloc>()
                                      .add(ProfileInfoFieldChanged('role', v)),
                                )
                              : ReadOnlyRow(
                                  label: 'الدور الوظيفي',
                                  value: m.role,
                                ),
                          const SizedBox(height: 12),
                          state.editing
                              ? _RightAlignedDropdown(
                                  label: 'القسم',
                                  value: m.dept,
                                  items: const [
                                    'التقنية',
                                    'العمليات',
                                    'المبيعات',
                                  ],
                                  onChanged: (v) => context
                                      .read<ProfileInfoBloc>()
                                      .add(ProfileInfoFieldChanged('dept', v)),
                                )
                              : ReadOnlyRow(label: 'القسم', value: m.dept),
                          const SizedBox(height: 12),
                          state.editing
                              ? _RightAlignedDropdown(
                                  label: 'المدير المباشر',
                                  value: m.manager,
                                  items: const [
                                    'سارة أحمد',
                                    'محمد علي',
                                    'ليلى فهد',
                                    'خالد يوسف',
                                    'نورا سالم',
                                  ],
                                  onChanged: (v) =>
                                      context.read<ProfileInfoBloc>().add(
                                        ProfileInfoFieldChanged('manager', v),
                                      ),
                                )
                              : ReadOnlyRow(
                                  label: 'المدير المباشر',
                                  value: m.manager,
                                ),
                          const SizedBox(height: 12),
                          ReadOnlyRow(
                            label: 'المستوى',
                            value: m.level.toString(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SectionHeader(title: 'العنوان'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE6EAF2)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsetsDirectional.only(
                        start: 12,
                        end: 12,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        children: [
                          state.editing
                              ? _RightAlignedDropdown(
                                  label: 'الدولة',
                                  value: m.country,
                                  items: const ['السعودية', 'الإمارات', 'مصر'],
                                  onChanged: (v) =>
                                      context.read<ProfileInfoBloc>().add(
                                        ProfileInfoFieldChanged('country', v),
                                      ),
                                )
                              : ReadOnlyRow(label: 'الدولة', value: m.country),
                          const SizedBox(height: 12),
                          state.editing
                              ? LabeledTextField(
                                  label: 'المدينة',
                                  controller: cityCtrl,
                                  onChanged: (v) => context
                                      .read<ProfileInfoBloc>()
                                      .add(ProfileInfoFieldChanged('city', v)),
                                )
                              : ReadOnlyRow(label: 'المدينة', value: m.city),
                          const SizedBox(height: 12),
                          state.editing
                              ? LabeledTextField(
                                  label: 'العنوان التفصيلي',
                                  controller: addrCtrl,
                                  onChanged: (v) =>
                                      context.read<ProfileInfoBloc>().add(
                                        ProfileInfoFieldChanged('address', v),
                                      ),
                                  maxLines: 3,
                                )
                              : ReadOnlyRow(
                                  label: 'العنوان التفصيلي',
                                  value: m.address,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RightAlignedDropdown extends StatelessWidget {
  const _RightAlignedDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE6EAF2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              alignment: Alignment.centerRight,
              items: items
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(e, textAlign: TextAlign.right),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
