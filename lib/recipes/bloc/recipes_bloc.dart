import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  RecipesBloc() : super(const RecipesState()) {
    on<RecipesSelectionToggled>(_onSelectionToggled);
  }

  void _onSelectionToggled(
    RecipesSelectionToggled event,
    Emitter<RecipesState> emit,
  ) {
    emit(state.copyWith(isSelecting: !state.isSelecting));
  }
}
