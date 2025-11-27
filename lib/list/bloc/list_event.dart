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

final class UpdateCurrentGroupIngredientPrices extends ListEvent {
  const UpdateCurrentGroupIngredientPrices(this.prices);

  final Map<String, List<FRIngredientPrice>> prices;
}

final class ListCurrentCheckedIngredientsChanged extends ListEvent {
  const ListCurrentCheckedIngredientsChanged(this.checkedIngredientIds);

  final List<String> checkedIngredientIds;
}

final class ListShowBudgetChanged extends ListEvent {
  const ListShowBudgetChanged({required this.showBudget});

  final bool showBudget;
}

final class ListShowCheckedsFirstChanged extends ListEvent {
  const ListShowCheckedsFirstChanged({required this.showCheckedsFirst});

  final bool showCheckedsFirst;
}

final class ToggleShowCheckedsFirst extends ListEvent {
  const ToggleShowCheckedsFirst();
}

final class ToggleShowBudget extends ListEvent {
  const ToggleShowBudget();
}

final class ToggleIngredientCheckedStatus extends ListEvent {
  const ToggleIngredientCheckedStatus(this.ingredientId);

  final String ingredientId;
}

final class UpdateIngredientPrices extends ListEvent {
  const UpdateIngredientPrices(this.ingredientId, this.prices);

  final String ingredientId;
  final List<FRIngredientPrice> prices;
}

final class ClearAllChecked extends ListEvent {
  const ClearAllChecked();
}
