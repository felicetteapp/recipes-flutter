import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/utils/snackbar.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginView'), centerTitle: true),
      body: Column(
        children: [
          TextField(
            controller: controller.emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: controller.passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              FRSnackbar.success('Error', 'An error occurred');
            },
            child: Text('teste'),
          ),
          Obx(
            () =>
                controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: controller.login,
                      child: const Text('Login'),
                    ),
          ),
        ],
      ),
    );
  }
}
