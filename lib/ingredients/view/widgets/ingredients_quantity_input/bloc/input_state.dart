part of 'input_cubit.dart';

class IngredientQuantityInputState<T extends BasicIngredientQuantity>
    extends Equatable {
  const IngredientQuantityInputState({
    required this.items,
  });

  final List<T> items;

  IngredientQuantityInputState<T> copyWith({
    List<T>? items,
  }) {
    return IngredientQuantityInputState<T>(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    items,
  ];
}

class IngredientQuantityInputItemState<T extends BasicIngredientQuantity>
    extends Equatable {
  const IngredientQuantityInputItemState({
    required this.item,
    required this.ingredientQuantity,
    required this.ingredient,
  });

  final T item;
  final IngredientQuantity ingredientQuantity;
  final IngredientQuantityInputIngredient ingredient;

  IngredientQuantityInputItemState<T> copyWith({
    T? item,
    IngredientQuantity? ingredientQuantity,
    IngredientQuantityInputIngredient? ingredient,
  }) {
    return IngredientQuantityInputItemState<T>(
      item: item ?? this.item,
      ingredientQuantity: ingredientQuantity ?? this.ingredientQuantity,
      ingredient: ingredient ?? this.ingredient,
    );
  }

  @override
  List<Object?> get props => [
    item,
    ingredientQuantity,
    ingredient,
  ];
}
