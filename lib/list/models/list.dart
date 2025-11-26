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

  ListIngredientItem copyWith({
    FRIngredient? ingredient,
    List<FRRecipe>? associatedRecipes,
    String? quantity,
    bool? isChecked,
    List<FRIngredientPrice>? prices,
  }) {
    return ListIngredientItem(
      ingredient: ingredient ?? this.ingredient,
      associatedRecipes: associatedRecipes ?? this.associatedRecipes,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
      prices: prices ?? this.prices,
    );
  }

  @override
  String toString() {
    return 'ListIngredientItem(ingredient: $ingredient, associatedRecipes: $associatedRecipes, quantity: $quantity, isChecked: $isChecked, prices: $prices)';
  }

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

  static ListRecipeItem withoutRecipe = ListRecipeItem(
    recipe: FRRecipe.empty,
  );

  bool get withoutRecipeFlag => recipe.id.isEmpty;

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
