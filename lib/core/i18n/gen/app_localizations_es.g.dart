// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'BravoFlow AI';

  @override
  String get welcome_message => 'Bienvenido';

  @override
  String get profile_title => 'Perfil';

  @override
  String get save_button => 'Guardar';

  @override
  String get language_label => 'Idioma';

  @override
  String get theme_label => 'Tema';

  @override
  String get theme_system => 'Sistema';

  @override
  String get theme_dark => 'Oscuro';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_updated_successfully => 'Tema actualizado.';

  @override
  String get theme_update_failed => 'No se pudo actualizar la preferencia de tema.';

  @override
  String get transactions_empty_title => 'Aun no hay transacciones';

  @override
  String get transactions_empty_message => 'Toca + para agregar la primera.';

  @override
  String get add_transaction_title => 'Agregar transaccion';

  @override
  String get transaction_type_expense => 'Gasto';

  @override
  String get transaction_type_income => 'Ingreso';

  @override
  String get transaction_amount_label => 'Monto';

  @override
  String get transaction_amount_required => 'Ingresa un monto';

  @override
  String get transaction_amount_invalid => 'Numero invalido';

  @override
  String get transaction_description_label => 'Descripcion';

  @override
  String get transaction_description_required => 'Ingresa una descripcion';

  @override
  String get save_transaction_button => 'Guardar transaccion';

  @override
  String get budget_empty_title => 'Aun no hay presupuestos';

  @override
  String get budget_empty_message => 'El seguimiento de presupuesto estara disponible pronto.';

  @override
  String get retry_button => 'Reintentar';

  @override
  String get full_name_label => 'Nombre completo';

  @override
  String get email_label => 'Correo';

  @override
  String get save_changes_button => 'Guardar cambios';

  @override
  String get close_session_action => 'Cerrar sesion';

  @override
  String get close_session_signing_out => 'Cerrando sesion...';

  @override
  String get close_session_confirm_title => 'Cerrar sesion?';

  @override
  String get close_session_confirm_body => 'Tendras que iniciar sesion nuevamente para continuar.';

  @override
  String get close_session_confirm_cancel => 'Cancelar';

  @override
  String get close_session_confirm_confirm => 'Cerrar sesion';

  @override
  String get close_session_failed => 'No se pudo cerrar la sesion. Intentalo de nuevo.';

  @override
  String get photo_permission_required =>
      'Se requiere permiso para fotos. Activalo en Configuracion.';

  @override
  String get profile_saved_successfully => 'Perfil guardado correctamente.';

  @override
  String get language_spanish => 'Español';

  @override
  String get language_english => 'English';

  @override
  String get language_updated_successfully => 'Idioma actualizado.';

  @override
  String get language_update_failed => 'No se pudo actualizar la preferencia de idioma.';

  @override
  String get dashboard_overview => 'Tu resumen financiero';

  @override
  String get ai_insights => 'Insights de IA';

  @override
  String get beta_label => 'BETA';

  @override
  String get quick_actions => 'Acciones rapidas';

  @override
  String get total_balance => 'Balance total';

  @override
  String monthly_change(Object change) {
    return '$change% este mes';
  }

  @override
  String get add_transaction => 'Agregar\nTransaccion';

  @override
  String get budget => 'Presupuesto';

  @override
  String get reports => 'Reportes';

  @override
  String get ai_chat => 'Chat IA';

  @override
  String get tab_home => 'Inicio';

  @override
  String get tab_transactions => 'Movimientos';

  @override
  String get tab_ai => 'IA';

  @override
  String get tab_budget => 'Presupuesto';

  @override
  String get greeting_morning => 'Buenos dias';

  @override
  String get greeting_afternoon => 'Buenas tardes';

  @override
  String get greeting_evening => 'Buenas noches';

  @override
  String greeting_with_name(Object greeting, Object name) {
    return '$greeting, $name 👋';
  }
}
