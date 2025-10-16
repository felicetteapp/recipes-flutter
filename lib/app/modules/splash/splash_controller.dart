import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final RxBool isInitializing = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt almudniTextWght = 400.obs;
  final RxInt appTextWght = 900.obs;

  late AnimationController fontWeightController;
  late Animation<double> fontWeightAnimation;

  late AnimationController addFontWeightController;
  late Animation<double> addFontWeightAnimation;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _initializeApp();
  }

  @override
  void onClose() {
    fontWeightController.dispose();
    addFontWeightController.dispose();
    super.onClose();
  }

  void _initializeAnimations() {
    addFontWeightController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    fontWeightController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    addFontWeightAnimation = Tween<double>(begin: 600.0, end: 400.0).animate(
      CurvedAnimation(parent: addFontWeightController, curve: Curves.easeOut),
    );

    fontWeightAnimation = Tween<double>(begin: 600.0, end: 900.0).animate(
      CurvedAnimation(parent: fontWeightController, curve: Curves.easeIn),
    );

    addFontWeightAnimation.addListener(() {
      appTextWght.value = addFontWeightAnimation.value.round();
    });

    fontWeightAnimation.addListener(() {
      almudniTextWght.value = fontWeightAnimation.value.round();
    });

    addFontWeightController.forward();
    fontWeightController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      isInitializing.value = true;
      hasError.value = false;
      errorMessage.value = '';

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      isInitializing.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<void> retryInitialization() async {
    await _initializeApp();
  }
}
