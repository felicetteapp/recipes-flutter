import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'select_state.dart';

class GenericSelectCubit<T> extends Cubit<GenericSelectState<T>> {
  GenericSelectCubit({
    this.allowCreation = false,
    this.createItem,
    this.onChanged,
    this.isMulti = false,
    this.getId,
    this.filterPredicate,
    GenericSelectState<T>? initialValue,
  }) : _items = [],
       super(initialValue ?? const GenericSelectState());

  final List<T> _items;
  final bool allowCreation;
  final Future<T> Function({required String name})? createItem;
  final ValueChanged<List<String>>? onChanged;
  final bool isMulti;
  final String Function(T item)? getId;
  final bool Function(T item, String filter)? filterPredicate;

  List<T> get selectedItems => _items
      .where(
        (item) => state.selectedItemIds.contains(getId?.call(item)),
      )
      .toList();

  List<T> get items => _items;

  void clearSelection() {
    emit(state.clearSelection());
  }

  void initItems(List<T> items) {
    _items
      ..clear()
      ..addAll(items);
    emit(
      state.copyWith(
        filteredItems: items,
      ),
    );
  }

  void filterChange(String filter) {
    final newFiltered = _items.where(
      (item) {
        if (filter.isEmpty) {
          return true;
        }
        if (filterPredicate != null) {
          return filterPredicate!(item, filter);
        }
        return true;
      },
    ).toList();

    emit(
      state.copyWith(textFilter: filter, filteredItems: newFiltered),
    );
  }

  void selectItem(String itemId) {
    if (!isMulti) {
      emit(
        state.copyWith(selectedItemIds: [itemId]),
      );
      if (onChanged != null) {
        onChanged?.call([itemId]);
      }
      return;
    }

    final isSelected = state.selectedItemIds.contains(itemId);
    final updatedSelectedIds = List<String>.from(
      state.selectedItemIds,
    );
    if (isSelected) {
      updatedSelectedIds.remove(itemId);
    } else {
      updatedSelectedIds.add(itemId);
    }
    emit(
      state.copyWith(selectedItemIds: updatedSelectedIds),
    );
    if (onChanged != null) {
      onChanged?.call(updatedSelectedIds);
    }
  }
}
