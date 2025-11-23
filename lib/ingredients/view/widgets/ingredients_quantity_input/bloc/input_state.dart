part of 'input_cubit.dart';

class IngredientQuantityInputState<T extends BasicIngredientQuantity>
    extends Equatable {
  const IngredientQuantityInputState({
    required this.items,
    required this.generateEmpty,
    required this.onChanged,
  });

  final List<T> items;

  final T Function() generateEmpty;
  final ValueChanged<List<T>> onChanged;

  IngredientQuantityInputState<T> copyWith({
    List<T>? items,
    T Function()? generateEmpty,
    ValueChanged<List<T>>? onChanged,
  }) {
    return IngredientQuantityInputState<T>(
      items: items ?? this.items,
      generateEmpty: generateEmpty ?? this.generateEmpty,
      onChanged: onChanged ?? this.onChanged,
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
  });

  final T item;
  final IngredientQuantity ingredientQuantity;

  IngredientQuantityInputItemState<T> copyWith({
    T? item,
    IngredientQuantity? ingredientQuantity,
  }) {
    return IngredientQuantityInputItemState<T>(
      item: item ?? this.item,
      ingredientQuantity: ingredientQuantity ?? this.ingredientQuantity,
    );
  }

  @override
  List<Object?> get props => [
    item,
    ingredientQuantity,
  ];
}
