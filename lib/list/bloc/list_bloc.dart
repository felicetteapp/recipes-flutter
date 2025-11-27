import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/list/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc({
    required GroupRepository groupRepository,
  }) : _groupRepository = groupRepository,
       super(const ListState()) {
    on<ListDisplayTypeChanged>(_onListDisplayTypeChanged);
    on<ListSelectedGroupChanged>(_onListSelectedGroupChanged);
    on<UpdateGroupIngredients>(_onGroupIngredientsUpdated);
    on<UpdateGroupRecipes>(_onGroupRecipesUpdated);
    on<UpdateCurrentGroupIngredients>(_onUpdateCurrentGroupIngredients);
    on<UpdateCurrentGroupIngredientPrices>(
      _onUpdateCurrentGroupIngredientPrices,
    );
    on<ListCurrentCheckedIngredientsChanged>(
      _onListCurrentCheckedIngredientsChanged,
    );
    on<ListShowBudgetChanged>(
      _onListShowBudgetChanged,
    );
    on<ListShowCheckedsFirstChanged>(
      _onListShowCheckedsFirstChanged,
    );
    on<ToggleShowCheckedsFirst>(
      _onToggleShowCheckedsFirst,
    );
    on<ToggleShowBudget>(
      _onToggleShowBudget,
    );
    on<ToggleIngredientCheckedStatus>(
      _onToggleIngredientCheckedStatus,
    );
    on<UpdateIngredientPrices>(
      _onUpdateIngredientPrices,
    );
    on<ClearAllChecked>(
      _onClearAllChecked,
    );
    on<AddIngredientsToList>(
      _onAddIngredientsToList,
    );
  }

  final GroupRepository _groupRepository;

  void _onToggleShowCheckedsFirst(
    ToggleShowCheckedsFirst event,
    Emitter<ListState> emit,
  ) {
    final currentShowCheckedsFirst = state.showCheckedsFirst;

    if (state.selectedGroup == null) return;

    _groupRepository.updateSelectedGroupFilters(
      state.selectedGroup!.id,
      filters: state.selectedGroup!.filters.copyWith(
        showCheckedsFirst: !currentShowCheckedsFirst,
      ),
    );
  }

  void _onToggleShowBudget(
    ToggleShowBudget event,
    Emitter<ListState> emit,
  ) {
    final currentShowBudget = state.showBudget;

    if (state.selectedGroup == null) return;

    _groupRepository.updateSelectedGroupFilters(
      state.selectedGroup!.id,
      filters: state.selectedGroup!.filters.copyWith(
        showBudget: !currentShowBudget,
      ),
    );
  }

  void _onListDisplayTypeChanged(
    ListDisplayTypeChanged event,
    Emitter<ListState> emit,
  ) {
    emit(
      state.copyWith(
        displayType: event.displayType,
      ),
    );
    add(const UpdateCurrentGroupIngredients());
  }

  void _onListSelectedGroupChanged(
    ListSelectedGroupChanged event,
    Emitter<ListState> emit,
  ) {
    log('Selected group changed: ${event.selectedGroup}', name: 'ListBloc');
    emit(
      state.copyWith(
        currentIngredientIds: event.selectedGroup?.currentIngredients ?? [],
        currentRecipesIds: event.selectedGroup?.currentRecipes ?? [],
        currentRecipes: state.groupRecipes.where((recipe) {
          return event.selectedGroup?.currentRecipes.contains(recipe.id) ??
              false;
        }).toList(),
        selectedGroup: event.selectedGroup,
        currentListBudget: event.selectedGroup?.budget ?? 0,
      ),
    );
    add(const UpdateCurrentGroupIngredients());
  }

  void _onGroupIngredientsUpdated(
    UpdateGroupIngredients event,
    Emitter<ListState> emit,
  ) {
    log('Updating group ingredients: ${event.ingredients}', name: 'ListBloc');
    emit(
      state.copyWith(
        groupIngredients: event.ingredients,
      ),
    );

    add(const UpdateCurrentGroupIngredients());
  }

  void _onGroupRecipesUpdated(
    UpdateGroupRecipes event,
    Emitter<ListState> emit,
  ) {
    log('Updating group recipes: ${event.recipes}', name: 'ListBloc');
    emit(
      state.copyWith(
        groupRecipes: event.recipes,
        currentRecipes: event.recipes.where((recipe) {
          return state.currentRecipesIds.contains(recipe.id);
        }).toList(),
      ),
    );

    add(const UpdateCurrentGroupIngredients());
  }

  void _onUpdateCurrentGroupIngredientPrices(
    UpdateCurrentGroupIngredientPrices event,
    Emitter<ListState> emit,
  ) {
    log('Updating current group ingredient prices', name: 'ListBloc');
    emit(
      state.copyWith(
        currentIngredientPrices: event.prices,
      ),
    );
    add(const UpdateCurrentGroupIngredients());
  }

  void _onListCurrentCheckedIngredientsChanged(
    ListCurrentCheckedIngredientsChanged event,
    Emitter<ListState> emit,
  ) {
    log(
      'Updating current checked ingredients: ${event.checkedIngredientIds}',
      name: 'ListBloc',
    );
    emit(
      state.copyWith(
        currentCheckedIngredients: event.checkedIngredientIds,
      ),
    );
    add(const UpdateCurrentGroupIngredients());
  }

  void _onListShowBudgetChanged(
    ListShowBudgetChanged event,
    Emitter<ListState> emit,
  ) {
    log('Updating show budget: ${event.showBudget}', name: 'ListBloc');
    emit(
      state.copyWith(
        showBudget: event.showBudget,
      ),
    );
    add(const UpdateCurrentGroupIngredients());
  }

  void _onListShowCheckedsFirstChanged(
    ListShowCheckedsFirstChanged event,
    Emitter<ListState> emit,
  ) {
    log(
      'Updating show checkeds first: ${event.showCheckedsFirst}',
      name: 'ListBloc',
    );
    emit(
      state.copyWith(
        showCheckedsFirst: event.showCheckedsFirst,
      ),
    );
    add(const UpdateCurrentGroupIngredients());
  }

  void _onUpdateIngredientPrices(
    UpdateIngredientPrices event,
    Emitter<ListState> emit,
  ) {
    log(
      'Updating ingredient: ${event.ingredientId} with prices: ${event.prices}',
      name: 'ListBloc.UpdateIngredientPrices',
    );

    if (state.selectedGroup == null) return;

    _groupRepository.updateIngredientPrices(
      state.selectedGroup!.id,
      event.ingredientId,
      event.prices,
    );
  }

  void _onToggleIngredientCheckedStatus(
    ToggleIngredientCheckedStatus event,
    Emitter<ListState> emit,
  ) {
    log(
      'Toggling checked status for ingredient: ${event.ingredientId}',
      name: 'ListBloc.ToggleIngredientCheckedStatus',
    );

    if (state.selectedGroup == null) return;

    final isCurrentlyChecked = state.currentCheckedIngredients.contains(
      event.ingredientId,
    );

    if (isCurrentlyChecked) {
      log(
        'Removing checked ingredient',
        name: 'ListBloc.ToggleIngredientCheckedStatus',
      );
      _groupRepository.removeCheckedIngredientFromGroup(
        state.selectedGroup!.id,
        event.ingredientId,
      );
    } else {
      log(
        'Adding checked ingredient',
        name: 'ListBloc.ToggleIngredientCheckedStatus',
      );
      _groupRepository.addCheckedIngredientToGroup(
        state.selectedGroup!.id,
        event.ingredientId,
      );
    }
  }

  void _onClearAllChecked(
    ClearAllChecked event,
    Emitter<ListState> emit,
  ) {
    log(
      'Clearing all checked ingredients',
      name: 'ListBloc.ClearAllChecked',
    );

    if (state.selectedGroup == null) return;

    _groupRepository.clearAllCheckedIngredientsFromGroup(
      state.selectedGroup!.id,
    );
  }

  void _onUpdateCurrentGroupIngredients(
    UpdateCurrentGroupIngredients event,
    Emitter<ListState> emit,
  ) {
    log('Updating current group ingredients', name: 'ListBloc');
    final currentIngredientIds = state.currentIngredientIds;
    final groupIngredients = state.groupIngredients;
    final currentRecipes = state.currentRecipes
      ..sort(
        (a, b) => a.name.normalizeForSearch().compareTo(
          b.name.normalizeForSearch(),
        ),
      );
    final currentCheckedIngredients = state.currentCheckedIngredients;
    final currentIngredientPrices = state.currentIngredientPrices;
    final showCheckedsFirst = state.showCheckedsFirst;

    final currentIngredients = <ListIngredientItem>[];

    for (final current in currentIngredientIds) {
      final ingredient = groupIngredients.firstWhereOrNull((ing) {
        return ing.id == current.ingredientId;
      });

      if (ingredient != null) {
        currentIngredients.add(
          ListIngredientItem(
            ingredient: ingredient,
            quantity: current.quantity,
            associatedRecipes: List.empty(growable: true),
            isChecked: currentCheckedIngredients.contains(ingredient.id),
            prices: currentIngredientPrices[ingredient.id] ?? [],
          ),
        );
      }
    }

    for (final recipe in currentRecipes) {
      for (final recipeIngredient in recipe.ingredients) {
        final alreadyExists = currentIngredients.any((item) {
          return item.ingredient.id == recipeIngredient.ingredientId;
        });
        if (!alreadyExists) {
          final ingredient = groupIngredients.firstWhereOrNull((ing) {
            return ing.id == recipeIngredient.ingredientId;
          });
          if (ingredient != null) {
            currentIngredients.add(
              ListIngredientItem(
                ingredient: ingredient,
                quantity: recipeIngredient.quantity,
                associatedRecipes: List.empty(growable: true),
                isChecked: currentCheckedIngredients.contains(ingredient.id),
                prices: currentIngredientPrices[ingredient.id] ?? [],
              ),
            );
          }
        }
      }
    }

    for (final item in currentIngredients) {
      final associatedRecipes = currentRecipes.where((recipe) {
        return recipe.ingredients.any((recipeIngredient) {
          return recipeIngredient.ingredientId == item.ingredient.id;
        });
      }).toList();
      item.associatedRecipes.addAll(associatedRecipes);
    }

    final listItems = <ListPageListItem>[];

    if (state.displayType == ListDisplayTypeEnum.ingredients) {
      for (final ingredientItem in currentIngredients) {
        listItems
          ..add(
            ListPageListItem(
              type: ListPageListItemTypeEnum.ingredient,
              ingredientItem: ingredientItem,
            ),
          )
          ..sort(
            (a, b) {
              if (showCheckedsFirst) {
                if (a.ingredientItem!.isChecked &&
                    !b.ingredientItem!.isChecked) {
                  return -1;
                } else if (!a.ingredientItem!.isChecked &&
                    b.ingredientItem!.isChecked) {
                  return 1;
                }
              }
              return a.ingredientItem!.ingredient.name
                  .normalizeForSearch()
                  .compareTo(
                    b.ingredientItem!.ingredient.name.normalizeForSearch(),
                  );
            },
          );
      }
    } else {
      for (final recipe in currentRecipes) {
        listItems.add(
          ListPageListItem(
            type: ListPageListItemTypeEnum.recipe,
            recipeItem: ListRecipeItem(recipe: recipe),
          ),
        );
        for (final recipeIngredient in recipe.ingredients) {
          final ingredientItem = currentIngredients.firstWhereOrNull((item) {
            return item.ingredient.id == recipeIngredient.ingredientId;
          });
          if (ingredientItem != null) {
            listItems.add(
              ListPageListItem(
                type: ListPageListItemTypeEnum.ingredient,
                ingredientItem: ingredientItem,
                recipeItem: ListRecipeItem(recipe: recipe),
              ),
            );
          }
        }
      }

      final ingredientsWithoutRecipe = currentIngredientIds.where((current) {
        final isInAnyRecipe = currentRecipes.any((recipe) {
          return recipe.ingredients.any((recipeIngredient) {
            return recipeIngredient.ingredientId == current.ingredientId;
          });
        });
        return !isInAnyRecipe;
      }).toList();

      log(
        'Ingredients without recipe: $ingredientsWithoutRecipe',
        name: 'ListBloc',
      );

      if (ingredientsWithoutRecipe.isNotEmpty) {
        log(
          'Adding separator for ingredients without recipe',
          name: 'ListBloc',
        );
        listItems.add(
          ListPageListItem(
            type: ListPageListItemTypeEnum.recipe,
            recipeItem: ListRecipeItem.withoutRecipe,
          ),
        );
      }

      for (final current in ingredientsWithoutRecipe) {
        final ingredientItem = currentIngredients.firstWhereOrNull((item) {
          return item.ingredient.id == current.ingredientId;
        });
        if (ingredientItem != null) {
          listItems.add(
            ListPageListItem(
              type: ListPageListItemTypeEnum.ingredient,
              ingredientItem: ingredientItem,
            ),
          );
        }
      }
    }

    emit(
      state.copyWith(
        currentIngredients: currentIngredients,
        listItems: listItems,
        currentListSpentBudget: currentIngredientPrices.entries.fold(0, (
          previousValue,
          priceEntry,
        ) {
          final ingredientId = priceEntry.key;
          if (!currentCheckedIngredients.contains(ingredientId)) {
            return previousValue;
          }

          return previousValue! +
              priceEntry.value.fold(
                0,
                (prev, price) => prev + price.quantity * price.unitPrice,
              );
        }),
      ),
    );
  }

  Future<void> _onAddIngredientsToList(
    AddIngredientsToList event,
    Emitter<ListState> emit,
  ) async {
    if (state.selectedGroup == null) return;

    emit(
      state.copyWith(
        addIngredientStatus: FormzSubmissionStatus.inProgress,
        addIngredientError: AddIngredientError.none,
      ),
    );

    try {
      final ingredientAlreadyAtList = state.selectedGroup!.currentIngredients
          .any(
            (current) => event.ingredients.any(
              (newIng) => newIng.ingredientId == current.ingredientId,
            ),
          );

      if (ingredientAlreadyAtList) {
        emit(
          state.copyWith(
            addIngredientStatus: FormzSubmissionStatus.failure,
            addIngredientError: AddIngredientError.alreadyInList,
          ),
        );
        return;
      }

      await _groupRepository.addIngredientsToGroup(
        state.selectedGroup!.id,
        event.ingredients,
      );

      emit(
        state.copyWith(
          addIngredientStatus: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addIngredientStatus: FormzSubmissionStatus.failure,
          addIngredientError: AddIngredientError.unknown,
        ),
      );
    }
  }
}
