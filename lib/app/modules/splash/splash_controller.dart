import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {}

  Future<void> _initializeApp() async {}

  Future<void> retryInitialization() async {
    await _initializeApp();
  }
}
