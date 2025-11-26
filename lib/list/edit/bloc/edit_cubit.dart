import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'edit_state.dart';

class EditListCubit extends Cubit<EditListState> {
  EditListCubit() : super(const EditListState());

  void handleGroupChanged(FRGroup? group) {
    emit(
      state.copyWith(
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
}
