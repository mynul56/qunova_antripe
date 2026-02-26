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
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 390.0;

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
                  if (!controller.isSearchVisible.value) {
                    return const SizedBox.shrink();
                  }
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
                  if (controller.isLoading && controller.categories.isEmpty) {
                    return _buildCategoryLoading();
                  }

                  return SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      physics: const BouncingScrollPhysics(),
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
                    if (controller.isLoading &&
                        controller.allContacts.isEmpty) {
                      return _buildListLoading();
                    }

                    if (controller.hasError) {
                      return _buildErrorState();
                    }

                    if (controller.filteredList.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 100.0,
                      ), // Bottom padding for FAB
                      physics: const BouncingScrollPhysics(),
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
          Positioned(
            right: 8 * scale,
            top: 226 * scale,
            child: SizedBox(
              width: 6 * scale,
              height: 621 * scale,
              // Represents the alphabet scroll list (A-Z)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'B',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'C',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'D',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'E',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'F',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'G',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'H',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'I',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'J',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'K',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'L',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'M',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'N',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'O',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'P',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'Q',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'R',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'S',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'T',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'U',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'V',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'W',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'X',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'Y',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                  Text(
                    'Z',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 6,
                      height: 3.833,
                      color: Color(0xFF64758B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Button
          Positioned(
            right: 20 * scale,
            bottom: 30 * scale,
            child: SizedBox(
              width: 104 * scale,
              height: 104 * scale,
              child: SvgPicture.asset(
                'assets/floating_action_button/icon.svg',
                width: 104 * scale,
                height: 104 * scale,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLoading() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF1F5F9),
          ),
        ),
      ),
    );
  }

  Widget _buildListLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.searchX, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No contacts found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64758B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or category',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.alertCircle,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.fetchData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
