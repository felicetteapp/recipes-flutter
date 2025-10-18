import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        Image.asset(
                          'assets/images/felicette_recipes_logo.png',
                          width: 100,
                          height: 100,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Felicette',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Recipes',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                color: Get.theme.colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: TranslationKeys.email.tr,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: TranslationKeys.password.tr,
                      ),
                      obscureText: true,
                    ),
                    Obx(
                      () =>
                          controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                onPressed: controller.login,
                                child: Text(TranslationKeys.login.tr),
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
