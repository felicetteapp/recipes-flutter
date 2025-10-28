import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerController extends GetxController {
  Rxn<PackageInfo> packageInfo = Rxn<PackageInfo>();

  @override
  void onInit() {
    PackageInfo.fromPlatform().then((info) {
      packageInfo.value = info;
    });

    super.onInit();
  }
}
