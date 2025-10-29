import 'package:felicette_recipes/app/modules/groups/detail/group_detail_binding.dart';
import 'package:felicette_recipes/app/modules/groups/detail/group_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/modules/home/home_binding.dart';
import 'package:felicette_recipes/app/modules/home/home_view.dart';
import 'package:felicette_recipes/app/modules/login/login_binding.dart';
import 'package:felicette_recipes/app/modules/login/login_view.dart';
import 'package:felicette_recipes/app/modules/splash/splash_binding.dart';
import 'package:felicette_recipes/app/modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.groups,
      page: () => const RedirectTo(AppRoutes.home),
      children: [
        GetPage(
          name: AppRoutes.detailsPart,
          page: () => const RedirectTo(AppRoutes.home),
          children: [
            GetPage(
              name: '/:id',
              page: () => const GroupDetailView(),
              binding: GroupDetailBinding(),
            ),
          ],
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}

class RedirectTo extends StatelessWidget {
  final String routeName;

  const RedirectTo(this.routeName, {super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.to(routeName);
    });
    return Container();
  }
}
