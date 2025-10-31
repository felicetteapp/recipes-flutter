import 'package:felicette_recipes/app/modules/password_recovery/password_recovery_arguments.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/utils/snackbar.dart';

class LoginController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final AuthService authService = Get.find<AuthService>();
    isLoading.value = true;
    try {
      await authService.login(emailController.text, passwordController.text);
    } catch (e) {
      FRSnackbar.error(
        TranslationKeys.loginErrorTitle.tr,
        TranslationKeys.tryAgain.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  resetState() {
    isLoading.value = false;
    isPasswordHidden.value = true;
    emailController.clear();
    passwordController.clear();
  }

  handleForgotPassword() {
    Get.toNamed(
      AppRoutes.passwordRecovery,
      arguments: PasswordRecoveryArguments(email: emailController.text),
    );
  }
}
