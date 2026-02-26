import 'package:get/get.dart';

import '../features/splash/controllers/splash_controller.dart';
import '../features/splash/views/splash_view.dart';
import '../features/contacts/controllers/home_controller.dart';
import '../features/contacts/views/home_view.dart';

class AppPages {
  static const initial = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
      transition: Transition.fadeIn,
    ),
  ];
}
