class AppRoutes {
  static const String splash = '/';
  static const String home = list;
  static const String login = '/login';
  static const String passwordRecovery = '/password-recovery';
  static const String groups = '/groups';
  static const String detailsPart = '/details';
  static const String createAccount = '/create-account';
  static const String recipes = '/recipes';
  static const String newGroup = '$groups/new';
  static const String list = '/list';
  static const String ingredients = '/ingredients';
  static const String newIngredient = '$ingredients/new';
  static const String editIngredient = '$ingredients/:ingredientId/edit';
  static const String newRecipe = '$recipes/new';
  static const String editRecipe = '$recipes/:recipeId/edit';
  static const String editList = '$list/edit';
  static const String editGroup = '$groups/:groupId/edit';

  static String toEditGroup(String groupId) =>
      editGroup.replaceFirst(':groupId', groupId);

  static String toEditIngredient(String ingredientId) =>
      editIngredient.replaceFirst(':ingredientId', ingredientId);

  static String toEditRecipe(String recipeId) =>
      editRecipe.replaceFirst(':recipeId', recipeId);
}
