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
