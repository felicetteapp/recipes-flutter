import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import 'package:recipes_flutter/app/services/recipes_service.dart';
import '../services/app_service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<LocalizationService>(LocalizationService(), permanent: true);
    Get.put<AppService>(AppService(), permanent: true);
    Get.put<GroupsService>(GroupsService(), permanent: true);
    Get.put<IngredientsService>(IngredientsService(), permanent: true);
    Get.put<RecipesService>(RecipesService(), permanent: true);
  }
}
