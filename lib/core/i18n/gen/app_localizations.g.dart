import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.g.dart';
import 'app_localizations_es.g.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.g.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es')];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'BravoFlow AI'**
  String get app_title;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @language_label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_label;

  /// No description provided for @theme_label.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme_label;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get theme_system;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @transactions_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get transactions_empty_title;

  /// No description provided for @transactions_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first one.'**
  String get transactions_empty_message;

  /// No description provided for @add_transaction_title.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get add_transaction_title;

  /// No description provided for @transaction_type_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transaction_type_expense;

  /// No description provided for @transaction_type_income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transaction_type_income;

  /// No description provided for @transaction_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transaction_amount_label;

  /// No description provided for @transaction_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get transaction_amount_required;

  /// No description provided for @transaction_amount_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get transaction_amount_invalid;

  /// No description provided for @transaction_description_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get transaction_description_label;

  /// No description provided for @transaction_description_required.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get transaction_description_required;

  /// No description provided for @save_transaction_button.
  ///
  /// In en, this message translates to:
  /// **'Save transaction'**
  String get save_transaction_button;

  /// No description provided for @retry_button.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry_button;

  /// No description provided for @full_name_label.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name_label;

  /// No description provided for @email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_label;

  /// No description provided for @save_changes_button.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes_button;

  /// No description provided for @close_session_action.
  ///
  /// In en, this message translates to:
  /// **'Close session'**
  String get close_session_action;

  /// No description provided for @close_session_signing_out.
  ///
  /// In en, this message translates to:
  /// **'Closing session...'**
  String get close_session_signing_out;

  /// No description provided for @close_session_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Close session?'**
  String get close_session_confirm_title;

  /// No description provided for @close_session_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to continue.'**
  String get close_session_confirm_body;

  /// No description provided for @close_session_confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get close_session_confirm_cancel;

  /// No description provided for @close_session_confirm_confirm.
  ///
  /// In en, this message translates to:
  /// **'Close session'**
  String get close_session_confirm_confirm;

  /// No description provided for @close_session_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not close the session. Please try again.'**
  String get close_session_failed;

  /// No description provided for @photo_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Photo permission is required. Enable it in Settings.'**
  String get photo_permission_required;

  /// No description provided for @profile_saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully.'**
  String get profile_saved_successfully;

  /// No description provided for @language_spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get language_spanish;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @dashboard_overview.
  ///
  /// In en, this message translates to:
  /// **'Your Financial Overview'**
  String get dashboard_overview;

  /// No description provided for @total_balance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get total_balance;

  /// No description provided for @monthly_change.
  ///
  /// In en, this message translates to:
  /// **'{change}% this month'**
  String monthly_change(Object change);

  /// No description provided for @add_transaction.
  ///
  /// In en, this message translates to:
  /// **'Add\nTransaction'**
  String get add_transaction;

  /// No description provided for @tab_transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get tab_transactions;

  /// No description provided for @greeting_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greeting_morning;

  /// No description provided for @greeting_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greeting_afternoon;

  /// No description provided for @greeting_evening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greeting_evening;

  /// No description provided for @profile_section_personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get profile_section_personal;

  /// No description provided for @more_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get more_preferences;

  /// No description provided for @more_accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get more_accounts;

  /// No description provided for @accounts_title.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts_title;

  /// No description provided for @add_account.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get add_account;

  /// No description provided for @edit_account.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get edit_account;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this account?'**
  String get delete_account_confirm;

  /// No description provided for @delete_account_has_transactions.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete: account has transactions or transfers.'**
  String get delete_account_has_transactions;

  /// No description provided for @add_transfer.
  ///
  /// In en, this message translates to:
  /// **'Add transfer'**
  String get add_transfer;

  /// No description provided for @account_type_checking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get account_type_checking;

  /// No description provided for @account_type_savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get account_type_savings;

  /// No description provided for @account_type_cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get account_type_cash;

  /// No description provided for @account_type_investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get account_type_investment;

  /// No description provided for @account_type_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get account_type_other;

  /// No description provided for @initial_balance.
  ///
  /// In en, this message translates to:
  /// **'Initial balance'**
  String get initial_balance;

  /// No description provided for @account_balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get account_balance;

  /// No description provided for @transfer_from.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get transfer_from;

  /// No description provided for @transfer_to.
  ///
  /// In en, this message translates to:
  /// **'To account'**
  String get transfer_to;

  /// No description provided for @transfer_note.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get transfer_note;

  /// No description provided for @transfer_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transfer_amount;

  /// No description provided for @save_account_button.
  ///
  /// In en, this message translates to:
  /// **'Save account'**
  String get save_account_button;

  /// No description provided for @save_transfer_button.
  ///
  /// In en, this message translates to:
  /// **'Save transfer'**
  String get save_transfer_button;

  /// No description provided for @account_type_label.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get account_type_label;

  /// No description provided for @account_name_label.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get account_name_label;

  /// No description provided for @account_name_required.
  ///
  /// In en, this message translates to:
  /// **'Enter an account name'**
  String get account_name_required;

  /// No description provided for @transfer_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get transfer_amount_required;

  /// No description provided for @transfer_amount_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get transfer_amount_invalid;

  /// No description provided for @transfer_same_account.
  ///
  /// In en, this message translates to:
  /// **'Source and destination must be different'**
  String get transfer_same_account;

  /// No description provided for @transfer_insufficient_balance.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds available balance'**
  String get transfer_insufficient_balance;

  /// No description provided for @tab_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tab_home;

  /// No description provided for @tab_flow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get tab_flow;

  /// No description provided for @tab_more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tab_more;

  /// No description provided for @sign_in_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get sign_in_title;

  /// No description provided for @sign_in_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your BravoFlow AI account.'**
  String get sign_in_subtitle;

  /// No description provided for @sign_in_button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in_button;

  /// No description provided for @sign_up_link.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get sign_up_link;

  /// No description provided for @sign_up_title.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get sign_up_title;

  /// No description provided for @sign_up_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your AI-powered financial journey.'**
  String get sign_up_subtitle;

  /// No description provided for @sign_up_button.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up_button;

  /// No description provided for @sign_in_link.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get sign_in_link;

  /// No description provided for @password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_label;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get password_min_length;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get email_invalid;

  /// No description provided for @enter_your_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enter_your_name;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get coming_soon;

  /// No description provided for @account_created_confirm.
  ///
  /// In en, this message translates to:
  /// **'Account created! Check your email to confirm.'**
  String get account_created_confirm;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
