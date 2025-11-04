import 'package:felicette_recipes/app/common/widgets/footer/footer.dart';
import 'package:felicette_recipes/app/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';

import 'create_account_controller.dart';

class CreateAccountView extends GetView<CreateAccountController> {
  const CreateAccountView({super.key});

  afterRender(GlobalKey<FormState> formKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.formKey.value = formKey;
      controller.resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    afterRender(formKey);
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
                          autocorrect: false,
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            labelText: TranslationKeys.email.tr,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return TranslationKeys.inputRequiredError.tr;
                              }
                              if (controller
                                      .confirmPasswordController
                                      .text
                                      .isNotEmpty &&
                                  value !=
                                      controller
                                          .confirmPasswordController
                                          .text) {
                                return TranslationKeys
                                    .passwordsDoNotMatchError
                                    .tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Obx(
                          () => TextFormField(
                            autocorrect: false,
                            controller: controller.confirmPasswordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: TranslationKeys.confirmPassword.tr,
                              suffix: IconButton(
                                iconSize: 18,
                                style: ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  controller.isConfirmPasswordHidden.value =
                                      !controller.isConfirmPasswordHidden.value;
                                },
                                icon: Icon(
                                  controller.isConfirmPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            obscureText:
                                controller.isConfirmPasswordHidden.value,
                            autofillHints: const [AutofillHints.password],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return TranslationKeys.inputRequiredError.tr;
                              }
                              if (value != controller.passwordController.text) {
                                return TranslationKeys
                                    .passwordsDoNotMatchError
                                    .tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Obx(
                          () =>
                              controller.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : FilledButton(
                                    onPressed: controller.handleCreateAccount,
                                    child: Text(
                                      TranslationKeys.createAccount.tr,
                                    ),
                                  ),
                        ),
                        TextButton(
                          onPressed: controller.handleAlreadyHaveAccount,
                          child: Text(TranslationKeys.alreadyHaveAccount.tr),
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
