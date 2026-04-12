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
  String get theme_label => 'Theme';

  @override
  String get theme_system => 'System default';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_updated_successfully => 'Theme updated.';

  @override
  String get theme_update_failed => 'Could not update theme preference.';

  @override
  String get transactions_empty_title => 'No transactions yet';

  @override
  String get transactions_empty_message => 'Tap + to add your first one.';

  @override
  String get add_transaction_title => 'Add transaction';

  @override
  String get transaction_type_expense => 'Expense';

  @override
  String get transaction_type_income => 'Income';

  @override
  String get transaction_amount_label => 'Amount';

  @override
  String get transaction_amount_required => 'Enter an amount';

  @override
  String get transaction_amount_invalid => 'Invalid number';

  @override
  String get transaction_description_label => 'Description';

  @override
  String get transaction_description_required => 'Enter a description';

  @override
  String get save_transaction_button => 'Save transaction';

  @override
  String get budget_empty_title => 'No budgets yet';

  @override
  String get budget_empty_message => 'Budget tracking is coming soon.';

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
