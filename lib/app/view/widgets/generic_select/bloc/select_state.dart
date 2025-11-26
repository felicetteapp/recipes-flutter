part of 'select_cubit.dart';

class GenericSelectState<T> extends Equatable {
  const GenericSelectState({
    this.selectedItemIds = const [],
    this.filteredItems = const [],
    this.textFilter = '',
  });

  final List<String> selectedItemIds;
  final String textFilter;
  final List<T> filteredItems;

  GenericSelectState<T> copyWith({
    List<String>? selectedItemIds,
    String? textFilter,
    List<T>? filteredItems,
  }) {
    return GenericSelectState<T>(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      textFilter: textFilter ?? this.textFilter,
      filteredItems: filteredItems ?? this.filteredItems,
    );
  }

  GenericSelectState<T> clearSelection() {
    return const GenericSelectState();
  }

  @override
  List<Object?> get props => [
    selectedItemIds,
    textFilter,
    filteredItems,
  ];
}
