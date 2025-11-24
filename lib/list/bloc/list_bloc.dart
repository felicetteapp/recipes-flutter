import 'dart:developer';
import 'dart:math' hide log;

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/list/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(const ListState()) {
    on<ListDisplayTypeChanged>(_onListDisplayTypeChanged);
    on<ListSelectedGroupChanged>(_onListSelectedGroupChanged);
    on<UpdateGroupIngredients>(_onGroupIngredientsUpdated);
    on<UpdateGroupRecipes>(_onGroupRecipesUpdated);
    on<UpdateCurrentGroupIngredients>(_onUpdateCurrentGroupIngredients);
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

  void _onUpdateCurrentGroupIngredients(
    UpdateCurrentGroupIngredients event,
    Emitter<ListState> emit,
  ) {
    log('Updating current group ingredients', name: 'ListBloc');
    final currentIngredientIds = state.currentIngredientIds;
    final groupIngredients = state.groupIngredients;
    final groupRecipes = state.groupRecipes;
    final currentRecipes = state.currentRecipes;

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
            //  isChecked: false, // TODO: implement checked state
            isChecked: Random().nextBool(),
            prices: [], // TODO: implement prices
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
                // isChecked: false, // TODO: implement checked state
                isChecked: Random().nextBool(),
                prices: [], // TODO: implement prices
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

    emit(
      state.copyWith(
        currentIngredients: currentIngredients,
      ),
    );
  }
}
