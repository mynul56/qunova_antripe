import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import 'widgets/category_chip.dart';
import 'widgets/contact_item.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8FAFC,
      ), // Slight off-white to match standard backgrounds, or white as per CSS
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ), // Padding to account for 60px absolute from top
                // App Bar / Top Navigation (Contact / Recent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Scrollable Tabs area
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Contact',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFF334155), // Slate/700
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: 68,
                                  height: 2,
                                  color: AppColors.primary, // 098268
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Recent',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFF94A3B8), // Slate/400
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ), // Keeps alignment with the Contact text
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Icons Group
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Expand search implementation
                              controller.isSearchVisible.toggle();
                            },
                            child: const Icon(
                              LucideIcons.search,
                              size: 24,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(width: 32),
                          const Icon(
                            LucideIcons.alignRight,
                            size: 24,
                            color: Color(0xFF4B5563),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Search Input (Hidden by default based on Figma, toggle-able via controller)
                Obx(() {
                  if (!controller.isSearchVisible.value)
                    return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 16.0,
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search contacts...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  );
                }),

                // Horizontal Categories Scroll
                Obx(() {
                  if (controller.categories.isEmpty)
                    return const SizedBox(height: 82);

                  return SizedBox(
                    height: 82,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        final isSelected =
                            controller.selectedCategoryId == category.id;
                        return CategoryChip(
                          category: category,
                          isSelected: isSelected,
                          onTap: () => controller.selectCategory(category.id),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Main Contact List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (controller.hasError) {
                      return Center(child: Text(controller.errorMessage));
                    }

                    if (controller.filteredList.isEmpty) {
                      return const Center(
                        child: Text(
                          'No contacts found',
                          style: TextStyle(color: Color(0xFF64758B)),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 80.0,
                      ), // Bottom padding for FAB
                      itemCount: controller.filteredList.length,
                      itemBuilder: (context, index) {
                        return ContactItem(
                          contact: controller.filteredList[index],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),

          // Scroll Navigation Indicator Overlay as per CSS
          const Positioned(
            right: 8,
            top: 226,
            child: SizedBox(
              width: 6,
              height: 621,
              // Represents the alphabet scroll list (A-Z)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'A',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'B',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'C',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'D',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'E',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'F',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'G',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'H',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'I',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'J',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'K',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'L',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'M',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'N',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'O',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'P',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Q',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'R',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'S',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'T',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'U',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'V',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'W',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'X',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Y',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Z',
                    style: TextStyle(
                      fontSize: 6,
                      color: Color(0xFF64758B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Button
          Positioned(
            left: 294,
            top: 724,
            child: SizedBox(
              width: 64,
              height: 64,
              child: SvgPicture.asset(
                'assets/floating_action_button/icon.svg',
                width: 64,
                height: 64,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
