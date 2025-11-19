part of 'list_bloc.dart';

class ListState extends Equatable {
  const ListState({
    this.displayType = ListDisplayTypeEnum.ingredients,
  });

  final ListDisplayTypeEnum displayType;

  ListState copyWith({
    ListDisplayTypeEnum? displayType,
  }) {
    return ListState(
      displayType: displayType ?? this.displayType,
    );
  }

  @override
  List<Object?> get props => [displayType];
}
