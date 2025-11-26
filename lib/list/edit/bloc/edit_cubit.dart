import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'edit_state.dart';

class EditListCubit extends Cubit<EditListState> {
  EditListCubit({
    required GroupRepository groupRepository,
  }) : _groupRepository = groupRepository,
       super(const EditListState());

  final GroupRepository _groupRepository;

  void handleGroupChanged(FRGroup? group) {
    emit(
      state.copyWith(
        currentGroup: group,
        budget: group?.budget ?? 0.0,
        currency: group?.currency ?? '',
        currentIngredients: group?.currentIngredients ?? [],
        currentRecipes: group?.currentRecipes ?? [],
      ),
    );
  }

  void handleIngredientsChanged(List<FRIngredient> ingredients) {
    emit(
      state.copyWith(
        groupIngredients: ingredients,
      ),
    );
  }

  void handleRecipesChanged(List<FRRecipe> recipes) {
    emit(
      state.copyWith(
        groupRecipes: recipes,
      ),
    );
  }

  void handleBudgetChanged(
    double budget,
  ) {
    emit(
      state.copyWith(
        budget: budget,
      ),
    );
  }

  void handleCurrentIngredientsChanged(
    List<FRCurrentIngredients> currentIngredients,
  ) {
    log(
      'handleCurrentIngredientsChanged: $currentIngredients',
      name: 'EditListCubit.handleCurrentIngredientsChanged',
    );
    emit(
      state.copyWith(
        currentIngredients: currentIngredients,
      ),
    );
  }

  void handleCurrentRecipesChanged(
    List<String> currentRecipes,
  ) {
    log(
      'handleCurrentRecipesChanged: $currentRecipes',
      name: 'EditListCubit.handleCurrentRecipesChanged',
    );
    emit(
      state.copyWith(
        currentRecipes: currentRecipes,
      ),
    );
  }

  Future<void> saveChanges() async {
    await _groupRepository.updateList(
      state.currentGroup!.id,
      state.currentGroup!.copyWith(
        budget: state.budget,
        currency: state.currency,
        currentIngredients: state.currentIngredients,
        currentRecipes: state.currentRecipes,
      ),
    );
  }
}
