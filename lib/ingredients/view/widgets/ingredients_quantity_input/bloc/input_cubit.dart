import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_repository/recipe_repository.dart';
part 'input_state.dart';

class IngredientsQuantityInputCubit<T extends BasicIngredientQuantity>
    extends Cubit<IngredientQuantityInputState<T>> {
  IngredientsQuantityInputCubit({
    required IngredientQuantityInputState<T> initialState,
  }) : super(initialState);

  void itemsChanged(List<T> newItems) {
    emit(
      state.copyWith(
        items: newItems,
      ),
    );
  }
}
