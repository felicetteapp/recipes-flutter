// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(ingredientName) =>
      "Is \"${ingredientName}\" an actual ingredient that can be used in recipes?";

  static String m1(error) => "Failed to update list details: ${error}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'ingredient', other: 'ingredients')}";

  static String m3(count) =>
      "${Intl.plural(count, zero: 'No items selected', one: '1 item selected', other: '${count} items selected')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'list', other: 'lists')}";

  static String m5(max) => "Name cannot exceed ${max} characters";

  static String m6(min) => "Name must be at least ${min} characters";

  static String m7(ingredient) => "Quantity for ${ingredient}";

  static String m8(count) =>
      "${Intl.plural(count, one: 'recipe', other: 'recipes')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "actual_ingredient_content": MessageLookupByLibrary.simpleMessage(
      "Is this an actual ingredient that can be used in recipes?",
    ),
    "actual_ingredient_title": MessageLookupByLibrary.simpleMessage(
      "Actual Ingredient",
    ),
    "actual_ingredients": MessageLookupByLibrary.simpleMessage(
      "Actual Ingredients",
    ),
    "actual_ingredients_subtitle": MessageLookupByLibrary.simpleMessage(
      "These items can be used in recipes and added to the shopping list",
    ),
    "add_ingredient": MessageLookupByLibrary.simpleMessage("Add Ingredient"),
    "add_price": MessageLookupByLibrary.simpleMessage("Add Price"),
    "add_recipe": MessageLookupByLibrary.simpleMessage("Add Recipe"),
    "all_checks_cleared": MessageLookupByLibrary.simpleMessage(
      "All checks have been cleared",
    ),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "application_description": MessageLookupByLibrary.simpleMessage(
      "Felicette Recipes is an open-source application to help you manage your recipes and shopping lists.",
    ),
    "application_name": MessageLookupByLibrary.simpleMessage(
      "Felicette Recipes",
    ),
    "available": MessageLookupByLibrary.simpleMessage(" available"),
    "budget": MessageLookupByLibrary.simpleMessage("Budget"),
    "budget_must_be_positive": MessageLookupByLibrary.simpleMessage(
      "Budget must be a positive number",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "checkout_github": MessageLookupByLibrary.simpleMessage(
      "Check out the project on GitHub: ",
    ),
    "choose_ingredients_text": MessageLookupByLibrary.simpleMessage(
      "Choose the ingredients needed for the recipe. Quantities can be entered below.",
    ),
    "clear_all_checks": MessageLookupByLibrary.simpleMessage(
      "Clear All Checks",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirm_actual_ingredient": MessageLookupByLibrary.simpleMessage(
      "Confirm Actual Ingredient",
    ),
    "confirm_actual_ingredient_description": m0,
    "confirm_ingredient_deletion": MessageLookupByLibrary.simpleMessage(
      "Confirm Deletion",
    ),
    "confirm_ingredient_deletion_message": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this ingredient?",
    ),
    "confirm_password": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "confirm_recipe_deletion": MessageLookupByLibrary.simpleMessage(
      "Confirm Deletion",
    ),
    "confirm_recipe_deletion_message": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this recipe?",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "create_account": MessageLookupByLibrary.simpleMessage("Create Account"),
    "create_account_error": MessageLookupByLibrary.simpleMessage(
      "Failed to create account",
    ),
    "create_account_success": MessageLookupByLibrary.simpleMessage(
      "Account created successfully!",
    ),
    "create_group": MessageLookupByLibrary.simpleMessage("Create Group"),
    "create_recipe": MessageLookupByLibrary.simpleMessage("Create Recipe"),
    "currency_ars": MessageLookupByLibrary.simpleMessage("Argentine Peso"),
    "currency_brl": MessageLookupByLibrary.simpleMessage("Brazilian Real"),
    "currency_cny": MessageLookupByLibrary.simpleMessage("Chinese Yuan"),
    "currency_eur": MessageLookupByLibrary.simpleMessage("Euro"),
    "currency_gbp": MessageLookupByLibrary.simpleMessage("British Pound"),
    "currency_jpy": MessageLookupByLibrary.simpleMessage("Japanese Yen"),
    "currency_usd": MessageLookupByLibrary.simpleMessage("US Dollar"),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "delete_group": MessageLookupByLibrary.simpleMessage("Delete Group"),
    "delete_group_message": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this group? This action cannot be undone.",
    ),
    "developed_by": MessageLookupByLibrary.simpleMessage("By felicette.dev"),
    "developed_in": MessageLookupByLibrary.simpleMessage(
      "in Curitiba, Brazil.",
    ),
    "developed_with_love": MessageLookupByLibrary.simpleMessage(
      "Developed with",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "edit_group": MessageLookupByLibrary.simpleMessage("Edit Group"),
    "edit_ingredient": MessageLookupByLibrary.simpleMessage("Edit Ingredient"),
    "edit_list": MessageLookupByLibrary.simpleMessage("Edit List"),
    "edit_recipe": MessageLookupByLibrary.simpleMessage("Edit Recipe"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_is_required_error": MessageLookupByLibrary.simpleMessage(
      "Email is required",
    ),
    "enter_quantity": MessageLookupByLibrary.simpleMessage("Enter Quantity"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "failed_to_update_list_details": m1,
    "forgot_password": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "group_creation_limit_reached": MessageLookupByLibrary.simpleMessage(
      "You have reached the maximum number of groups allowed.",
    ),
    "group_deleted": MessageLookupByLibrary.simpleMessage(
      "Group deleted successfully",
    ),
    "group_name": MessageLookupByLibrary.simpleMessage("Group Name"),
    "group_name_updated": MessageLookupByLibrary.simpleMessage(
      "Group updated successfully",
    ),
    "ingredient": m2,
    "ingredient_created_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingredient created successfully",
    ),
    "ingredient_deleted_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingredient deleted successfully",
    ),
    "ingredient_name": MessageLookupByLibrary.simpleMessage("Ingredient Name"),
    "ingredient_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingredient updated successfully",
    ),
    "input_required_error": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "invalid_email_error": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "is_actual_ingredient": MessageLookupByLibrary.simpleMessage(
      "Is Actual Ingredient",
    ),
    "items_selected": m3,
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "light_mode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "list": m4,
    "list_details_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "List details updated successfully",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Loading"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "login_error": MessageLookupByLibrary.simpleMessage("Login failed"),
    "login_without_password": MessageLookupByLibrary.simpleMessage(
      "Login without password",
    ),
    "login_without_password_success_message":
        MessageLookupByLibrary.simpleMessage(
          "Login link sent! Please check your email.",
        ),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "love_and_cats": MessageLookupByLibrary.simpleMessage("Love and Cats"),
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "my_first_group": MessageLookupByLibrary.simpleMessage("My First Group"),
    "name_max_length": m5,
    "name_min_length": m6,
    "new_ingredient": MessageLookupByLibrary.simpleMessage("New Ingredient"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "no_group_selected": MessageLookupByLibrary.simpleMessage(
      "No group selected",
    ),
    "no_groups_created": MessageLookupByLibrary.simpleMessage(
      "No groups created",
    ),
    "no_ingredients_created": MessageLookupByLibrary.simpleMessage(
      "No ingredients created",
    ),
    "no_ingredients_created_description": MessageLookupByLibrary.simpleMessage(
      "Create your first ingredient to get started with recipes and shopping lists.",
    ),
    "no_recipes_created": MessageLookupByLibrary.simpleMessage(
      "No recipes created",
    ),
    "no_recipes_created_description": MessageLookupByLibrary.simpleMessage(
      "Create your first recipe to organize your cooking and generate shopping lists.",
    ),
    "non_actual_ingredients": MessageLookupByLibrary.simpleMessage(
      "Non-Ingredients",
    ),
    "non_actual_ingredients_subtitle": MessageLookupByLibrary.simpleMessage(
      "This items can be added to the shopping list but can\'t be used in recipes",
    ),
    "not_connected": MessageLookupByLibrary.simpleMessage("Not Connected"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "on_list": MessageLookupByLibrary.simpleMessage("on list"),
    "optional_quantities_text": MessageLookupByLibrary.simpleMessage(
      "Optionally, enter the quantities of the ingredients below.",
    ),
    "other_ingredients": MessageLookupByLibrary.simpleMessage(
      "Other Ingredients",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "password_recovery_email_sent": MessageLookupByLibrary.simpleMessage(
      "Password recovery email sent",
    ),
    "password_recovery_error": MessageLookupByLibrary.simpleMessage(
      "Error sending password recovery email",
    ),
    "passwords_do_not_match_error": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "please_enter_valid_number": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid number",
    ),
    "quantities_shopping_list_text": MessageLookupByLibrary.simpleMessage(
      "The quantities will appear in the shopping list when the recipe is selected.",
    ),
    "quantity": MessageLookupByLibrary.simpleMessage("Quantity"),
    "quantity_for": m7,
    "recipe": m8,
    "recipe_created_successfully": MessageLookupByLibrary.simpleMessage(
      "Recipe created successfully",
    ),
    "recipe_deleted_successfully": MessageLookupByLibrary.simpleMessage(
      "Recipe deleted successfully",
    ),
    "recipe_ingredients_error": MessageLookupByLibrary.simpleMessage(
      "There are errors in the recipe ingredients",
    ),
    "recipe_name": MessageLookupByLibrary.simpleMessage("Recipe Name"),
    "recipe_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "Recipe updated successfully",
    ),
    "recipes_should_have_at_least_one_ingredient":
        MessageLookupByLibrary.simpleMessage(
          "Recipes should have at least one ingredient",
        ),
    "reset_password": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "reset_password_error": MessageLookupByLibrary.simpleMessage(
      "Failed to send password reset email",
    ),
    "reset_password_success": MessageLookupByLibrary.simpleMessage(
      "Password reset email sent! Please check your inbox.",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "save_without_price": MessageLookupByLibrary.simpleMessage(
      "Save Without Price",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "select_at_least_one_ingredient": MessageLookupByLibrary.simpleMessage(
      "Please select at least one ingredient to proceed.",
    ),
    "select_currency": MessageLookupByLibrary.simpleMessage("Select Currency"),
    "select_ingredients": MessageLookupByLibrary.simpleMessage(
      "Select Ingredients",
    ),
    "select_language": MessageLookupByLibrary.simpleMessage("Select Language"),
    "select_recipes": MessageLookupByLibrary.simpleMessage("Select recipes"),
    "show_budget": MessageLookupByLibrary.simpleMessage("Show budget"),
    "show_checked_first": MessageLookupByLibrary.simpleMessage(
      "Show checked first",
    ),
    "show_list_by_ingredients": MessageLookupByLibrary.simpleMessage(
      "Show list by ingredients",
    ),
    "show_list_by_recipes": MessageLookupByLibrary.simpleMessage(
      "Show list by recipes",
    ),
    "spent_of": MessageLookupByLibrary.simpleMessage(" spent of "),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "tfor": MessageLookupByLibrary.simpleMessage("for "),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "try_again": MessageLookupByLibrary.simpleMessage("Try Again"),
    "unit_price": MessageLookupByLibrary.simpleMessage("Unit Price"),
    "unknown_view": MessageLookupByLibrary.simpleMessage("Unknown View"),
    "wear_os_sync": MessageLookupByLibrary.simpleMessage("Wear OS Sync"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "your_groups": MessageLookupByLibrary.simpleMessage("Your Groups"),
  };
}
