part of 'ingredient_modal_cubit.dart';

class IngredientModalState extends Equatable {
  const IngredientModalState({
    this.item,
  });

  final ListIngredientItem? item;

  @override
  List<Object?> get props => [item];

  IngredientModalState copyWith({
    ListIngredientItem? item,
  }) {
    return IngredientModalState(
      item: item ?? this.item,
    );
  }
}
