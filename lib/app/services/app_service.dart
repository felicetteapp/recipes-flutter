import 'dart:developer';

import 'package:felicette_recipes/app/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String isDarkModeKey = 'isDarkMode';

class AppService extends GetxService {
  final RxBool togglingTheme = false.obs;
  Future<void> toggleTheme() async {
    togglingTheme.value = true;
    final currentTheme = Get.isDarkMode;
    log(
      'Toggling theme from $currentTheme to ${!currentTheme}',
      name: 'AppService.toggleTheme',
    );

    await setTheme(!currentTheme);
    togglingTheme.value = false;
  }

  Future<void> setTheme(bool isDark) async {
    log('Saving theme mode: $isDark', name: 'AppService.setTheme');
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    await FRSecureStorage.write(key: isDarkModeKey, value: isDark.toString());
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    togglingTheme.listen((toggling) {
      log('Toggling theme state changed: $toggling', name: 'AppService.onInit');

      if (toggling) {
        Get.dialog(
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    });
  }
}
