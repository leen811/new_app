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
import '../../Bloc/locale/locale_cubit.dart';
import '../../l10n/l10n.dart';

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
    final s = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(s.settings_general_app_bar_title, textAlign: TextAlign.right),
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
                SnackBar(
                  content: Text(s.settings_general_snackbar_saved_success),
                  backgroundColor: const Color(0xFF16A34A),
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
            final localeCubit = context.read<LocaleCubit>();
            String currentCode = m.language == s.settings_general_language_english ? 'en' : 'ar';
            return Directionality(
              textDirection: Directionality.of(context),
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
                          SectionHeader(title: s.settings_general_section_appearance_language),
                          const SizedBox(height: 12),
                          TileChoiceChips(
                            title: s.settings_general_label_language,
                            value: m.language, // display label stored in model
                            options: choiceOptions([
                              {'label': s.settings_general_language_arabic, 'icon': Icons.language},
                              {'label': s.settings_general_language_english, 'icon': Icons.translate},
                            ]),
                            onChanged: (display) async {
                              bloc.add(OptionChanged('language', display));
                              bloc.add(SaveRequested());
                              final code = display == s.settings_general_language_english ? 'en' : 'ar';
                              if (code == 'ar') {
                                await localeCubit.setArabic();
                              } else {
                                await localeCubit.setEnglish();
                              }
                            },
                            onExpand: () async {
                              final code = await showLanguagePickerSheet(
                                context,
                                current: currentCode,
                              );
                              if (code != null) {
                                final display = code == 'en' ? s.settings_general_language_english : s.settings_general_language_arabic;
                                bloc.add(OptionChanged('language', display));
                                bloc.add(SaveRequested());
                                if (code == 'ar') {
                                  await localeCubit.setArabic();
                                } else {
                                  await localeCubit.setEnglish();
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          TileChoiceChips(
                            title: s.settings_general_label_theme,
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
                          SectionHeader(title: s.settings_general_section_region),
                          const SizedBox(height: 12),
                          TileSelect(
                            title: s.settings_general_label_calendar,
                            value: m.region.calendar,
                            options: const ['هجري/ميلادي', 'ميلادي فقط'],
                            onChanged: (v) {
                              bloc.add(OptionChanged('region.calendar', v));
                              bloc.add(SaveRequested());
                            },
                          ),
                          const SizedBox(height: 12),
                          TileSelect(
                            title: s.settings_general_label_time_format,
                            value: m.region.timeFormat,
                            options: const ['24 ساعة', '12 ساعة'],
                            onChanged: (v) {
                              bloc.add(OptionChanged('region.timeFormat', v));
                              bloc.add(SaveRequested());
                            },
                          ),
                          const SizedBox(height: 12),
                          TileSelect(
                            title: s.settings_general_label_week_start,
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
                          SectionHeader(title: s.settings_general_section_about),
                          const SizedBox(height: 12),
                          InfoRow(label: s.settings_general_label_version, value: m.about.version),
                          const SizedBox(height: 12),
                          InfoRow(
                            label: s.settings_general_label_build_number,
                            value: m.about.build.toString(),
                          ),
                          const SizedBox(height: 12),
                          TileNav(
                            title: s.settings_general_nav_tos,
                            onTap: () =>
                                GoRouter.of(context).push('/about/tos'),
                          ),
                          const SizedBox(height: 12),
                          TileNav(
                            title: s.settings_general_nav_privacy,
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
                              title: Text(s.settings_general_dialog_reset_title),
                              content: Text(
                                s.settings_general_dialog_reset_message,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(s.common_cancel),
                                ).withPressFX(),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(s.common_confirm),
                                ).withPressFX(),
                              ],
                            ),
                          );
                          if (ok == true)
                            context.read<SettingsBloc>().add(ResetRequested());
                        },
                        child: Text(s.settings_general_button_reset),
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
