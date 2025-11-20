part of 'recipes_bloc.dart';

sealed class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  List<Object?> get props => [];
}

final class RecipesSelectionToggled extends RecipesEvent {
  const RecipesSelectionToggled();
}

final class RecipesSelectedGroupChanged extends RecipesEvent {
  const RecipesSelectedGroupChanged(this.group);

  final FRGroup? group;

  @override
  List<Object?> get props => [group];
}

final class RecipesToggleRecipeSelection extends RecipesEvent {
  const RecipesToggleRecipeSelection(this.recipeId);

  final String recipeId;

  @override
  List<Object?> get props => [recipeId];
}
