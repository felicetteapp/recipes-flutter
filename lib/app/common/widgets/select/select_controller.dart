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
  final bool isMulti;
  final Function(List<T>) onChanged;
  final Future<T> Function(String)? createItem;

  List<T> get filteredItems {
    var currentList = items.toList();
    if (isMulti) {
      currentList =
          currentList.where((item) => !selectedItems.contains(item)).toList();
    } else {
      currentList = currentList.toList();
      currentList.removeWhere((item) => selectedItems.contains(item));
      currentList.insertAll(0, selectedItems);
    }

    currentList =
        currentList
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
    required this.isMulti,
    this.createItem,
    List<T> initialSelectedItems = const [],
  }) : selectedItems = RxList<T>(initialSelectedItems);

  handleCreateItem() async {
    if (createItem != null) {
      final newItem = await createItem!(filter.value);
      if (newItem != null) {
        items.add(newItem);
        handleSelect(newItem);
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
        handleSelect(filteredItems.first);
      }
    } else {
      handleCreateItem();

      log('No items match the filter', name: 'SelectController');
    }
  }

  void handleSelect(T item) {
    if (!isMulti) {
      selectedItems.value = [item];
      onChanged(selectedItems);
      filterController.clear();
      Get.back();
      return;
    }
    selectedItems.add(item);
    filterController.clear();
    scrollToLastSelectedItem();
    filterControllerFocusNode.requestFocus();
  }

  void scrollToLastSelectedItem() {
    if (!isMulti) return;
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
