import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

part 'new_state.dart';

class NewIngredientCubit extends Cubit<NewIngredientState> {
  NewIngredientCubit({required IngredientRepository ingredientRepository})
    : _ingredientRepository = ingredientRepository,
      super(const NewIngredientState());

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

  void defineGroupId(String groupId) {
    emit(
      state.copyWith(
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

  Future<void> createIngredient() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _ingredientRepository.createIngredient(
        state.groupId,
        FRIngredient(
          id: '',
          name: state.ingredientName.value,
          actualIngredient: state.isActualIngredient,
        ),
      );

      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      log(
        'Error creating ingredient: $e',
        name: 'NewIngredientCubit.createIngredient',
      );
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
