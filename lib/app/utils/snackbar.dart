import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/theme.dart';

class FRSnackbar {
  static SnackbarController show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color colorText,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    Duration? duration = const Duration(seconds: 3),
    EdgeInsets? margin,
  }) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      snackPosition: snackPosition,
      duration: duration,
      margin: margin,
    );
  }

  static SnackbarController success(
    String title,
    String message, {
    SnackPosition? snackPosition,
    Duration? duration,
    EdgeInsets? margin,
  }) {
    return FRSnackbar.show(
      title: title,
      message: message,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      duration: duration,
      backgroundColor: Get.theme.customColors.successContainer,
      colorText: Get.theme.customColors.onSuccessContainer,
      margin: margin,
    );
  }

  static SnackbarController error(
    String title,
    String message, {
    SnackPosition? snackPosition,
    Duration? duration,
    EdgeInsets? margin,
  }) {
    return FRSnackbar.show(
      title: title,
      message: message,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      duration: duration,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
      margin: margin,
    );
  }

  static SnackbarController info(
    String title,
    String message, {
    SnackPosition? snackPosition,
    Duration? duration,
    EdgeInsets? margin,
  }) {
    return FRSnackbar.show(
      title: title,
      message: message,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      duration: duration,
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      colorText: Get.theme.colorScheme.onPrimaryContainer,
      margin: margin,
    );
  }
}
