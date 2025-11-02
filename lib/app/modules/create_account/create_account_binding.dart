import 'package:get/get.dart';
import 'package:felicette_recipes/app/modules/create_account/create_account_controller.dart';

class CreateAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountController>(() => CreateAccountController());
  }
}
