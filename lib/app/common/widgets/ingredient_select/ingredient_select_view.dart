import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/widgets/ingredient_select/ingredient_select_modal_view.dart';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/data/models/recipe_models.dart';

import 'ingredient_select_controller.dart';

class IngredientSelect extends StatelessWidget {
  final List<FRIngredient> items;
  final List<BasicIngredientQuantity> value;
  final String Function(BasicIngredientQuantity) itemLabelBuilder;
  final void Function(List<BasicIngredientQuantity>) onChanged;
  final Future<FRIngredient> Function(String)? createItem;
  final bool isMulti;
  final String label;
  final bool isRecipe;
  final bool startOpened;
  final void Function()? onModalClosed;
  const IngredientSelect({
    super.key,
    required this.items,
    required this.value,
    required this.itemLabelBuilder,
    required this.onChanged,
    required this.isMulti,
    required this.label,
    required this.isRecipe,
    this.onModalClosed,
    this.startOpened = false,
    this.createItem,
  });

  handleOpen(IngredientSelectController controller) async {
    await Get.dialog(
      IngredientSelectModalView(
        controller: controller,
        isRecipe: isRecipe,
        scrollToBottom: startOpened,
      ),
      useSafeArea: false,
    );
    if (onModalClosed != null) {
      onModalClosed!();
    }
  }

  afterInit(IngredientSelectController controller) {
    if (startOpened) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleOpen(controller);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      IngredientSelectController(
        itemLabelBuilder: itemLabelBuilder,
        label: label,
        value: value,
        onChanged: onChanged,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterInit(controller);
    });
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Get.theme.colorScheme.outlineVariant,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    handleOpen(controller);
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 42,
                      minWidth: constraints.maxWidth,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Obx(
                      () => Text(
                        maxLines: 3,
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
