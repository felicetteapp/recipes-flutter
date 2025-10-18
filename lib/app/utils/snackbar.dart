import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/theme.dart';

class FRSnackbar {
  static void show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color colorText,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      snackPosition: snackPosition,
    );
  }

  static void success(
    String title,
    String message, {
    SnackPosition? snackPosition,
  }) {
    FRSnackbar.show(
      title: title,
      message: message,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      backgroundColor: Get.theme.customColors.successContainer,
      colorText: Get.theme.customColors.onSuccessContainer,
    );
  }

  static void error(
    String title,
    String message, {
    SnackPosition? snackPosition,
  }) {
    FRSnackbar.show(
      title: title,
      message: message,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
    );
  }
}
