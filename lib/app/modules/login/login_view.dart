import 'package:felicette_recipes/app/common/widgets/footer/footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  afterRender() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    afterRender();
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Form(
                child: AutofillGroup(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                        TextFormField(
                          autocorrect: false,
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            labelText: TranslationKeys.email.tr,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
                        ),
                        Obx(
                          () => TextFormField(
                            autocorrect: false,
                            controller: controller.passwordController,
                            decoration: InputDecoration(
                              labelText: TranslationKeys.password.tr,
                              suffix: IconButton(
                                iconSize: 18,
                                style: ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  controller.isPasswordHidden.value =
                                      !controller.isPasswordHidden.value;
                                },
                                icon: Icon(
                                  controller.isPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            obscureText: controller.isPasswordHidden.value,
                            autofillHints: const [AutofillHints.password],
                          ),
                        ),
                        Obx(
                          () =>
                              controller.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : FilledButton(
                                    onPressed: controller.login,
                                    child: Text(TranslationKeys.login.tr),
                                  ),
                        ),
                        TextButton(
                          onPressed: controller.handleForgotPassword,
                          child: Text(TranslationKeys.forgotPassword.tr),
                        ),
                        const FRFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
