import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';
part 'input_state.dart';

class IngredientsQuantityInputCubit<T extends BasicIngredientQuantity>
    extends Cubit<IngredientQuantityInputState<T>> {
  IngredientsQuantityInputCubit({
    required IngredientQuantityInputState<T> initialState,
    this.createIngredient,
  }) : super(initialState);

  Future<FRIngredient> Function({required String name})? createIngredient;

  void itemsChanged(List<T> newItems) {
    emit(
      state.copyWith(
        items: newItems,
      ),
    );
  }
}

class IngredientQuantityInputItemCubit<T extends BasicIngredientQuantity>
    extends Cubit<IngredientQuantityInputItemState<T>> {
  IngredientQuantityInputItemCubit({
    required IngredientQuantityInputItemState<T> initialState,
  }) : super(initialState);
}
