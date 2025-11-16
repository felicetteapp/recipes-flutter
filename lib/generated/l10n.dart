// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Name must be at least {min} characters`
  String name_min_length(int min) {
    return Intl.message(
      'Name must be at least $min characters',
      name: 'name_min_length',
      desc: '',
      args: [min],
    );
  }

  /// `Name cannot exceed {max} characters`
  String name_max_length(int max) {
    return Intl.message(
      'Name cannot exceed $max characters',
      name: 'name_max_length',
      desc: '',
      args: [max],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Try Again`
  String get try_again {
    return Intl.message('Try Again', name: 'try_again', desc: '', args: []);
  }

  /// `{count, plural, =1{list} other{lists}}`
  String list(int count) {
    return Intl.plural(
      count,
      one: 'list',
      other: 'lists',
      name: 'list',
      desc: '',
      args: [count],
    );
  }

  /// `on list`
  String get on_list {
    return Intl.message('on list', name: 'on_list', desc: '', args: []);
  }

  /// `{count, plural, =1{recipe} other{recipes}}`
  String recipe(int count) {
    return Intl.plural(
      count,
      one: 'recipe',
      other: 'recipes',
      name: 'recipe',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{ingredient} other{ingredients}}`
  String ingredient(int count) {
    return Intl.plural(
      count,
      one: 'ingredient',
      other: 'ingredients',
      name: 'ingredient',
      desc: '',
      args: [count],
    );
  }

  /// `Show list by ingredients`
  String get show_list_by_ingredients {
    return Intl.message(
      'Show list by ingredients',
      name: 'show_list_by_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Show list by recipes`
  String get show_list_by_recipes {
    return Intl.message(
      'Show list by recipes',
      name: 'show_list_by_recipes',
      desc: '',
      args: [],
    );
  }

  /// `Show checked first`
  String get show_checked_first {
    return Intl.message(
      'Show checked first',
      name: 'show_checked_first',
      desc: '',
      args: [],
    );
  }

  /// `Show budget`
  String get show_budget {
    return Intl.message('Show budget', name: 'show_budget', desc: '', args: []);
  }

  /// `Other Ingredients`
  String get other_ingredients {
    return Intl.message(
      'Other Ingredients',
      name: 'other_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `for `
  String get tfor {
    return Intl.message('for ', name: 'tfor', desc: '', args: []);
  }

  /// `Budget`
  String get budget {
    return Intl.message('Budget', name: 'budget', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Loading`
  String get loading {
    return Intl.message('Loading', name: 'loading', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message('Dark Mode', name: 'dark_mode', desc: '', args: []);
  }

  /// `Light Mode`
  String get light_mode {
    return Intl.message('Light Mode', name: 'light_mode', desc: '', args: []);
  }

  /// `My First Group`
  String get my_first_group {
    return Intl.message(
      'My First Group',
      name: 'my_first_group',
      desc: '',
      args: [],
    );
  }

  /// `Wear OS Sync`
  String get wear_os_sync {
    return Intl.message(
      'Wear OS Sync',
      name: 'wear_os_sync',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Not Connected`
  String get not_connected {
    return Intl.message(
      'Not Connected',
      name: 'not_connected',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get input_required_error {
    return Intl.message(
      'This field is required',
      name: 'input_required_error',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get invalid_email_error {
    return Intl.message(
      'Please enter a valid email address',
      name: 'invalid_email_error',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get email_is_required_error {
    return Intl.message(
      'Email is required',
      name: 'email_is_required_error',
      desc: '',
      args: [],
    );
  }

  /// `Unknown View`
  String get unknown_view {
    return Intl.message(
      'Unknown View',
      name: 'unknown_view',
      desc: '',
      args: [],
    );
  }

  /// `Add Recipe`
  String get add_recipe {
    return Intl.message('Add Recipe', name: 'add_recipe', desc: '', args: []);
  }

  /// `Add Ingredient`
  String get add_ingredient {
    return Intl.message(
      'Add Ingredient',
      name: 'add_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `Select recipes`
  String get select_recipes {
    return Intl.message(
      'Select recipes',
      name: 'select_recipes',
      desc: '',
      args: [],
    );
  }

  /// `{count} selected`
  String items_selected(int count) {
    return Intl.message(
      '$count selected',
      name: 'items_selected',
      desc: '',
      args: [count],
    );
  }

  /// `No groups created`
  String get no_groups_created {
    return Intl.message(
      'No groups created',
      name: 'no_groups_created',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get login_error {
    return Intl.message(
      'Login failed',
      name: 'login_error',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent! Please check your inbox.`
  String get reset_password_success {
    return Intl.message(
      'Password reset email sent! Please check your inbox.',
      name: 'reset_password_success',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send password reset email`
  String get reset_password_error {
    return Intl.message(
      'Failed to send password reset email',
      name: 'reset_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get create_account {
    return Intl.message(
      'Create Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_do_not_match_error {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create account`
  String get create_account_error {
    return Intl.message(
      'Failed to create account',
      name: 'create_account_error',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully!`
  String get create_account_success {
    return Intl.message(
      'Account created successfully!',
      name: 'create_account_success',
      desc: '',
      args: [],
    );
  }

  /// `Login without password`
  String get login_without_password {
    return Intl.message(
      'Login without password',
      name: 'login_without_password',
      desc: '',
      args: [],
    );
  }

  /// `Login link sent! Please check your email.`
  String get login_without_password_success_message {
    return Intl.message(
      'Login link sent! Please check your email.',
      name: 'login_without_password_success_message',
      desc: '',
      args: [],
    );
  }

  /// `Your Groups`
  String get your_groups {
    return Intl.message('Your Groups', name: 'your_groups', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Felicette Recipes`
  String get application_name {
    return Intl.message(
      'Felicette Recipes',
      name: 'application_name',
      desc: '',
      args: [],
    );
  }

  /// `Felicette Recipes is an open-source application to help you manage your recipes and shopping lists.`
  String get application_description {
    return Intl.message(
      'Felicette Recipes is an open-source application to help you manage your recipes and shopping lists.',
      name: 'application_description',
      desc: '',
      args: [],
    );
  }

  /// `Developed with`
  String get developed_with_love {
    return Intl.message(
      'Developed with',
      name: 'developed_with_love',
      desc: '',
      args: [],
    );
  }

  /// `Love and Cats`
  String get love_and_cats {
    return Intl.message(
      'Love and Cats',
      name: 'love_and_cats',
      desc: '',
      args: [],
    );
  }

  /// `in Curitiba, Brazil.`
  String get developed_in {
    return Intl.message(
      'in Curitiba, Brazil.',
      name: 'developed_in',
      desc: '',
      args: [],
    );
  }

  /// `By felicette.dev`
  String get developed_by {
    return Intl.message(
      'By felicette.dev',
      name: 'developed_by',
      desc: '',
      args: [],
    );
  }

  /// `Check out the project on GitHub: `
  String get checkout_github {
    return Intl.message(
      'Check out the project on GitHub: ',
      name: 'checkout_github',
      desc: '',
      args: [],
    );
  }

  /// ` spent of `
  String get spent_of {
    return Intl.message(' spent of ', name: 'spent_of', desc: '', args: []);
  }

  /// ` available`
  String get available {
    return Intl.message(' available', name: 'available', desc: '', args: []);
  }

  /// `Actual Ingredients`
  String get actual_ingredients {
    return Intl.message(
      'Actual Ingredients',
      name: 'actual_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `These items can be used in recipes and added to the shopping list`
  String get actual_ingredients_subtitle {
    return Intl.message(
      'These items can be used in recipes and added to the shopping list',
      name: 'actual_ingredients_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Non-Ingredients`
  String get non_actual_ingredients {
    return Intl.message(
      'Non-Ingredients',
      name: 'non_actual_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `This items can be added to the shopping list but can't be used in recipes`
  String get non_actual_ingredients_subtitle {
    return Intl.message(
      'This items can be added to the shopping list but can\'t be used in recipes',
      name: 'non_actual_ingredients_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `New Ingredient`
  String get new_ingredient {
    return Intl.message(
      'New Ingredient',
      name: 'new_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient Name`
  String get ingredient_name {
    return Intl.message(
      'Ingredient Name',
      name: 'ingredient_name',
      desc: '',
      args: [],
    );
  }

  /// `Is Actual Ingredient`
  String get is_actual_ingredient {
    return Intl.message(
      'Is Actual Ingredient',
      name: 'is_actual_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `Edit Ingredient`
  String get edit_ingredient {
    return Intl.message(
      'Edit Ingredient',
      name: 'edit_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get confirm_deletion {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirm_deletion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this ingredient?`
  String get confirm_deletion_message {
    return Intl.message(
      'Are you sure you want to delete this ingredient?',
      name: 'confirm_deletion_message',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient updated successfully`
  String get ingredient_updated_successfully {
    return Intl.message(
      'Ingredient updated successfully',
      name: 'ingredient_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient deleted successfully`
  String get ingredient_deleted_successfully {
    return Intl.message(
      'Ingredient deleted successfully',
      name: 'ingredient_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient created successfully`
  String get ingredient_created_successfully {
    return Intl.message(
      'Ingredient created successfully',
      name: 'ingredient_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Is "{ingredientName}" an actual ingredient that can be used in recipes?`
  String confirm_actual_ingredient_description(String ingredientName) {
    return Intl.message(
      'Is "$ingredientName" an actual ingredient that can be used in recipes?',
      name: 'confirm_actual_ingredient_description',
      desc: '',
      args: [ingredientName],
    );
  }

  /// `Confirm Actual Ingredient`
  String get confirm_actual_ingredient {
    return Intl.message(
      'Confirm Actual Ingredient',
      name: 'confirm_actual_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `No ingredients created`
  String get no_ingredients_created {
    return Intl.message(
      'No ingredients created',
      name: 'no_ingredients_created',
      desc: '',
      args: [],
    );
  }

  /// `Create your first ingredient to get started with recipes and shopping lists.`
  String get no_ingredients_created_description {
    return Intl.message(
      'Create your first ingredient to get started with recipes and shopping lists.',
      name: 'no_ingredients_created_description',
      desc: '',
      args: [],
    );
  }

  /// `Edit Recipe`
  String get edit_recipe {
    return Intl.message('Edit Recipe', name: 'edit_recipe', desc: '', args: []);
  }

  /// `Create Recipe`
  String get create_recipe {
    return Intl.message(
      'Create Recipe',
      name: 'create_recipe',
      desc: '',
      args: [],
    );
  }

  /// `Recipe Name`
  String get recipe_name {
    return Intl.message('Recipe Name', name: 'recipe_name', desc: '', args: []);
  }

  /// `Select Ingredients`
  String get select_ingredients {
    return Intl.message(
      'Select Ingredients',
      name: 'select_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Choose the ingredients needed for the recipe. Quantities can be entered below.`
  String get choose_ingredients_text {
    return Intl.message(
      'Choose the ingredients needed for the recipe. Quantities can be entered below.',
      name: 'choose_ingredients_text',
      desc: '',
      args: [],
    );
  }

  /// `Optionally, enter the quantities of the ingredients below.`
  String get optional_quantities_text {
    return Intl.message(
      'Optionally, enter the quantities of the ingredients below.',
      name: 'optional_quantities_text',
      desc: '',
      args: [],
    );
  }

  /// `The quantities will appear in the shopping list when the recipe is selected.`
  String get quantities_shopping_list_text {
    return Intl.message(
      'The quantities will appear in the shopping list when the recipe is selected.',
      name: 'quantities_shopping_list_text',
      desc: '',
      args: [],
    );
  }

  /// `Quantity for {ingredient}`
  String quantity_for(String ingredient) {
    return Intl.message(
      'Quantity for $ingredient',
      name: 'quantity_for',
      desc: '',
      args: [ingredient],
    );
  }

  /// `No recipes created`
  String get no_recipes_created {
    return Intl.message(
      'No recipes created',
      name: 'no_recipes_created',
      desc: '',
      args: [],
    );
  }

  /// `Create your first recipe to organize your cooking and generate shopping lists.`
  String get no_recipes_created_description {
    return Intl.message(
      'Create your first recipe to organize your cooking and generate shopping lists.',
      name: 'no_recipes_created_description',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Edit List`
  String get edit_list {
    return Intl.message('Edit List', name: 'edit_list', desc: '', args: []);
  }

  /// `Select Currency`
  String get select_currency {
    return Intl.message(
      'Select Currency',
      name: 'select_currency',
      desc: '',
      args: [],
    );
  }

  /// `Clear All Checks`
  String get clear_all_checks {
    return Intl.message(
      'Clear All Checks',
      name: 'clear_all_checks',
      desc: '',
      args: [],
    );
  }

  /// `All checks have been cleared`
  String get all_checks_cleared {
    return Intl.message(
      'All checks have been cleared',
      name: 'all_checks_cleared',
      desc: '',
      args: [],
    );
  }

  /// `US Dollar`
  String get currency_usd {
    return Intl.message('US Dollar', name: 'currency_usd', desc: '', args: []);
  }

  /// `Euro`
  String get currency_eur {
    return Intl.message('Euro', name: 'currency_eur', desc: '', args: []);
  }

  /// `British Pound`
  String get currency_gbp {
    return Intl.message(
      'British Pound',
      name: 'currency_gbp',
      desc: '',
      args: [],
    );
  }

  /// `Japanese Yen`
  String get currency_jpy {
    return Intl.message(
      'Japanese Yen',
      name: 'currency_jpy',
      desc: '',
      args: [],
    );
  }

  /// `Chinese Yuan`
  String get currency_cny {
    return Intl.message(
      'Chinese Yuan',
      name: 'currency_cny',
      desc: '',
      args: [],
    );
  }

  /// `Brazilian Real`
  String get currency_brl {
    return Intl.message(
      'Brazilian Real',
      name: 'currency_brl',
      desc: '',
      args: [],
    );
  }

  /// `Argentine Peso`
  String get currency_ars {
    return Intl.message(
      'Argentine Peso',
      name: 'currency_ars',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get please_enter_valid_number {
    return Intl.message(
      'Please enter a valid number',
      name: 'please_enter_valid_number',
      desc: '',
      args: [],
    );
  }

  /// `Budget must be a positive number`
  String get budget_must_be_positive {
    return Intl.message(
      'Budget must be a positive number',
      name: 'budget_must_be_positive',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `No group selected`
  String get no_group_selected {
    return Intl.message(
      'No group selected',
      name: 'no_group_selected',
      desc: '',
      args: [],
    );
  }

  /// `List details updated successfully`
  String get list_details_updated_successfully {
    return Intl.message(
      'List details updated successfully',
      name: 'list_details_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update list details: {error}`
  String failed_to_update_list_details(String error) {
    return Intl.message(
      'Failed to update list details: $error',
      name: 'failed_to_update_list_details',
      desc: '',
      args: [error],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Unit Price`
  String get unit_price {
    return Intl.message('Unit Price', name: 'unit_price', desc: '', args: []);
  }

  /// `Add Price`
  String get add_price {
    return Intl.message('Add Price', name: 'add_price', desc: '', args: []);
  }

  /// `Enter Quantity`
  String get enter_quantity {
    return Intl.message(
      'Enter Quantity',
      name: 'enter_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Save Without Price`
  String get save_without_price {
    return Intl.message(
      'Save Without Price',
      name: 'save_without_price',
      desc: '',
      args: [],
    );
  }

  /// `Actual Ingredient`
  String get actual_ingredient_title {
    return Intl.message(
      'Actual Ingredient',
      name: 'actual_ingredient_title',
      desc: '',
      args: [],
    );
  }

  /// `Is this an actual ingredient that can be used in recipes?`
  String get actual_ingredient_content {
    return Intl.message(
      'Is this an actual ingredient that can be used in recipes?',
      name: 'actual_ingredient_content',
      desc: '',
      args: [],
    );
  }

  /// `Create Group`
  String get create_group {
    return Intl.message(
      'Create Group',
      name: 'create_group',
      desc: '',
      args: [],
    );
  }

  /// `Edit Group`
  String get edit_group {
    return Intl.message('Edit Group', name: 'edit_group', desc: '', args: []);
  }

  /// `Group Name`
  String get group_name {
    return Intl.message('Group Name', name: 'group_name', desc: '', args: []);
  }

  /// `Group updated successfully`
  String get group_name_updated {
    return Intl.message(
      'Group updated successfully',
      name: 'group_name_updated',
      desc: '',
      args: [],
    );
  }

  /// `Delete Group`
  String get delete_group {
    return Intl.message(
      'Delete Group',
      name: 'delete_group',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this group? This action cannot be undone.`
  String get delete_group_message {
    return Intl.message(
      'Are you sure you want to delete this group? This action cannot be undone.',
      name: 'delete_group_message',
      desc: '',
      args: [],
    );
  }

  /// `Group deleted successfully`
  String get group_deleted {
    return Intl.message(
      'Group deleted successfully',
      name: 'group_deleted',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the maximum number of groups allowed.`
  String get group_creation_limit_reached {
    return Intl.message(
      'You have reached the maximum number of groups allowed.',
      name: 'group_creation_limit_reached',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
