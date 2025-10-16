import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';

class LoginController extends GetxController {
  final RxBool isLoading = false.obs;
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
      Get.snackbar(
        'Login Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
