import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

part 'ingredients_event.dart';
part 'ingredients_state.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  IngredientsBloc({
    required IngredientRepository ingredientRepository,
  }) : _ingredientRepository = ingredientRepository,
       super(const IngredientsState()) {
    on<IngredientSelectedGroupChanged>(_onIngredientsSelectedGroupChanged);
  }

  final IngredientRepository _ingredientRepository;

  Future<void> _onIngredientsSelectedGroupChanged(
    IngredientSelectedGroupChanged event,
    Emitter<IngredientsState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedGroupId: event.group?.id,
        selectedGroupCurrentListIngredient:
            event.group?.currentIngredients ?? [],
      ),
    );

    if (event.group == null) {
      emit(state.copyWith(ingredients: const []));
      return;
    }

    await emit.onEach<List<FRIngredient>>(
      _ingredientRepository.listenToIngredients(event.group!.id),
      onData: (ingredients) {
        emit(state.copyWith(ingredients: ingredients));
      },
      onError: addError,
    );
  }
}
