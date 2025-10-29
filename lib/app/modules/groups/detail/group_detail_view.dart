import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/modules/groups/detail/group_detail_controller.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDetailView extends GetView<GroupDetailController> {
  const GroupDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(TranslationKeys.editGroup.tr)),
      extendBodyBehindAppBar: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(TranslationKeys.loading.tr),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            controller: controller.groupNameController,
                            decoration: InputDecoration(
                              labelText: TranslationKeys.groupName.tr,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Get.theme.colorScheme.error,
                            ),
                            onPressed: () {
                              controller.deleteGroup();
                            },
                            icon: Icon(Icons.delete),
                            label: Text(TranslationKeys.deleteGroup.tr),
                          ),
                        ],
                      );
                    }),
                  ),
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
                    child: Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: Icon(Icons.chevron_left),
                            onPressed: () {
                              Get.back();
                            },
                            label: Text(TranslationKeys.cancel.tr),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: Get.theme.customColors.success,
                                foregroundColor:
                                    Get.theme.customColors.onSuccess,
                              ),
                              onPressed:
                                  controller.isLoading.value
                                      ? null
                                      : () {
                                        controller.saveGroupName();
                                      },
                              icon: const Icon(Icons.save),
                              label: Text(
                                TranslationKeys.save.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
