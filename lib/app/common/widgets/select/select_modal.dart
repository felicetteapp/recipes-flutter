import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/common/widgets/select/select_controller.dart';

class SelectModal<T> extends StatelessWidget {
  final SelectController<T> controller;
  const SelectModal({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.label)),
      extendBodyBehindAppBar: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: controller.isMulti,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  controller: controller.selectedItemsScrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...controller.selectedItems.map(
                            (val) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                              child: Chip(
                                key: ValueKey(controller.itemLabelBuilder(val)),
                                padding: EdgeInsets.all(0),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                label: Text(controller.itemLabelBuilder(val)),
                                onDeleted: () {
                                  final newValue = List<T>.from(
                                    controller.selectedItems,
                                  );
                                  newValue.remove(val);
                                  controller.selectedItems.value = newValue;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              focusNode: controller.filterControllerFocusNode,
              decoration: InputDecoration(labelText: TranslationKeys.search.tr),
              controller: controller.filterController,
              textInputAction: TextInputAction.done,
              onSubmitted: controller.onSubmitted,
            ),
          ),
          Expanded(
            child: Obx(() {
              var itemCount = controller.filteredItems.length;
              final createItemVisible =
                  controller.filter.value.isNotEmpty &&
                  controller.createItem != null;

              if (createItemVisible) {
                itemCount++;
              }

              return ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (createItemVisible && index == itemCount - 1) {
                    return ListTile(
                      title: Text(
                        '${TranslationKeys.create.tr} "${controller.filter.value}"',
                      ),
                      leading: Icon(Icons.add),
                      onTap: () async {
                        controller.handleCreateItem();
                      },
                    );
                  }

                  final item = controller.filteredItems[index];

                  return ListTile(
                    selected:
                        !controller.isMulti &&
                        controller.selectedItems.contains(item),
                    key: ValueKey(controller.itemLabelBuilder(item)),
                    title: Text(controller.itemLabelBuilder(item)),
                    onTap: () {
                      controller.handleSelect(item);
                    },
                  );
                },
              );
            }),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: Get.mediaQuery.padding.bottom,
                left: 16,
                right: 16,
                top: 8,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(TranslationKeys.done.tr),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
