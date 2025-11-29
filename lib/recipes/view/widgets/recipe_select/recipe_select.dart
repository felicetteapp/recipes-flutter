import 'package:felicette_recipes/app/view/widgets/generic_select/generic_select.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/recipes/recipes.dart';
import 'package:flutter/material.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeSelect extends StatelessWidget {
  const RecipeSelect({
    required this.placeholder,
    required this.label,
    required this.isMulti,
    this.errorMessage,
    this.initialValue,
    this.onChanged,
    this.onOpened,
    super.key,
  });

  final String? errorMessage;
  final String placeholder;
  final String label;
  final bool isMulti;
  final List<String>? initialValue;
  final ValueChanged<List<String>>? onChanged;
  final VoidCallback? onOpened;

  @override
  Widget build(BuildContext context) {
    return GenericSelect<FRRecipe, RecipesBloc>(
      placeholder: placeholder,
      label: label,
      isMulti: isMulti,
      onChanged: onChanged,
      errorMessage: errorMessage,
      onOpened: onOpened,
      initialValue: initialValue,
      getId: (recipe) => recipe.id,
      getName: (recipe) => recipe.name,
      getItems: (bloc) => bloc.state.recipes,
      filterPredicate: (recipe, filter) {
        final recipeNameSanitized = recipe.name.normalizeForSearch();
        final filterSanitized = filter.normalizeForSearch();
        return recipeNameSanitized.contains(filterSanitized);
      },
    );
  }
}
