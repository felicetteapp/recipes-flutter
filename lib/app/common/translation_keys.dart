class TranslationKeys {
  static const String nameMinLength = 'name_min_length';
  static const String nameMaxLength = 'name_max_length';

  // common
  static const String email = 'email';
  static const String password = 'password';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String cancel = 'cancel';
  static const String save = 'save';
  static const String delete = 'delete';
  static const String edit = 'edit';
  static const String confirm = 'confirm';
  static const String success = 'success';
  static const String tryAgain = 'try_again';
  static const String list = 'list';
  static const String onList = 'on_list';
  static const String recipe = 'recipe';
  static const String ingredient = 'ingredient';
  static const String showListByIngredients = 'show_list_by_ingredients';
  static const String showListByRecipes = 'show_list_by_recipes';
  static const String showCheckedFirst = 'show_checked_first';
  static const String otherIngredients = 'other_ingredients';
  static const String for_ = 'for';

  // login
  static const String loginErrorTitle = 'login_error';

  // home view
  static const String unknownView = 'unknown_view';
  static const String addRecipe = 'add_recipe';
  static const String addIngredient = 'add_ingredient';
  static const String selectRecipes = 'select_recipes';
  static const String itemsSelected = 'items_selected';

  // drawer
  static const String yourGroups = 'your_groups';
  static const String language = 'language';
  static const String selectLanguage = 'select_language';
  static const String about = 'about';
  static const String applicationName = 'application_name';
  static const String applicationDescription = 'application_description';
  static const String developedWith = 'developed_with_love';
  static const String loveAndCats = 'love_and_cats';
  static const String developedIn = 'developed_in';
  static const String developedBy = 'developed_by';
  static const String checkoutGithub = 'checkout_github';

  // budget display
  static const String spentOf = 'spent_of';
  static const String available = 'available';

  // ingredients
  static const String actualIngredients = 'actual_ingredients';
  static const String actualIngredientsSubtitle = 'actual_ingredients_subtitle';
  static const String nonActualIngredients = 'non_actual_ingredients';
  static const String nonActualIngredientsSubtitle =
      'non_actual_ingredients_subtitle';
  static const String newIngredient = 'new_ingredient';
  static const String ingredientName = 'ingredient_name';
  static const String isActualIngredient = 'is_actual_ingredient';
  static const String editIngredient = 'edit_ingredient';
  static const String confirmDeletion = 'confirm_deletion';
  static const String confirmDeletionMessage = 'confirm_deletion_message';
  static const String ingredientUpdatedSuccessfully =
      'ingredient_updated_successfully';
  static const String ingredientDeletedSuccessfully =
      'ingredient_deleted_successfully';
  static const String ingredientCreatedSuccessfully =
      'ingredient_created_successfully';

  // recipes
  static const String editRecipe = 'edit_recipe';
  static const String createRecipe = 'create_recipe';
  static const String recipeName = 'recipe_name';
  static const String selectIngredients = 'select_ingredients';
  static const String chooseIngredientsText = 'choose_ingredients_text';
  static const String optionalQuantitiesText = 'optional_quantities_text';
  static const String quantitiesShoppingListText =
      'quantities_shopping_list_text';
  static const String quantityFor = 'quantity_for';

  // select modal
  static const String search = 'search';
  static const String create = 'create';
  static const String done = 'done';

  static pluralKey(String key) => '${key}_other';
}
