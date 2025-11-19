part of 'recipes_bloc.dart';

class RecipesState extends Equatable {
  const RecipesState({
    this.isSelecting = false,
  });
  final bool isSelecting;

  RecipesState copyWith({
    bool? isSelecting,
  }) {
    return RecipesState(
      isSelecting: isSelecting ?? this.isSelecting,
    );
  }

  @override
  List<Object> get props => [isSelecting];
}
