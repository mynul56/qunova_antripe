import 'package:get/get.dart';

class SplashController extends GetxController {
  final _isWelcomeVisible = false.obs;
  bool get isWelcomeVisible => _isWelcomeVisible.value;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  void _startAnimation() async {
    // Show initial logo for a moment, then slide up welcome UI
    await Future.delayed(const Duration(milliseconds: 1200));
    _isWelcomeVisible.value = true;
  }

  void navigateToHome() {
    Get.offAllNamed('/home');
  }
}
