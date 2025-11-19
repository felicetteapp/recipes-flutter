part of 'list_bloc.dart';

sealed class ListEvent {
  const ListEvent();
}

final class ListDisplayTypeChanged extends ListEvent {
  const ListDisplayTypeChanged(this.displayType);

  final ListDisplayTypeEnum displayType;
}
