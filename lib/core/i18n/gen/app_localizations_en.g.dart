// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'BravoFlow AI';

  @override
  String get welcome_message => 'Welcome';

  @override
  String get profile_title => 'Profile';

  @override
  String get save_button => 'Save';

  @override
  String get language_label => 'Language';

  @override
  String get retry_button => 'Retry';

  @override
  String get full_name_label => 'Full name';

  @override
  String get email_label => 'Email';

  @override
  String get save_changes_button => 'Save changes';

  @override
  String get photo_permission_required => 'Photo permission is required. Enable it in Settings.';

  @override
  String get profile_saved_successfully => 'Profile saved successfully.';

  @override
  String get language_spanish => 'Español';

  @override
  String get language_english => 'English';

  @override
  String get language_updated_successfully => 'Language updated.';

  @override
  String get language_update_failed => 'Could not update language preference.';

  @override
  String get dashboard_overview => 'Your Financial Overview';

  @override
  String get ai_insights => 'AI Insights';

  @override
  String get beta_label => 'BETA';

  @override
  String get quick_actions => 'Quick Actions';

  @override
  String get total_balance => 'Total Balance';

  @override
  String monthly_change(Object change) {
    return '$change% this month';
  }

  @override
  String get add_transaction => 'Add\nTransaction';

  @override
  String get budget => 'Budget';

  @override
  String get reports => 'Reports';

  @override
  String get ai_chat => 'AI Chat';

  @override
  String get tab_home => 'Home';

  @override
  String get tab_transactions => 'Transactions';

  @override
  String get tab_ai => 'AI';

  @override
  String get tab_budget => 'Budget';

  @override
  String get greeting_morning => 'Good morning';

  @override
  String get greeting_afternoon => 'Good afternoon';

  @override
  String get greeting_evening => 'Good evening';

  @override
  String greeting_with_name(Object greeting, Object name) {
    return '$greeting, $name 👋';
  }
}
