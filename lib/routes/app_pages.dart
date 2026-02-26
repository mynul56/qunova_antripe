import 'package:get/get.dart';

import '../features/splash/bindings/splash_binding.dart';
import '../features/splash/views/splash_view.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/home/views/home_view.dart';

class AppPages {
  static const initial = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
