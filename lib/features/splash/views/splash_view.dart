import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:qunova_antripe/core/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming a standard design width of 390 for ratio calculations
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 390.0; // Responsive scale factor based on width

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Ellipse 46 (Blur)
            Positioned(
              left: -110 * scale,
              top: -32 * scale,
              child: Container(
                width: 415 * scale,
                height: 415 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 166 * scale,
                    ),
                  ],
                ),
              ),
            ),

            // Ellipse 37 (Animated)
            Obx(() {
              final isVisible = controller.isWelcomeVisible;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                left: isVisible ? (-318 * scale) : (-150 * scale),
                top: isVisible ? (877 * scale) : (613 * scale),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: isVisible ? 0.0 : 1.0,
                  child: Container(
                    width: 353 * scale,
                    height: 353 * scale,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            }),

            // Ellipse 38 (Animated)
            Obx(() {
              final isVisible = controller.isWelcomeVisible;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                left: isVisible ? (404 * scale) : (282 * scale),
                top: -70 * scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  width: isVisible ? (38 * scale) : (160 * scale),
                  height: isVisible ? (38 * scale) : (160 * scale),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              );
            }),

            // Animated Logo
            Obx(() {
              final isVisible = controller.isWelcomeVisible;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                top: isVisible ? (178 * scale) : (274 * scale),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  width: isVisible ? (126 * scale) : (171 * scale),
                  height: isVisible ? (123.24 * scale) : (168 * scale),
                  child: SvgPicture.asset(
                    'assets/splash_logo/logo.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }),

            // Bottom Welcome Sheet
            Obx(() {
              final isVisible = controller.isWelcomeVisible;
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                bottom: isVisible ? 0 : (-324 * scale),
                child: Container(
                  width: screenWidth,
                  height: 312 * scale,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24 * scale),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 56 * scale),
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 40 * scale,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8 * scale),
                        Text(
                          'Lorem ipsum dolor sit amet consectetur. Pellentesque fames lobortis vestibulum nisi nulla egestas nibh tincidunt nunc.',
                          style: TextStyle(
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.5,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 32 * scale),
                        InkWell(
                          onTap: controller.navigateToHome,
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                            width: double.infinity,
                            height: 56 * scale,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Center(
                              child: Text(
                                'Getting Started',
                                style: TextStyle(
                                  fontSize: 16 * scale,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
