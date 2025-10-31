import 'package:felicette_recipes/app/modules/password_recovery/password_recovery_controller.dart';
import 'package:get/get.dart';

class PasswordRecoveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordRecoveryController>(() => PasswordRecoveryController());
  }
}
