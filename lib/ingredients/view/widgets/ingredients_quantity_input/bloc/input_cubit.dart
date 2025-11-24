import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/ingredients/view/widgets/ingredients_quantity_input/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';
part 'input_state.dart';

class IngredientsQuantityInputCubit<T extends BasicIngredientQuantity>
    extends Cubit<IngredientQuantityInputState<T>> {
  IngredientsQuantityInputCubit({
    required IngredientQuantityInputState<T> initialState,
    required this.onChanged,
    required this.generateEmpty,
    this.createIngredient,
  }) : super(initialState);

  Future<FRIngredient> Function({required String name})? createIngredient;
  final ValueChanged<List<T>> onChanged;
  final T Function() generateEmpty;

  void itemsChanged(List<T> newItems) {
    log(
      'Items changed called with ${newItems.length} items',
      name: 'IngredientsQuantityInputCubit.itemsChanged',
    );
    emit(
      state.copyWith(
        items: newItems,
      ),
    );
    onChanged(newItems);
  }

  void itemChanged(int index, T newItem) {
    log(
      'Item changed at index $index',
      name: 'IngredientsQuantityInputCubit.itemChanged',
    );
    final newItems = List<T>.from(state.items);
    newItems[index] = newItem;
    itemsChanged(newItems);
  }
}

class IngredientQuantityInputItemCubit<T extends BasicIngredientQuantity>
    extends Cubit<IngredientQuantityInputItemState<T>> {
  IngredientQuantityInputItemCubit({
    required IngredientQuantityInputItemState<T> initialState,
  }) : super(initialState);

  void ingredientQuantityChanged(String newQuantity) {
    emit(
      state.copyWith(
        ingredientQuantity: IngredientQuantity.dirty(newQuantity),
        item:
            state.item.copyWith(
                  quantity: newQuantity,
                )
                as T,
      ),
    );
  }

  void ingredientTouched() {
    emit(
      state.copyWith(
        ingredient: IngredientQuantityInputIngredient.dirty(
          state.ingredient.value,
        ),
      ),
    );
  }

  void ingredientChanged(String newIngredient) {
    emit(
      state.copyWith(
        ingredient: IngredientQuantityInputIngredient.dirty(newIngredient),
        item:
            state.item.copyWith(
                  ingredientId: newIngredient,
                )
                as T,
      ),
    );
  }
}
