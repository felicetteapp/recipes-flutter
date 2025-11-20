import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  RecipesBloc({
    required RecipeRepository recipeRepository,
  }) : _recipeRepository = recipeRepository,
       super(const RecipesState()) {
    on<RecipesSelectionToggled>(_onSelectionToggled);
    on<RecipesSelectedGroupChanged>(_onIngredientsSelectedGroupChanged);
    on<RecipesToggleRecipeSelection>(_onRecipeSelectionToggled);
  }

  final RecipeRepository _recipeRepository;

  void _onSelectionToggled(
    RecipesSelectionToggled event,
    Emitter<RecipesState> emit,
  ) {
    final newIsSelecting = !state.isSelecting;
    emit(
      state.copyWith(
        isSelecting: newIsSelecting,
        selectedRecipeIds: newIsSelecting
            ? state.selectedRecipeIds
            : state.selectedGroupCurrentListRecipeIds,
      ),
    );
  }

  Future<void> _onIngredientsSelectedGroupChanged(
    RecipesSelectedGroupChanged event,
    Emitter<RecipesState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedGroupId: event.group?.id,
        selectedGroupCurrentListRecipeIds: event.group?.currentRecipes ?? [],
        selectedRecipeIds: event.group == null ? [] : state.selectedRecipeIds,
      ),
    );

    if (event.group == null) {
      emit(
        state.copyWith(
          selectedGroupCurrentListRecipeIds: const [],
          selectedRecipeIds: const [],
          recipes: const [],
        ),
      );
      return;
    }

    await emit.onEach<List<FRRecipe>>(
      _recipeRepository.listenToRecipes(event.group!.id),
      onData: (recipes) {
        emit(state.copyWith(recipes: recipes));
      },
      onError: addError,
    );
  }

  void _onRecipeSelectionToggled(
    RecipesToggleRecipeSelection event,
    Emitter<RecipesState> emit,
  ) {
    final selectedRecipeIds = List<String>.from(state.selectedRecipeIds);
    if (selectedRecipeIds.contains(event.recipeId)) {
      selectedRecipeIds.remove(event.recipeId);
    } else {
      selectedRecipeIds.add(event.recipeId);
    }
    emit(state.copyWith(selectedRecipeIds: selectedRecipeIds));
  }
}
