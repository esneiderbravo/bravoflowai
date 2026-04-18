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
  String get profile_title => 'Profile';

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
  String get retry_button => 'Retry';

  @override
  String get full_name_label => 'Full name';

  @override
  String get email_label => 'Email';

  @override
  String get save_changes_button => 'Save changes';

  @override
  String get close_session_action => 'Close session';

  @override
  String get close_session_signing_out => 'Closing session...';

  @override
  String get close_session_confirm_title => 'Close session?';

  @override
  String get close_session_confirm_body => 'You will need to sign in again to continue.';

  @override
  String get close_session_confirm_cancel => 'Cancel';

  @override
  String get close_session_confirm_confirm => 'Close session';

  @override
  String get close_session_failed => 'Could not close the session. Please try again.';

  @override
  String get photo_permission_required => 'Photo permission is required. Enable it in Settings.';

  @override
  String get profile_saved_successfully => 'Profile saved successfully.';

  @override
  String get language_spanish => 'Español';

  @override
  String get language_english => 'English';

  @override
  String get dashboard_overview => 'Your Financial Overview';

  @override
  String get total_balance => 'Total Balance';

  @override
  String monthly_change(Object change) {
    return '$change% this month';
  }

  @override
  String get add_transaction => 'Add\nTransaction';

  @override
  String get tab_transactions => 'Transactions';

  @override
  String get greeting_morning => 'Good morning';

  @override
  String get greeting_afternoon => 'Good afternoon';

  @override
  String get greeting_evening => 'Good evening';

  @override
  String get more_accounts => 'Accounts';

  @override
  String get accounts_title => 'Accounts';

  @override
  String get add_account => 'Add account';

  @override
  String get edit_account => 'Edit account';

  @override
  String get delete_account => 'Delete account';

  @override
  String get delete_account_confirm => 'Delete this account?';

  @override
  String get delete_account_has_transactions =>
      'Cannot delete: account has transactions or transfers.';

  @override
  String get add_transfer => 'Add transfer';

  @override
  String get account_type_checking => 'Checking';

  @override
  String get account_type_savings => 'Savings';

  @override
  String get account_type_cash => 'Cash';

  @override
  String get account_type_investment => 'Investment';

  @override
  String get account_type_other => 'Other';

  @override
  String get initial_balance => 'Initial balance';

  @override
  String get account_balance => 'Balance';

  @override
  String get transfer_from => 'From account';

  @override
  String get transfer_to => 'To account';

  @override
  String get transfer_note => 'Note (optional)';

  @override
  String get transfer_amount => 'Amount';

  @override
  String get save_account_button => 'Save account';

  @override
  String get save_transfer_button => 'Save transfer';

  @override
  String get account_type_label => 'Account type';

  @override
  String get account_name_label => 'Account name';

  @override
  String get account_name_required => 'Enter an account name';

  @override
  String get transfer_amount_required => 'Enter an amount';

  @override
  String get transfer_amount_invalid => 'Invalid amount';

  @override
  String get transfer_same_account => 'Source and destination must be different';

  @override
  String get transfer_insufficient_balance => 'Amount exceeds available balance';
}
