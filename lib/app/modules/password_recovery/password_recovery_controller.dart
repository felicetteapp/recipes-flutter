import 'dart:developer';

import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/modules/password_recovery/password_recovery_arguments.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordRecoveryController extends GetxController {
  final RxBool isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final Rxn<GlobalKey<FormState>> formKey = Rxn<GlobalKey<FormState>>();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  resetState() {
    isLoading.value = false;
    emailController.clear();
  }

  handleFirstRender() {
    resetState();
    getEmailFromArguments();
  }

  getEmailFromArguments() {
    final args = Get.arguments;
    if (args != null && args is PasswordRecoveryArguments) {
      emailController.text = args.email;
    }
  }

  handleCreateAccount() {
    Get.toNamed(AppRoutes.createAccount);
  }

  handlePasswordRecovery() async {
    final actualFormKey = formKey.value;
    if (actualFormKey == null) return;
    if (!actualFormKey.currentState!.validate()) return;

    final AuthService authService = Get.find<AuthService>();
    isLoading.value = true;
    try {
      await authService.handlePasswordRecovery(emailController.text);
      Get.toNamed(AppRoutes.login);
      FRSnackbar.success(
        TranslationKeys.success.tr,
        TranslationKeys.resetPasswordSuccess.tr,
      );
    } catch (e) {
      log(
        'Error during password recovery: $e',
        name: 'PasswordRecoveryController',
      );
      FRSnackbar.error(
        TranslationKeys.resetPasswordError.tr,
        TranslationKeys.tryAgain.tr,
      );
    } finally {
      isLoading.value = false;
    }
    // Implement password recovery logic here
  }
}
