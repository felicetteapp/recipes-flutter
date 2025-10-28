import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/modules/home/widgets/ingredients/new/new_modal.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';

class NewIngredientFab extends StatelessWidget {
  const NewIngredientFab({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupsService groupsService = Get.find<GroupsService>();
    return FloatingActionButton.extended(
      onPressed: () {
        Get.dialog(
          NewIngredientModal(
            groupId: groupsService.selectedGroup.value?.id ?? '',
          ),
          useSafeArea: false,
        );
      },
      icon: const Icon(Icons.add),
      label: Text(TranslationKeys.addIngredient.tr),
    );
  }
}
