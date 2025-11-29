import 'package:felicette_recipes/app/view/widgets/generic_select/generic_select.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

class IngredientSelect extends StatelessWidget {
  const IngredientSelect({
    required this.placeholder,
    required this.label,
    super.key,
    this.allowCreation = false,
    this.createIngredient,
    this.onChanged,
    this.errorMessage,
    this.onOpened,
    this.initialValue,
    this.isMulti = false,
  });

  final String? errorMessage;
  final String placeholder;
  final String label;
  final bool allowCreation;
  final bool isMulti;
  final List<String>? initialValue;
  final Future<FRIngredient> Function({required String name})? createIngredient;
  final ValueChanged<List<String>>? onChanged;
  final VoidCallback? onOpened;

  @override
  Widget build(BuildContext context) {
    return GenericSelect<FRIngredient, IngredientsBloc>(
      placeholder: placeholder,
      label: label,
      allowCreation: allowCreation,
      createItem: createIngredient,
      isMulti: isMulti,
      onChanged: onChanged,
      errorMessage: errorMessage,
      onOpened: onOpened,
      initialValue: initialValue,
      getId: (ingredient) => ingredient.id,
      getName: (ingredient) => ingredient.name,
      getItems: (bloc) => bloc.state.ingredients,
      filterPredicate: (ingredient, filter) {
        final ingredientNameSanitized = ingredient.name.normalizeForSearch();
        final filterSanitized = filter.normalizeForSearch();
        return ingredientNameSanitized.contains(filterSanitized);
      },
      itemExists: (items, name) {
        return items.any(
          (ingredient) => ingredient.name.toLowerCase() == name.toLowerCase(),
        );
      },
    );
  }
}
