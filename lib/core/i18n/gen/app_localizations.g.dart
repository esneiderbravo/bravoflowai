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

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome_message;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @save_button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_button;

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

  /// No description provided for @theme_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Theme updated.'**
  String get theme_updated_successfully;

  /// No description provided for @theme_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not update theme preference.'**
  String get theme_update_failed;

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

  /// No description provided for @budget_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get budget_empty_title;

  /// No description provided for @budget_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Budget tracking is coming soon.'**
  String get budget_empty_message;

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

  /// No description provided for @language_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Language updated.'**
  String get language_updated_successfully;

  /// No description provided for @language_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not update language preference.'**
  String get language_update_failed;

  /// No description provided for @dashboard_overview.
  ///
  /// In en, this message translates to:
  /// **'Your Financial Overview'**
  String get dashboard_overview;

  /// No description provided for @ai_insights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get ai_insights;

  /// No description provided for @beta_label.
  ///
  /// In en, this message translates to:
  /// **'BETA'**
  String get beta_label;

  /// No description provided for @quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

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

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @ai_chat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get ai_chat;

  /// No description provided for @tab_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tab_home;

  /// No description provided for @tab_transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get tab_transactions;

  /// No description provided for @tab_ai.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get tab_ai;

  /// No description provided for @tab_budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get tab_budget;

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

  /// No description provided for @greeting_with_name.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name} 👋'**
  String greeting_with_name(Object greeting, Object name);
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
