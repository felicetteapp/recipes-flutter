part of 'list_bloc.dart';

sealed class ListEvent {
  const ListEvent();
}

final class ListDisplayTypeChanged extends ListEvent {
  const ListDisplayTypeChanged(this.displayType);

  final ListDisplayTypeEnum displayType;
}

final class ListSelectedGroupChanged extends ListEvent {
  const ListSelectedGroupChanged(this.selectedGroup);

  final FRGroup? selectedGroup;
}

final class UpdateGroupRecipes extends ListEvent {
  const UpdateGroupRecipes(this.recipes);

  final List<FRRecipe> recipes;
}

final class UpdateGroupIngredients extends ListEvent {
  const UpdateGroupIngredients(this.ingredients);

  final List<FRIngredient> ingredients;
}

final class UpdateCurrentGroupIngredients extends ListEvent {
  const UpdateCurrentGroupIngredients();
}
