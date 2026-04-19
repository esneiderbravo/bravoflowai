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
  String get profile_title => 'Perfil';

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
  String get transaction_category_label => 'Categoría';

  @override
  String get transaction_category_required => 'Selecciona una categoría';

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
  String get dashboard_overview => 'Tu resumen financiero';

  @override
  String get total_balance => 'Balance total';

  @override
  String monthly_change(Object change) {
    return '$change% este mes';
  }

  @override
  String get add_transaction => 'Agregar\nTransaccion';

  @override
  String get tab_transactions => 'Movimientos';

  @override
  String get greeting_morning => 'Buenos dias';

  @override
  String get greeting_afternoon => 'Buenas tardes';

  @override
  String get greeting_evening => 'Buenas noches';

  @override
  String get profile_section_personal => 'Personal';

  @override
  String get more_preferences => 'Preferencias';

  @override
  String get more_accounts => 'Cuentas';

  @override
  String get more_categories => 'Categorías';

  @override
  String get accounts_title => 'Cuentas';

  @override
  String get add_account => 'Agregar cuenta';

  @override
  String get edit_account => 'Editar cuenta';

  @override
  String get delete_account => 'Eliminar cuenta';

  @override
  String get delete_account_confirm => '¿Eliminar esta cuenta?';

  @override
  String get delete_account_has_transactions =>
      'No se puede eliminar: la cuenta tiene transacciones o transferencias.';

  @override
  String get add_transfer => 'Agregar transferencia';

  @override
  String get account_type_checking => 'Corriente';

  @override
  String get account_type_savings => 'Ahorros';

  @override
  String get account_type_cash => 'Efectivo';

  @override
  String get account_type_investment => 'Inversión';

  @override
  String get account_type_other => 'Otra';

  @override
  String get initial_balance => 'Balance inicial';

  @override
  String get account_balance => 'Balance';

  @override
  String get transfer_from => 'Cuenta origen';

  @override
  String get transfer_to => 'Cuenta destino';

  @override
  String get transfer_note => 'Nota (opcional)';

  @override
  String get transfer_amount => 'Monto';

  @override
  String get save_account_button => 'Guardar cuenta';

  @override
  String get save_transfer_button => 'Guardar transferencia';

  @override
  String get account_type_label => 'Tipo de cuenta';

  @override
  String get account_name_label => 'Nombre de la cuenta';

  @override
  String get account_name_required => 'Ingresa un nombre para la cuenta';

  @override
  String get transfer_amount_required => 'Ingresa un monto';

  @override
  String get transfer_amount_invalid => 'Monto inválido';

  @override
  String get transfer_same_account => 'El origen y destino deben ser diferentes';

  @override
  String get transfer_insufficient_balance => 'El monto supera el balance disponible';

  @override
  String get tab_home => 'Inicio';

  @override
  String get tab_flow => 'Flujo';

  @override
  String get tab_more => 'Más';

  @override
  String get sign_in_title => 'Bienvenido de vuelta';

  @override
  String get sign_in_subtitle => 'Inicia sesión en tu cuenta de BravoFlow AI.';

  @override
  String get sign_in_button => 'Iniciar sesión';

  @override
  String get sign_up_link => '¿No tienes cuenta? Regístrate';

  @override
  String get sign_up_title => 'Crear cuenta';

  @override
  String get sign_up_subtitle => 'Comienza tu viaje financiero con IA.';

  @override
  String get sign_up_button => 'Registrarse';

  @override
  String get sign_in_link => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get password_label => 'Contraseña';

  @override
  String get password_min_length => 'Mínimo 6 caracteres';

  @override
  String get email_invalid => 'Ingresa un correo válido';

  @override
  String get enter_your_name => 'Ingresa tu nombre';

  @override
  String get forgot_password => '¿Olvidaste tu contraseña?';

  @override
  String get coming_soon => 'Próximamente';

  @override
  String get account_created_confirm => '¡Cuenta creada! Revisa tu correo para confirmar.';

  @override
  String get financial_overview_total_balance => 'Balance Total';

  @override
  String get financial_overview_across_accounts => 'En todas las cuentas';

  @override
  String get financial_overview_this_month => 'Este Mes';

  @override
  String get financial_overview_income => 'Ingresos';

  @override
  String get financial_overview_expenses => 'Gastos';

  @override
  String get financial_overview_net_balance => 'Balance Neto';

  @override
  String get financial_overview_top_spending => 'Gastos Principales';

  @override
  String get financial_overview_no_expenses => 'Sin gastos registrados este mes';

  @override
  String get flow_tab_all => 'Todo';

  @override
  String get flow_tab_income => 'Ingresos';

  @override
  String get flow_tab_expenses => 'Gastos';

  @override
  String get flow_today => 'Hoy';

  @override
  String get flow_yesterday => 'Ayer';

  @override
  String get flow_empty_all => 'Aún no hay transacciones';

  @override
  String get flow_empty_income => 'Aún no hay ingresos registrados';

  @override
  String get flow_empty_expenses => 'Aún no hay gastos registrados';

  @override
  String get flow_monthly_income => 'Ingresos';

  @override
  String get flow_monthly_expenses => 'Gastos';

  @override
  String get flow_net_balance => 'Neto';

  @override
  String get quick_add_title => 'Agregar rápido';

  @override
  String get quick_add_select_account => 'Seleccionar cuenta';

  @override
  String get quick_add_account_required => 'Por favor selecciona una cuenta';

  @override
  String get more_section_finance => 'Finanzas';

  @override
  String get more_section_organisation => 'Organización';

  @override
  String get categories_title => 'Categorías';

  @override
  String get categories_section_default => 'Predeterminadas';

  @override
  String get categories_section_custom => 'Personalizadas';

  @override
  String get categories_empty_custom =>
      'Aún no hay categorías personalizadas. Toca + para crear una.';

  @override
  String get categories_delete_title => '¿Eliminar categoría?';

  @override
  String categories_delete_body(String name) {
    return '¿Eliminar \"$name\"? Las transacciones vinculadas perderán su categoría.';
  }

  @override
  String get categories_delete_confirm => 'Eliminar';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get add_category_title => 'Agregar categoría';

  @override
  String get edit_category_title => 'Editar categoría';

  @override
  String get category_name_label => 'Nombre de categoría';

  @override
  String get category_name_required => 'Ingresa un nombre de categoría';

  @override
  String get category_icon_section => 'Ícono';

  @override
  String get category_icon_hint => 'Toca para elegir un ícono';

  @override
  String get category_colour_section => 'Color';

  @override
  String get category_colour_custom_label => 'Color personalizado (opcional)';

  @override
  String get category_colour_hint => '#3A86FF';

  @override
  String get category_colour_invalid => 'Ingresa un color hex válido (ej. #3A86FF)';

  @override
  String get add_category_button => 'Agregar categoría';

  @override
  String get category_choose_icon_title => 'Elegir ícono';

  @override
  String get category_icon_search_hint => 'Buscar íconos…';
}
