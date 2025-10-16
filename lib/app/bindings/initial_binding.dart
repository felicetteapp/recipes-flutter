import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import '../services/app_service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put<LocalizationService>(LocalizationService(), permanent: true);
    Get.put<AppService>(AppService(), permanent: true);
  }
}
