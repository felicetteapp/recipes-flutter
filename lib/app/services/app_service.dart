import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/utils/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String isDarkModeKey = 'isDarkMode';

final AppLinks appLinks = AppLinks();

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
    super.onInit();

    appLinks.uriLinkStream.listen((Uri? uri) async {
      final authService = Get.find<AuthService>();
      final isSignInWithEmailLink = FirebaseAuth.instance.isSignInWithEmailLink(
        uri.toString(),
      );

      if (isSignInWithEmailLink) {
        log(
          'uyri queryparameters: ${uri?.queryParameters}',
          name: 'AppService.onInit',
        );

        final linkParam = uri?.queryParameters['link'];
        final linkUri = linkParam != null ? Uri.parse(linkParam) : null;

        log('Link URI extracted: $linkUri', name: 'AppService.onInit');

        final continueUrl = linkUri?.queryParameters['continueUrl'];

        log('Continue URL extracted: $continueUrl', name: 'AppService.onInit');
        String? uriEmail;

        if (continueUrl != null) {
          final continueUri = Uri.parse(continueUrl);
          uriEmail = continueUri.queryParameters['email'];
        }

        log(
          'Email link sign-in detected for email: $uriEmail',
          name: 'AppService.onInit',
        );

        if (uriEmail != null) {
          try {
            await authService.loginWithEmailLink(uriEmail, uri.toString());
          } catch (e) {
            log(
              'Error logging in with email link: $e',
              error: e,
              name: 'AppService.onInit',
            );
          }
        } else {
          log('Email not found in the link', name: 'AppService.onInit');
        }
      }
      log(
        'Received deep link URI: $uri - isSignInWithEmailLink: $isSignInWithEmailLink',
        name: 'AppService.onInit',
      );
    });

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
