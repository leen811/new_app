import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Data/Repositories/settings_repository.dart';
import '../../Bloc/settings_general/settings_bloc.dart';
import '../../Bloc/settings_general/settings_event.dart';
import '../../Bloc/settings_general/settings_state.dart';
import 'widgets/section_header.dart';
import 'widgets/info_row.dart';
import 'widgets/tiles/tile_select.dart';
import 'widgets/tiles/tile_nav.dart';
import 'widgets/tiles/tile_choice_chips.dart';
import 'widgets/pickers/language_picker_sheet.dart';
import 'widgets/pickers/theme_picker_sheet.dart';
import '../Common/press_fx.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          SettingsBloc(ctx.read<ISettingsRepository>())..add(SettingsOpened()),
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
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('الإعدادات العامة', textAlign: TextAlign.right),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: null,
      body: SafeArea(
        child: BlocConsumer<SettingsBloc, SettingsState>(
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
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              );
            }
            final m = state.model!;
            final bloc = context.read<SettingsBloc>();
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SectionHeader(title: 'المظهر واللغة'),
                          const SizedBox(height: 12),
                          TileChoiceChips(
                            title: 'اللغة',
                            value: m.language,
                            options: choiceOptions(const [
                              {'label': 'العربية', 'icon': Icons.language},
                              {'label': 'English', 'icon': Icons.translate},
                            ]),
                            onChanged: (v) {
                              bloc.add(OptionChanged('language', v));
                              bloc.add(SaveRequested());
                            },
                            onExpand: () async {
                              final v = await showLanguagePickerSheet(
                                context,
                                current: m.language,
                              );
                              if (v != null) {
                                bloc.add(OptionChanged('language', v));
                                bloc.add(SaveRequested());
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          TileChoiceChips(
                            title: 'المظهر',
                            value: m.theme,
                            options: choiceOptions(const [
                              {
                                'label': 'فاتح',
                                'icon': Icons.light_mode_rounded,
                              },
                              {
                                'label': 'داكن',
                                'icon': Icons.dark_mode_rounded,
                              },
                            ]),
                            onChanged: (v) {
                              bloc.add(OptionChanged('theme', v));
                              bloc.add(SaveRequested());
                            },
                            onExpand: () async {
                              final v = await showThemePickerSheet(
                                context,
                                current: m.theme,
                              );
                              if (v != null) {
                                bloc.add(OptionChanged('theme', v));
                                bloc.add(SaveRequested());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SectionHeader(title: 'المنطقة والتنسيق'),
                          const SizedBox(height: 12),
                          TileSelect(
                            title: 'التقويم',
                            value: m.region.calendar,
                            options: const ['هجري/ميلادي', 'ميلادي فقط'],
                            onChanged: (v) {
                              bloc.add(OptionChanged('region.calendar', v));
                              bloc.add(SaveRequested());
                            },
                          ),
                          const SizedBox(height: 12),
                          TileSelect(
                            title: 'تنسيق الوقت',
                            value: m.region.timeFormat,
                            options: const ['24 ساعة', '12 ساعة'],
                            onChanged: (v) {
                              bloc.add(OptionChanged('region.timeFormat', v));
                              bloc.add(SaveRequested());
                            },
                          ),
                          const SizedBox(height: 12),
                          TileSelect(
                            title: 'أول يوم في الأسبوع',
                            value: m.region.weekStart,
                            options: const ['السبت', 'الأحد', 'الاثنين'],
                            onChanged: (v) {
                              bloc.add(OptionChanged('region.weekStart', v));
                              bloc.add(SaveRequested());
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SectionHeader(title: 'حول التطبيق'),
                          const SizedBox(height: 12),
                          InfoRow(label: 'الإصدار', value: m.about.version),
                          const SizedBox(height: 12),
                          InfoRow(
                            label: 'رقم البِناء',
                            value: m.about.build.toString(),
                          ),
                          const SizedBox(height: 12),
                          TileNav(
                            title: 'اتفاقية الاستخدام',
                            onTap: () =>
                                GoRouter.of(context).push('/about/tos'),
                          ),
                          const SizedBox(height: 12),
                          TileNav(
                            title: 'سياسة الخصوصية',
                            onTap: () =>
                                GoRouter.of(context).push('/about/privacy'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('إعادة التعيين'),
                              content: const Text(
                                'هل تريد إعادة الإعدادات إلى القيم الافتراضية؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('إلغاء'),
                                ).withPressFX(),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('تأكيد'),
                                ).withPressFX(),
                              ],
                            ),
                          );
                          if (ok == true)
                            context.read<SettingsBloc>().add(ResetRequested());
                        },
                        child: const Text('إعادة التعيين'),
                      ).withPressFX(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // String _cacheLabel(int mb) => '$mb م.ب';
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6EAF2)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
