part of 'ingredients_bloc.dart';

sealed class IngredientsEvent extends Equatable {
  const IngredientsEvent();

  @override
  List<Object?> get props => [];
}

final class IngredientSelectedGroupChanged extends IngredientsEvent {
  const IngredientSelectedGroupChanged(this.group);

  final FRGroup? group;

  @override
  List<Object?> get props => [group];
}
