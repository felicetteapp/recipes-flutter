// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(ingredientName) =>
      "¿Es \"${ingredientName}\" un ingrediente real que se puede usar en recetas?";

  static String m1(error) =>
      "Error al actualizar los detalles de la lista: ${error}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'ingrediente', other: 'ingredientes')}";

  static String m3(count) => "${count} seleccionado";

  static String m4(count) =>
      "${Intl.plural(count, one: 'lista', other: 'listas')}";

  static String m5(max) => "El nombre no puede exceder ${max} caracteres";

  static String m6(min) => "El nombre debe tener al menos ${min} caracteres";

  static String m7(ingredient) => "Cantidad para ${ingredient}";

  static String m8(count) =>
      "${Intl.plural(count, one: 'receta', other: 'recetas')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("Acerca de"),
    "actual_ingredient_content": MessageLookupByLibrary.simpleMessage(
      "¿Es este un ingrediente real que se puede usar en recetas?",
    ),
    "actual_ingredient_title": MessageLookupByLibrary.simpleMessage(
      "Ingrediente Real",
    ),
    "actual_ingredients": MessageLookupByLibrary.simpleMessage("Ingredientes"),
    "actual_ingredients_subtitle": MessageLookupByLibrary.simpleMessage(
      "Estos elementos se pueden usar en recetas y agregar a la lista de compras",
    ),
    "add_ingredient": MessageLookupByLibrary.simpleMessage(
      "Agregar ingrediente",
    ),
    "add_price": MessageLookupByLibrary.simpleMessage("Agregar Precio"),
    "add_recipe": MessageLookupByLibrary.simpleMessage("Agregar receta"),
    "all_checks_cleared": MessageLookupByLibrary.simpleMessage(
      "Se han desmarcado todos los elementos",
    ),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "¿Ya tienes una cuenta?",
    ),
    "application_description": MessageLookupByLibrary.simpleMessage(
      "Felicette Recetas es una aplicación de código abierto que te ayuda a gestionar tus recetas y listas de compras.",
    ),
    "application_name": MessageLookupByLibrary.simpleMessage(
      "Felicette Recetas",
    ),
    "available": MessageLookupByLibrary.simpleMessage(" disponible"),
    "budget": MessageLookupByLibrary.simpleMessage("Presupuesto"),
    "budget_must_be_positive": MessageLookupByLibrary.simpleMessage(
      "El presupuesto debe ser un número positivo",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "checkout_github": MessageLookupByLibrary.simpleMessage(
      "Visita el proyecto en GitHub: ",
    ),
    "choose_ingredients_text": MessageLookupByLibrary.simpleMessage(
      "Elige los ingredientes necesarios para la receta. Las cantidades se pueden ingresar abajo.",
    ),
    "clear_all_checks": MessageLookupByLibrary.simpleMessage("Desmarcar Todo"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
    "confirm_actual_ingredient": MessageLookupByLibrary.simpleMessage(
      "Confirmar Ingrediente Real",
    ),
    "confirm_actual_ingredient_description": m0,
    "confirm_deletion": MessageLookupByLibrary.simpleMessage(
      "Confirmar Eliminación",
    ),
    "confirm_deletion_message": MessageLookupByLibrary.simpleMessage(
      "¿Estás seguro de que quieres eliminar este ingrediente?",
    ),
    "confirm_password": MessageLookupByLibrary.simpleMessage(
      "Confirmar Contraseña",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Conectado"),
    "create": MessageLookupByLibrary.simpleMessage("Crear"),
    "create_account": MessageLookupByLibrary.simpleMessage("Crear Cuenta"),
    "create_account_error": MessageLookupByLibrary.simpleMessage(
      "Error al crear cuenta",
    ),
    "create_account_success": MessageLookupByLibrary.simpleMessage(
      "¡Cuenta creada exitosamente!",
    ),
    "create_group": MessageLookupByLibrary.simpleMessage("Crear Grupo"),
    "create_recipe": MessageLookupByLibrary.simpleMessage("Crear Receta"),
    "currency_ars": MessageLookupByLibrary.simpleMessage("Peso Argentino"),
    "currency_brl": MessageLookupByLibrary.simpleMessage("Real Brasileño"),
    "currency_cny": MessageLookupByLibrary.simpleMessage("Yuan Chino"),
    "currency_eur": MessageLookupByLibrary.simpleMessage("Euro"),
    "currency_gbp": MessageLookupByLibrary.simpleMessage("Libra Esterlina"),
    "currency_jpy": MessageLookupByLibrary.simpleMessage("Yen Japonés"),
    "currency_usd": MessageLookupByLibrary.simpleMessage(
      "Dólar Estadounidense",
    ),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Modo Oscuro"),
    "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "delete_group": MessageLookupByLibrary.simpleMessage("Eliminar Grupo"),
    "delete_group_message": MessageLookupByLibrary.simpleMessage(
      "¿Estás seguro de que quieres eliminar este grupo? Esta acción no se puede deshacer.",
    ),
    "developed_by": MessageLookupByLibrary.simpleMessage("Por felicette.dev"),
    "developed_in": MessageLookupByLibrary.simpleMessage(
      "en Curitiba, Brasil.",
    ),
    "developed_with_love": MessageLookupByLibrary.simpleMessage(
      "Desarrollado con",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Listo"),
    "edit": MessageLookupByLibrary.simpleMessage("Editar"),
    "edit_group": MessageLookupByLibrary.simpleMessage("Editar Grupo"),
    "edit_ingredient": MessageLookupByLibrary.simpleMessage(
      "Editar Ingrediente",
    ),
    "edit_list": MessageLookupByLibrary.simpleMessage("Editar Lista"),
    "edit_recipe": MessageLookupByLibrary.simpleMessage("Editar Receta"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_is_required_error": MessageLookupByLibrary.simpleMessage(
      "El correo es obligatorio",
    ),
    "enter_quantity": MessageLookupByLibrary.simpleMessage("Ingresar Cantidad"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "failed_to_update_list_details": m1,
    "forgot_password": MessageLookupByLibrary.simpleMessage(
      "¿Olvidaste tu contraseña?",
    ),
    "group_creation_limit_reached": MessageLookupByLibrary.simpleMessage(
      "Has alcanzado el número máximo de grupos permitidos.",
    ),
    "group_deleted": MessageLookupByLibrary.simpleMessage(
      "Grupo eliminado exitosamente",
    ),
    "group_name": MessageLookupByLibrary.simpleMessage("Nombre del Grupo"),
    "group_name_updated": MessageLookupByLibrary.simpleMessage(
      "Grupo actualizado exitosamente",
    ),
    "ingredient": m2,
    "ingredient_created_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingrediente creado exitosamente",
    ),
    "ingredient_deleted_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingrediente eliminado exitosamente",
    ),
    "ingredient_name": MessageLookupByLibrary.simpleMessage(
      "Nombre del Ingrediente",
    ),
    "ingredient_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingrediente actualizado exitosamente",
    ),
    "input_required_error": MessageLookupByLibrary.simpleMessage(
      "Este campo es obligatorio",
    ),
    "invalid_email_error": MessageLookupByLibrary.simpleMessage(
      "Por favor ingrese una dirección de correo válida",
    ),
    "is_actual_ingredient": MessageLookupByLibrary.simpleMessage(
      "Es Ingrediente Real",
    ),
    "items_selected": m3,
    "language": MessageLookupByLibrary.simpleMessage("Idioma"),
    "light_mode": MessageLookupByLibrary.simpleMessage("Modo Claro"),
    "list": m4,
    "list_details_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "Detalles de la lista actualizados exitosamente",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Cargando"),
    "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "login_error": MessageLookupByLibrary.simpleMessage(
      "Error de inicio de sesión",
    ),
    "login_without_password": MessageLookupByLibrary.simpleMessage(
      "Iniciar sesión sin contraseña",
    ),
    "login_without_password_success_message":
        MessageLookupByLibrary.simpleMessage(
          "¡Enlace de inicio de sesión enviado! Por favor revisa tu correo.",
        ),
    "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "love_and_cats": MessageLookupByLibrary.simpleMessage("Amor y Gatos"),
    "more": MessageLookupByLibrary.simpleMessage("Más"),
    "my_first_group": MessageLookupByLibrary.simpleMessage("Mi Primer Grupo"),
    "name_max_length": m5,
    "name_min_length": m6,
    "new_ingredient": MessageLookupByLibrary.simpleMessage("Nuevo Ingrediente"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "no_group_selected": MessageLookupByLibrary.simpleMessage(
      "Ningún grupo seleccionado",
    ),
    "no_groups_created": MessageLookupByLibrary.simpleMessage(
      "No se han creado grupos",
    ),
    "no_ingredients_created": MessageLookupByLibrary.simpleMessage(
      "No se han creado ingredientes",
    ),
    "no_ingredients_created_description": MessageLookupByLibrary.simpleMessage(
      "Crea tu primer ingrediente para comenzar con recetas y listas de compras.",
    ),
    "no_recipes_created": MessageLookupByLibrary.simpleMessage(
      "No se han creado recetas",
    ),
    "no_recipes_created_description": MessageLookupByLibrary.simpleMessage(
      "Crea tu primera receta para organizar tu cocina y generar listas de compras.",
    ),
    "non_actual_ingredients": MessageLookupByLibrary.simpleMessage(
      "No Ingredientes",
    ),
    "non_actual_ingredients_subtitle": MessageLookupByLibrary.simpleMessage(
      "Estos elementos se pueden agregar a la lista de compras pero no se pueden usar en recetas",
    ),
    "not_connected": MessageLookupByLibrary.simpleMessage("No Conectado"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "on_list": MessageLookupByLibrary.simpleMessage("en lista"),
    "optional_quantities_text": MessageLookupByLibrary.simpleMessage(
      "Opcionalmente, ingresa las cantidades de los ingredientes abajo.",
    ),
    "other_ingredients": MessageLookupByLibrary.simpleMessage(
      "Otros Ingredientes",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "passwords_do_not_match_error": MessageLookupByLibrary.simpleMessage(
      "Las contraseñas no coinciden",
    ),
    "please_enter_valid_number": MessageLookupByLibrary.simpleMessage(
      "Por favor ingrese un número válido",
    ),
    "quantities_shopping_list_text": MessageLookupByLibrary.simpleMessage(
      "Las cantidades aparecerán en la lista de compras cuando la receta esté seleccionada.",
    ),
    "quantity": MessageLookupByLibrary.simpleMessage("Cantidad"),
    "quantity_for": m7,
    "recipe": m8,
    "recipe_name": MessageLookupByLibrary.simpleMessage("Nombre de la Receta"),
    "reset_password": MessageLookupByLibrary.simpleMessage(
      "Restablecer Contraseña",
    ),
    "reset_password_error": MessageLookupByLibrary.simpleMessage(
      "Error al enviar correo de restablecimiento de contraseña",
    ),
    "reset_password_success": MessageLookupByLibrary.simpleMessage(
      "¡Correo de restablecimiento de contraseña enviado! Por favor revisa tu bandeja de entrada.",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Guardar"),
    "save_without_price": MessageLookupByLibrary.simpleMessage(
      "Guardar Sin Precio",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Buscar"),
    "select_currency": MessageLookupByLibrary.simpleMessage(
      "Seleccionar Moneda",
    ),
    "select_ingredients": MessageLookupByLibrary.simpleMessage(
      "Seleccionar Ingredientes",
    ),
    "select_language": MessageLookupByLibrary.simpleMessage(
      "Seleccionar Idioma",
    ),
    "select_recipes": MessageLookupByLibrary.simpleMessage(
      "Seleccionar recetas",
    ),
    "show_budget": MessageLookupByLibrary.simpleMessage("Mostrar presupuesto"),
    "show_checked_first": MessageLookupByLibrary.simpleMessage(
      "Mostrar marcados primero",
    ),
    "show_list_by_ingredients": MessageLookupByLibrary.simpleMessage(
      "Mostrar lista por ingredientes",
    ),
    "show_list_by_recipes": MessageLookupByLibrary.simpleMessage(
      "Mostrar lista por recetas",
    ),
    "spent_of": MessageLookupByLibrary.simpleMessage(" gastado de "),
    "success": MessageLookupByLibrary.simpleMessage("Éxito"),
    "tfor": MessageLookupByLibrary.simpleMessage("para "),
    "theme": MessageLookupByLibrary.simpleMessage("Tema"),
    "try_again": MessageLookupByLibrary.simpleMessage("Intente de nuevo"),
    "unit_price": MessageLookupByLibrary.simpleMessage("Precio Unitario"),
    "unknown_view": MessageLookupByLibrary.simpleMessage("Vista desconocida"),
    "wear_os_sync": MessageLookupByLibrary.simpleMessage(
      "Sincronización con Wear OS",
    ),
    "yes": MessageLookupByLibrary.simpleMessage("Sí"),
    "your_groups": MessageLookupByLibrary.simpleMessage("Tus Grupos"),
  };
}
