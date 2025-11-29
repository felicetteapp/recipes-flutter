import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

part 'edit_state.dart';

class EditIngredientCubit extends Cubit<EditIngredientState> {
  EditIngredientCubit({required IngredientRepository ingredientRepository})
    : _ingredientRepository = ingredientRepository,
      super(const EditIngredientState());

  final IngredientRepository _ingredientRepository;

  void ingredientNameChanged(String value) {
    final ingredientName = IngredientName.dirty(value);
    emit(
      state.copyWith(
        ingredientName: ingredientName,
        isValid: Formz.validate([ingredientName]),
      ),
    );
  }

  void loadIngredient(String groupId, FRIngredient? ingredient) {
    final ingredientName = IngredientName.dirty(ingredient?.name ?? '');
    emit(
      state.copyWith(
        ingredient: ingredient,
        ingredientName: ingredientName,
        isValid: Formz.validate([ingredientName]),
        isActualIngredient: ingredient?.actualIngredient ?? false,
        groupId: groupId,
      ),
    );
  }

  void ingredientIsActualIngredientChanged({required bool isActualIngredient}) {
    final novoStado = state.copyWith(
      isActualIngredient: isActualIngredient,
    );

    log(
      'novoStado $novoStado',
      name: 'EditIngredientCubit.ingredientIsActualIngredientChanged',
    );
    emit(novoStado);
  }

  Future<void> saveIngredient() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _ingredientRepository.updateIngredient(
        state.groupId,
        state.ingredient!.copyWith(
          name: state.ingredientName.value,
          actualIngredient: state.isActualIngredient,
        ),
      );

      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> excludeIngredient() async {
    emit(state.copyWith(removeStatus: FormzSubmissionStatus.inProgress));
    try {
      await _ingredientRepository.deleteIngredient(
        state.groupId,
        state.ingredient!,
      );

      if (isClosed) {
        return;
      }

      //      throw Exception('Simulated delete error');
      emit(state.copyWith(removeStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          removeStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
