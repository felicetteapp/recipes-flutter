import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/modules/home/widgets/list/list_controller.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ListController());
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            Obx(
              () => SegmentedButton<ListDisplayTypeEnum>(
                segments: const [
                  ButtonSegment<ListDisplayTypeEnum>(
                    value: ListDisplayTypeEnum.ingredients,
                    label: Text('Ingredients'),
                  ),
                  ButtonSegment<ListDisplayTypeEnum>(
                    value: ListDisplayTypeEnum.recipes,
                    label: Text('Recipes'),
                  ),
                ],
                selected: {controller.displayType.value},
                onSelectionChanged: (newSelection) {
                  if (newSelection.isNotEmpty) {
                    controller.setDisplayType(newSelection.first);
                  }
                },
              ),
            ),
            Obx(() {
              return Visibility(
                visible:
                    controller.displayType.value ==
                    ListDisplayTypeEnum.ingredients,
                child: ChoiceChip(
                  label: const Text('Show checked first'),
                  selected: controller.showCheckedFirst,
                  onSelected: (selected) {
                    controller.setShowCheckedFirst(selected);
                  },
                ),
              );
            }),
          ],
        ),
        Obx(() {
          if (controller.displayType.value == ListDisplayTypeEnum.ingredients) {
            return const Expanded(
              child: Center(child: Text('Ingredients List View')),
            );
          } else {
            return const Expanded(
              child: Center(child: Text('Recipes List View')),
            );
          }
        }),
      ],
    );
  }
}
