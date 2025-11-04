import 'package:felicette_recipes/app/common/widgets/footer/footer.dart';
import 'package:felicette_recipes/app/modules/password_recovery/password_recovery_controller.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';

class PasswordRecoveryView extends GetView<PasswordRecoveryController> {
  const PasswordRecoveryView({super.key});

  afterRender(GlobalKey<FormState> formKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.formKey.value = formKey;
      controller.handleFirstRender();
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
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator:
                              (v) => FRValidations.validateEmail(
                                v,
                                isRequired: true,
                              ),
                        ),
                        Obx(
                          () =>
                              controller.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : FilledButton(
                                    onPressed: () {
                                      controller.handlePasswordRecovery();
                                    },
                                    child: Text(
                                      TranslationKeys.resetPassword.tr,
                                    ),
                                  ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.login);
                              },
                              child: Text(
                                TranslationKeys.alreadyHaveAccount.tr,
                              ),
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
