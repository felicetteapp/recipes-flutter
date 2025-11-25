import 'package:equatable/equatable.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';

enum ListDisplayTypeEnum { ingredients, recipes }

class ListIngredientItem extends Equatable {
  const ListIngredientItem({
    required this.ingredient,
    required this.quantity,
    required this.associatedRecipes,
    required this.isChecked,
    required this.prices,
  });
  final FRIngredient ingredient;
  final List<FRRecipe> associatedRecipes;
  final String? quantity;
  final bool isChecked;
  final List<FRIngredientPrice> prices;
  String get ingredientId => ingredient.id;

  @override
  List<Object?> get props => [
    ingredient,
    associatedRecipes,
    quantity,
    isChecked,
    prices,
  ];
}

class ListRecipeItem extends Equatable {
  const ListRecipeItem({
    required this.recipe,
  });
  final FRRecipe recipe;
  String get recipeId => recipe.id;

  @override
  List<Object?> get props => [
    recipe,
  ];
}

enum ListPageListItemTypeEnum { ingredient, recipe }

class ListPageListItem extends Equatable {
  const ListPageListItem({
    required this.type,
    this.ingredientItem,
    this.recipeItem,
  });

  final ListPageListItemTypeEnum type;
  final ListIngredientItem? ingredientItem;
  final ListRecipeItem? recipeItem;

  @override
  List<Object?> get props => [
    type,
    ingredientItem,
    recipeItem,
  ];
}
