import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/widgets/select/select_controller.dart';
import 'package:recipes_flutter/app/common/widgets/select/select_modal.dart';

class FRSelect<T> extends StatelessWidget {
  final List<T> items;
  final List<T> value;
  final String Function(T) itemLabelBuilder;
  final void Function(List<T>) onChanged;
  final Future<T> Function(String)? createItem;
  final bool isMulti;
  final String label;
  const FRSelect({
    super.key,
    required this.items,
    required this.value,
    required this.itemLabelBuilder,
    required this.onChanged,
    required this.isMulti,
    required this.label,
    this.createItem,
  });

  void afterInit(SelectController<T> controller) {
    controller.items.assignAll(items);
  }

  @override
  Widget build(BuildContext context) {
    log(items.length.toString(), name: 'FRSelect<$T>');
    final controller = Get.put(
      SelectController<T>(
        itemLabelBuilder: itemLabelBuilder,
        items: items.obs,
        initialSelectedItems: value,
        label: label,
        onChanged: onChanged,
        createItem: createItem,
        isMulti: isMulti,
      ),
      tag: 'FRSelect_$key',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterInit(controller);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SizedBox(height: 55, width: double.infinity),
            Positioned(
              top: 4,
              height: 48,
              child: Material(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Get.theme.colorScheme.surfaceContainer,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    controller.filterController.clear();
                    Get.dialog(
                      SelectModal(controller: controller),
                      useSafeArea: false,
                    );
                  },
                  child: Builder(
                    builder: (context) {
                      return Container(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          maxWidth: constraints.maxWidth,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Obx(
                          () => Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            controller.selectedItems
                                .map((e) => controller.itemLabelBuilder(e))
                                .join(', '),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              child: Obx(
                () => Visibility(
                  visible: controller.selectedItems.isEmpty,
                  child: IgnorePointer(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Get.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: -5,
              child: Obx(
                () => Visibility(
                  visible: controller.selectedItems.isNotEmpty,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
