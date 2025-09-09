import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// App title shown in task switcher and places using MaterialApp.title
  ///
  /// In en, this message translates to:
  /// **'Company Manager'**
  String get app_app_title;

  /// Generic placeholder text: Coming soon
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get common_coming_soon;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get common_error_title;

  /// Generic retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// Placeholder page title for change password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get router_change_password_title;

  /// AppBar title for General Settings page
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get settings_general_app_bar_title;

  /// Section header for appearance and language
  ///
  /// In en, this message translates to:
  /// **'Appearance & Language'**
  String get settings_general_section_appearance_language;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_general_label_language;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get settings_general_language_arabic;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_general_language_english;

  /// Label for theme selection
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_general_label_theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_general_theme_light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_general_theme_dark;

  /// Section header for region and formatting
  ///
  /// In en, this message translates to:
  /// **'Region & Formatting'**
  String get settings_general_section_region;

  /// Label for calendar selection
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get settings_general_label_calendar;

  /// Calendar option: Hijri/Gregorian
  ///
  /// In en, this message translates to:
  /// **'Hijri/Gregorian'**
  String get settings_general_calendar_hijri_gregorian;

  /// Calendar option: Gregorian only
  ///
  /// In en, this message translates to:
  /// **'Gregorian only'**
  String get settings_general_calendar_gregorian_only;

  /// Label for time format selection
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get settings_general_label_time_format;

  /// 24-hour time format option
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get settings_general_time_format_24h;

  /// 12-hour time format option
  ///
  /// In en, this message translates to:
  /// **'12-hour'**
  String get settings_general_time_format_12h;

  /// Label for week start selection
  ///
  /// In en, this message translates to:
  /// **'First day of week'**
  String get settings_general_label_week_start;

  /// Week start option: Saturday
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get settings_general_week_start_saturday;

  /// Week start option: Sunday
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get settings_general_week_start_sunday;

  /// Week start option: Monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get settings_general_week_start_monday;

  /// Section header for About
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get settings_general_section_about;

  /// Label for version row
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settings_general_label_version;

  /// Label for build number row
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get settings_general_label_build_number;

  /// Nav to TOS
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get settings_general_nav_tos;

  /// Nav to privacy
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settings_general_nav_privacy;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settings_general_button_reset;

  /// Reset dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settings_general_dialog_reset_title;

  /// Reset dialog message
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset settings to defaults?'**
  String get settings_general_dialog_reset_message;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// Confirm action
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// Snackbar: saved successfully
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get settings_general_snackbar_saved_success;

  /// Employee home - quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get home_employee_quick_actions_title;

  /// Quick action: meetings title
  ///
  /// In en, this message translates to:
  /// **'My meetings'**
  String get home_employee_quick_meetings_title;

  /// Quick action: meetings subtitle
  ///
  /// In en, this message translates to:
  /// **'Today, upcoming and completed'**
  String get home_employee_quick_meetings_subtitle;

  /// Quick action: tasks title
  ///
  /// In en, this message translates to:
  /// **'Daily tasks'**
  String get home_employee_quick_tasks_title;

  /// Quick action: tasks subtitle
  ///
  /// In en, this message translates to:
  /// **'Your tasks and challenges'**
  String get home_employee_quick_tasks_subtitle;

  /// Quick action: attendance title
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get home_employee_quick_attendance_title;

  /// Quick action: attendance subtitle
  ///
  /// In en, this message translates to:
  /// **'Check-in and check-out'**
  String get home_employee_quick_attendance_subtitle;

  /// Quick action: leaves title
  ///
  /// In en, this message translates to:
  /// **'Leaves & permissions'**
  String get home_employee_quick_leaves_title;

  /// Quick action: leaves subtitle
  ///
  /// In en, this message translates to:
  /// **'Request a leave or permission'**
  String get home_employee_quick_leaves_subtitle;

  /// Quick action: rewards title
  ///
  /// In en, this message translates to:
  /// **'Rewards store'**
  String get home_employee_quick_rewards_title;

  /// Quick action: rewards subtitle
  ///
  /// In en, this message translates to:
  /// **'Spend your points'**
  String get home_employee_quick_rewards_subtitle;

  /// Achievements section title
  ///
  /// In en, this message translates to:
  /// **'Recent achievements & badges'**
  String get home_employee_achievements_title;

  /// Guest home title
  ///
  /// In en, this message translates to:
  /// **'Home - Guest'**
  String get home_guest_title;

  /// Profile page app bar title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_app_bar_title;

  /// Profile page subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your profile and settings'**
  String get profile_app_bar_subtitle;

  /// Section: Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_section_profile_title;

  /// Tile: Personal info title
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get profile_section_profile_personal_info_title;

  /// Tile: Personal info subtitle
  ///
  /// In en, this message translates to:
  /// **'View and update your personal data'**
  String get profile_section_profile_personal_info_subtitle;

  /// Section: AI
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get profile_section_ai_title;

  /// Tile: AI assistant title
  ///
  /// In en, this message translates to:
  /// **'AI assistant'**
  String get profile_section_ai_assistant_title;

  /// Tile: AI assistant subtitle
  ///
  /// In en, this message translates to:
  /// **'A personal assistant to boost your performance'**
  String get profile_section_ai_assistant_subtitle;

  /// Tile: Digital twin title
  ///
  /// In en, this message translates to:
  /// **'Digital twin'**
  String get profile_section_ai_digital_twin_title;

  /// Tile: Digital twin subtitle
  ///
  /// In en, this message translates to:
  /// **'A digital model to analyze your performance'**
  String get profile_section_ai_digital_twin_subtitle;

  /// Tile: Smart analytics title
  ///
  /// In en, this message translates to:
  /// **'Smart analytics'**
  String get profile_section_ai_analytics_title;

  /// Tile: Smart analytics subtitle
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics powered by AI'**
  String get profile_section_ai_analytics_subtitle;

  /// Section: Learning
  ///
  /// In en, this message translates to:
  /// **'Development & learning'**
  String get profile_section_learning_title;

  /// Tile: Smart training title
  ///
  /// In en, this message translates to:
  /// **'Smart training'**
  String get profile_section_learning_training_title;

  /// Tile: Smart training subtitle
  ///
  /// In en, this message translates to:
  /// **'Personalized, intelligent programs'**
  String get profile_section_learning_training_subtitle;

  /// Tile: Perf360 title
  ///
  /// In en, this message translates to:
  /// **'360° performance'**
  String get profile_section_learning_perf360_title;

  /// Tile: Perf360 subtitle
  ///
  /// In en, this message translates to:
  /// **'Comprehensive evaluation from all angles'**
  String get profile_section_learning_perf360_subtitle;

  /// Tile: Achievements title
  ///
  /// In en, this message translates to:
  /// **'Achievements & badges'**
  String get profile_section_learning_achievements_title;

  /// Tile: Achievements subtitle
  ///
  /// In en, this message translates to:
  /// **'All your achievements and badges'**
  String get profile_section_learning_achievements_subtitle;

  /// Section: Finance
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get profile_section_financial_title;

  /// Tile: Payroll deductions title
  ///
  /// In en, this message translates to:
  /// **'Payroll deductions & reasons'**
  String get profile_section_financial_payroll_deductions_title;

  /// Tile: Payroll deductions subtitle
  ///
  /// In en, this message translates to:
  /// **'View your payroll deductions and details'**
  String get profile_section_financial_payroll_deductions_subtitle;

  /// Section: Notifications
  ///
  /// In en, this message translates to:
  /// **'Communication & notifications'**
  String get profile_section_notifications_title;

  /// Tile: Email notifications title
  ///
  /// In en, this message translates to:
  /// **'Email notifications'**
  String get profile_section_notifications_email_title;

  /// Tile: Email notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage and follow email with reply capability'**
  String get profile_section_notifications_email_subtitle;

  /// Tile: Smart notifications title
  ///
  /// In en, this message translates to:
  /// **'Smart notifications'**
  String get profile_section_notifications_smart_title;

  /// Tile: Smart notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage customized notification settings'**
  String get profile_section_notifications_smart_subtitle;

  /// Section: Settings
  ///
  /// In en, this message translates to:
  /// **'Settings & preferences'**
  String get profile_section_settings_title;

  /// Tile: General settings title
  ///
  /// In en, this message translates to:
  /// **'General settings'**
  String get profile_section_settings_general_title;

  /// Tile: General settings subtitle
  ///
  /// In en, this message translates to:
  /// **'App settings and your preferences'**
  String get profile_section_settings_general_subtitle;

  /// Logout tile label
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profile_logout_label;

  /// Personal info app bar title
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get profile_personal_info_app_bar_title;

  /// Floating action: edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profile_personal_info_fab_edit;

  /// Floating action: save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profile_personal_info_fab_save;

  /// Chip label showing level
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String profile_personal_info_badge_level(int level);

  /// Section: Basic information
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get profile_personal_info_section_basic_title;

  /// Label: full name
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profile_personal_info_label_full_name;

  /// Label: employee number
  ///
  /// In en, this message translates to:
  /// **'Employee number'**
  String get profile_personal_info_label_employee_no;

  /// Label: email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profile_personal_info_label_email;

  /// Label: phone number
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profile_personal_info_label_phone;

  /// Label: join date
  ///
  /// In en, this message translates to:
  /// **'Join date'**
  String get profile_personal_info_label_join_date;

  /// Section: Work
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get profile_personal_info_section_work_title;

  /// Label: job role
  ///
  /// In en, this message translates to:
  /// **'Job role'**
  String get profile_personal_info_label_role;

  /// Label: department
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get profile_personal_info_label_dept;

  /// Label: direct manager
  ///
  /// In en, this message translates to:
  /// **'Direct manager'**
  String get profile_personal_info_label_manager;

  /// Label: level
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get profile_personal_info_label_level;

  /// Section: Address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profile_personal_info_section_address_title;

  /// Label: country
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profile_personal_info_label_country;

  /// Label: city
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profile_personal_info_label_city;

  /// Label: detailed address
  ///
  /// In en, this message translates to:
  /// **'Detailed address'**
  String get profile_personal_info_label_address;

  /// Header: department and tenure
  ///
  /// In en, this message translates to:
  /// **'{dept} • {years} years'**
  String profile_header_dept_and_tenure(Object dept, Object years);

  /// Performance card title
  ///
  /// In en, this message translates to:
  /// **'Performance overview'**
  String get profile_perf_overview_title;

  /// Metric: productivity
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get profile_perf_productivity;

  /// Metric: quality
  ///
  /// In en, this message translates to:
  /// **'Work quality'**
  String get profile_perf_quality;

  /// Metric: attendance
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get profile_perf_attendance;

  /// Metric: teamwork
  ///
  /// In en, this message translates to:
  /// **'Teamwork'**
  String get profile_perf_teamwork;

  /// No description provided for @currency_sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currency_sar;

  /// App bar title for payroll deductions screen
  ///
  /// In en, this message translates to:
  /// **'Payroll deductions & reasons'**
  String get profile_payroll_app_bar_title;

  /// Top action: export payroll slip
  ///
  /// In en, this message translates to:
  /// **'Export payroll slip'**
  String get profile_payroll_top_export;

  /// Dialog title: pick month and year
  ///
  /// In en, this message translates to:
  /// **'Pick month and year'**
  String get profile_payroll_dialog_pick_month_title;

  /// Label for month field
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get profile_payroll_field_month_label;

  /// Label for year field
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get profile_payroll_field_year_label;

  /// Tab: salary summary
  ///
  /// In en, this message translates to:
  /// **'Salary summary'**
  String get profile_payroll_tab_summary;

  /// Tab: deductions details
  ///
  /// In en, this message translates to:
  /// **'Deductions details'**
  String get profile_payroll_tab_details;

  /// Tab: history
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get profile_payroll_tab_history;

  /// Button: salary calculator
  ///
  /// In en, this message translates to:
  /// **'Salary calculator'**
  String get profile_payroll_button_salary_calculator;

  /// Button: request detailed salary slip
  ///
  /// In en, this message translates to:
  /// **'Request detailed slip'**
  String get profile_payroll_button_request_detailed_slip;

  /// Toast: payroll exported as PDF
  ///
  /// In en, this message translates to:
  /// **'Payroll slip exported (PDF)'**
  String get profile_payroll_toast_exported_pdf;

  /// Toast: salary calculator coming soon
  ///
  /// In en, this message translates to:
  /// **'Coming soon: salary calculator'**
  String get profile_payroll_toast_salary_calculator_soon;

  /// Toast: detailed slip requested
  ///
  /// In en, this message translates to:
  /// **'Detailed salary slip requested'**
  String get profile_payroll_toast_detailed_slip_requested;

  /// Empty state title: details
  ///
  /// In en, this message translates to:
  /// **'No deductions for this month'**
  String get profile_payroll_empty_details_title;

  /// Empty state subtitle: details
  ///
  /// In en, this message translates to:
  /// **'All deductions will appear here when available'**
  String get profile_payroll_empty_details_subtitle;

  /// Empty state: history
  ///
  /// In en, this message translates to:
  /// **'No historical records for this month'**
  String get profile_payroll_empty_history;

  /// Details summary title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get profile_payroll_summary_title;

  /// Summary row: total deductions
  ///
  /// In en, this message translates to:
  /// **'Total deductions'**
  String get profile_payroll_summary_total_deductions;

  /// Summary row: total after deduction
  ///
  /// In en, this message translates to:
  /// **'Total after deduction'**
  String get profile_payroll_summary_total_after_deduction;

  /// Summary card: gross salary label
  ///
  /// In en, this message translates to:
  /// **'Gross salary'**
  String get profile_payroll_card_gross_salary;

  /// Summary card: total deductions label
  ///
  /// In en, this message translates to:
  /// **'Total deductions'**
  String get profile_payroll_card_total_deductions;

  /// Summary card: allowances and bonuses label
  ///
  /// In en, this message translates to:
  /// **'Allowances & bonuses'**
  String get profile_payroll_card_allowances;

  /// Summary card: net salary label
  ///
  /// In en, this message translates to:
  /// **'Net salary'**
  String get profile_payroll_card_net_salary;

  /// Breakdown card title
  ///
  /// In en, this message translates to:
  /// **'Salary breakdown'**
  String get profile_payroll_breakdown_title;

  /// Breakdown row: basic salary
  ///
  /// In en, this message translates to:
  /// **'Basic salary'**
  String get profile_payroll_breakdown_basic_salary;

  /// Breakdown row: allowances
  ///
  /// In en, this message translates to:
  /// **'Allowances & bonuses'**
  String get profile_payroll_breakdown_allowances;

  /// Breakdown row: net salary
  ///
  /// In en, this message translates to:
  /// **'Net salary'**
  String get profile_payroll_breakdown_net_salary;

  /// Card title: mandatory deductions
  ///
  /// In en, this message translates to:
  /// **'Mandatory deductions'**
  String get profile_payroll_mandatory_deductions_title;

  /// Card title: optional deductions
  ///
  /// In en, this message translates to:
  /// **'Optional deductions'**
  String get profile_payroll_optional_deductions_title;

  /// Card title: penalties deductions
  ///
  /// In en, this message translates to:
  /// **'Penalties deductions'**
  String get profile_payroll_penalties_title;

  /// History item action: view details
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get profile_payroll_history_view_details;

  /// History label: gross salary
  ///
  /// In en, this message translates to:
  /// **'Gross salary'**
  String get profile_payroll_history_gross_salary;

  /// History label: deductions
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get profile_payroll_history_deductions;

  /// History label: net salary
  ///
  /// In en, this message translates to:
  /// **'Net salary'**
  String get profile_payroll_history_net_salary;

  /// History label: net ratio
  ///
  /// In en, this message translates to:
  /// **'Net salary ratio: %{ratio}'**
  String profile_payroll_history_net_ratio(num ratio);

  /// L4L: page title
  ///
  /// In en, this message translates to:
  /// **'Like for Like (KPIs & Visuals)'**
  String get l4l_title;

  /// L4L period: day
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get l4l_period_day;

  /// L4L period: week
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get l4l_period_week;

  /// L4L period: month
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get l4l_period_month;

  /// L4L period: year
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get l4l_period_year;

  /// L4L compare: day vs last year
  ///
  /// In en, this message translates to:
  /// **'Today vs same weekday last year'**
  String get l4l_compare_day_vs_ly;

  /// L4L compare: week vs previous
  ///
  /// In en, this message translates to:
  /// **'Week vs previous week'**
  String get l4l_compare_week_vs_prev;

  /// L4L compare: month vs previous
  ///
  /// In en, this message translates to:
  /// **'Month vs previous month'**
  String get l4l_compare_month_vs_prev;

  /// L4L compare: year vs last year
  ///
  /// In en, this message translates to:
  /// **'Year vs last year'**
  String get l4l_compare_year_vs_ly;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
