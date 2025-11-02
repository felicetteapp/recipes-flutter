import 'dart:developer';

import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/utils/snackbar.dart';

class CreateAccountController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final Rxn<GlobalKey<FormState>> formKey = Rxn<GlobalKey<FormState>>();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> handleCreateAccount() async {
    final actualFormKey = formKey.value;
    if (actualFormKey == null) return;
    if (!actualFormKey.currentState!.validate()) return;
    final AuthService authService = Get.find<AuthService>();
    isLoading.value = true;
    try {
      await authService.createAccount(
        emailController.text,
        passwordController.text,
      );
      Get.toNamed(AppRoutes.login);
      FRSnackbar.success(
        TranslationKeys.success.tr,
        TranslationKeys.createAccountSuccess.tr,
      );
    } catch (e) {
      log(
        'Error during account creation: $e',
        name: 'CreateAccountController',
        error: e,
      );
      FRSnackbar.error(
        TranslationKeys.createAccountErrorTitle.tr,
        TranslationKeys.tryAgain.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  resetState() {
    isLoading.value = false;
    isPasswordHidden.value = true;
    isConfirmPasswordHidden.value = true;
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  handleAlreadyHaveAccount() {
    Get.toNamed(AppRoutes.login);
  }
}
