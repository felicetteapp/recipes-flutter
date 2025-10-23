import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectController<T> extends GetxController {
  final RxList<T> items;
  final RxList<T> selectedItems;
  final RxString filter = ''.obs;
  final String Function(T) itemLabelBuilder;
  final TextEditingController filterController = TextEditingController();
  final filterControllerFocusNode = FocusNode();
  final ScrollController selectedItemsScrollController = ScrollController();
  final String label;
  final Function(List<T>) onChanged;
  final Future<T> Function(String)? createItem;

  List<T> get filteredItems {
    final currentList =
        items
            .where((item) => !selectedItems.contains(item))
            .where(
              (item) => itemLabelBuilder(
                item,
              ).toLowerCase().contains(filter.value.toLowerCase()),
            )
            .toList();

    return currentList;
  }

  SelectController({
    required this.itemLabelBuilder,
    required this.items,
    required this.label,
    required this.onChanged,
    this.createItem,
    List<T> initialSelectedItems = const [],
  }) : selectedItems = RxList<T>(initialSelectedItems);

  handleCreateItem() async {
    if (createItem != null) {
      final newItem = await createItem!(filter.value);
      if (newItem != null) {
        items.add(newItem);
        final newValue = List<T>.from(selectedItems);
        newValue.add(newItem);
        selectedItems.value = newValue;
        filterController.clear();
        scrollToLastSelectedItem();
      }
    }
  }

  Future<void> onSubmitted(value) async {
    log('Filter submitted: $value', name: 'SelectController');
    if (filteredItems.isNotEmpty) {
      log(
        'First filtered item: ${itemLabelBuilder(filteredItems.first)} - ${filteredItems.first}',
        name: 'SelectController',
      );

      final newValue = List<T>.from(selectedItems);
      if (!newValue.contains(filteredItems.first)) {
        newValue.add(filteredItems.first);
        selectedItems.value = newValue;
        filterController.clear();
        scrollToLastSelectedItem();

        filterControllerFocusNode.requestFocus();
      }
    } else {
      handleCreateItem();

      log('No items match the filter', name: 'SelectController');
    }
  }

  void scrollToLastSelectedItem() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      selectedItemsScrollController.animateTo(
        selectedItemsScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
    log('SelectController initialized', name: 'SelectController');

    filterController.addListener(() {
      filter.value = filterController.text;
    });

    selectedItems.listen((selected) {
      log(
        'Selected items changed: ${selected.map(itemLabelBuilder).join(', ')}',
        name: 'SelectController',
      );
      onChanged(selected);
    });
  }

  @override
  void onClose() {
    log('SelectController closed', name: 'SelectController');
    super.onClose();
  }
}
