import 'package:get/get.dart';

class AppService extends GetxService {
  final RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
