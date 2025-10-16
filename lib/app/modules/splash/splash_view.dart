import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Unique',
                    fontSize: 86,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Felicette',
                      style: TextStyle(
                        fontVariations: [
                          FontVariation(
                            'wght',
                            controller.almudniTextWght.value.toDouble(),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: 'Recipes',
                      style: TextStyle(
                        fontVariations: [
                          FontVariation(
                            'wght',
                            controller.appTextWght.value.toDouble(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            Obx(
              () =>
                  controller.isInitializing.value
                      ? Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      )
                      : const SizedBox.shrink(),
            ),
            // Error Message
            Obx(
              () =>
                  controller.hasError.value
                      ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text('Failed to initialize database'),
                            const SizedBox(height: 8),
                            Text(
                              controller.errorMessage.value,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: controller.retryInitialization,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
