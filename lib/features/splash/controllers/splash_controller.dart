import 'package:get/get.dart';

class SplashController extends GetxController {
  final _isWelcomeVisible = false.obs;
  bool get isWelcomeVisible => _isWelcomeVisible.value;

  final _logoOpacity = 0.0.obs;
  double get logoOpacity => _logoOpacity.value;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  void _startAnimation() async {
    // Initial logo fade in
    await Future.delayed(const Duration(milliseconds: 200));
    _logoOpacity.value = 1.0;

    // Show initial logo for a moment, then slide up welcome UI
    await Future.delayed(const Duration(milliseconds: 1500));
    _isWelcomeVisible.value = true;
  }

  void navigateToHome() {
    Get.offAllNamed('/home');
  }
}
