import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/list/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(const ListState()) {
    on<ListDisplayTypeChanged>(_onListDisplayTypeChanged);
  }

  void _onListDisplayTypeChanged(
    ListDisplayTypeChanged event,
    Emitter<ListState> emit,
  ) {
    emit(ListState(displayType: event.displayType));
  }
}
