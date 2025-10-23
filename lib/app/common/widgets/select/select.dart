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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SelectController<T>(
        itemLabelBuilder: itemLabelBuilder,
        items: items.obs,
        initialSelectedItems: value,
        label: label,
        onChanged: onChanged,
        createItem: createItem,
      ),
    );

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Get.theme.colorScheme.surfaceContainer,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Get.dialog(
                        SelectModal(controller: controller),
                        useSafeArea: false,
                      );
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 42,
                        minWidth: constraints.maxWidth,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
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
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 1.5,
          top: 10,
          child: Obx(
            () => Visibility(
              visible: controller.selectedItems.isEmpty,
              child: IgnorePointer(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
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
          top: -4,
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
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
