import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

part 'select_state.dart';

class IngredientSelectCubit extends Cubit<IngredientSelectState> {
  IngredientSelectCubit({this.allowCreation = false, this.createIngredient})
    : _ingredients = [],
      super(const IngredientSelectState());

  final List<FRIngredient> _ingredients;
  final bool allowCreation;
  final Future<FRIngredient> Function({required String name})? createIngredient;

  FRIngredient? get selectedIngredient => _ingredients.firstWhereOrNull(
    (ingredient) => ingredient.id == state.selectedIngredientId,
  );

  List<FRIngredient> get ingredients => _ingredients;

  void clearSelection() {
    emit(state.clearSelection());
  }

  void initIngredients(List<FRIngredient> ingredients) {
    log(
      'Initializing ingredients with ${ingredients.length} items',
      name: 'IngredientSelectCubit',
    );
    _ingredients
      ..clear()
      ..addAll(ingredients);
    emit(
      state.copyWith(
        filteredIngredients: ingredients,
      ),
    );
  }

  void filterChange(String filter) {
    log('Filter changed to $filter', name: 'IngredientSelectCubit');

    final newFiltered = _ingredients.where(
      (ingredient) {
        final ingredientNameSanitized = ingredient.name.normalizeForSearch();
        if (filter.isEmpty) {
          return true;
        }
        final filterSanitized = filter.normalizeForSearch();
        return ingredientNameSanitized.contains(
          filterSanitized,
        );
      },
    ).toList();

    log(
      'New filtered ingredients: $newFiltered',
      name: 'IngredientSelectCubit',
    );
    emit(
      state.copyWith(textFilter: filter, filteredIngredients: newFiltered),
    );
  }

  void selectIngredient(String ingredientId) {
    emit(
      state.copyWith(
        selectedIngredientId: ingredientId,
      ),
    );
  }
}
