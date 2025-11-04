import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/footer/footer.dart';
import 'package:felicette_recipes/app/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  afterRender({
    required GlobalKey<FormState> formKey,
    required GlobalKey<FormFieldState<String>> emailFieldKey,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('aqui?');
      controller.resetState();
      controller.formKey.value = formKey;
      controller.emailFieldKey.value = emailFieldKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final GlobalKey<FormFieldState<String>> emailFieldKey =
        GlobalKey<FormFieldState<String>>();
    afterRender(formKey: formKey, emailFieldKey: emailFieldKey);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
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
                              'assets/images/logo.png',
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
                          key: emailFieldKey,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (v) {
                            return FRValidations.validateEmail(
                              v,
                              isRequired: true,
                            );
                          },
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return TranslationKeys.inputRequiredError.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Obx(() {
                          return Wrap(
                            spacing: 8,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              if (controller.isLoading.value) ...[
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: const CircularProgressIndicator(),
                                ),
                              ] else ...[
                                FilledButton(
                                  onPressed: controller.login,
                                  child: Text(TranslationKeys.login.tr),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    controller.handleLoginWithoutPassword();
                                  },
                                  child: Text(
                                    TranslationKeys.loginWithoutPassword.tr,
                                  ),
                                ),
                              ],
                            ],
                          );
                        }),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: controller.handleForgotPassword,
                              child: Text(TranslationKeys.forgotPassword.tr),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Get.context!.theme.colorScheme.secondary,
                              ),
                              onPressed: controller.handleCreateAccount,
                              child: Text(TranslationKeys.createAccount.tr),
                            ),
                          ],
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
