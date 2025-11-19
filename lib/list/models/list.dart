import 'package:ingredient_repository/ingredient_repository.dart';

enum ListDisplayTypeEnum { ingredients, recipes }

class ListIngredientItem {
  ListIngredientItem(this.ingredient);
  final FRIngredient ingredient;
}
