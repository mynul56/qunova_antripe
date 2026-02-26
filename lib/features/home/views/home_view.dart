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
                      // TabBar for Contact / Recent
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 180 * scale,
                            child: TabBar(
                              controller: controller.tabController,
                              dividerColor: Colors.transparent,
                              indicatorColor: AppColors.primary,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: const Color(0xFF334155),
                              unselectedLabelColor: const Color(0xFF94A3B8),
                              labelPadding: EdgeInsets.zero,
                              labelStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              tabs: const [
                                Tab(text: 'Contact'),
                                Tab(text: 'Recent'),
                              ],
                            ),
                          ),
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
                    child: Container(
                      height: 48 * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              onChanged: controller.onSearchChanged,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFF475569), // Slate/600
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets
                                    .zero, // Padding handled by container
                                isCollapsed: true,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.searchController.clear();
                              controller.onSearchChanged('');
                              controller.isSearchVisible.value = false;
                            },
                            child: const Icon(
                              LucideIcons.x,
                              size: 24,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
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
            child: InkWell(
              onTap: _showAddContactBottomSheet,
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
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final scale = screenWidth / 390.0;

    return Center(
      child: Container(
        width: 342 * scale,
        padding: EdgeInsets.symmetric(
          horizontal: 40 * scale,
          vertical: 48 * scale,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F6FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ee! No Contacts found.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20 * scale,
                fontWeight: FontWeight.w500,
                height: 24 / 20,
                color: const Color(0xFF475569), // Slate/600
              ),
            ),
            SizedBox(height: 24 * scale),
            InkWell(
              onTap: () {
                _showAddContactBottomSheet();
              },
              borderRadius: BorderRadius.circular(60),
              child: Container(
                width: 216 * scale,
                height: 56 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF098268),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                  child: Text(
                    'Add New Contact',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.w500,
                      height: 20 / 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactBottomSheet() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final scale = screenWidth / 390.0;
    controller.clearAddContactForm();

    Get.bottomSheet(
      Container(
        height: 576 * scale,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Handle
            Container(
              width: 151 * scale,
              height: 6 * scale,
              decoration: BoxDecoration(
                color: const Color(0x998C8C8C),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 72 * scale,
                  left: 32 * scale,
                  right: 32 * scale,
                  bottom: 40 * scale,
                ),
                child: Column(
                  children: [
                    // Name Field
                    _buildBottomSheetField(
                      controller: controller.nameController,
                      hint: 'Name',
                    ),
                    const SizedBox(height: 16),
                    // Phone Field
                    _buildBottomSheetField(
                      controller: controller.phoneController,
                      hint: 'Phone',
                      prefix: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.network(
                              'https://flagcdn.com/w20/us.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (ctx, _, __) =>
                                  const Icon(LucideIcons.flag, size: 20),
                            ),
                          ),
                          const Icon(
                            LucideIcons.chevronDown,
                            size: 20,
                            color: Color(0xFF4B5563),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '+880',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Designation Field
                    _buildBottomSheetField(
                      controller: controller.designationController,
                      hint: 'Designation',
                    ),
                    const SizedBox(height: 16),
                    // Company Field
                    _buildBottomSheetField(
                      controller: controller.companyController,
                      hint: 'Company',
                    ),
                    const SizedBox(height: 16),
                    // Relation Dropdown
                    Container(
                      height: 48 * scale,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value:
                                controller.selectedRelation.value == 'Relation'
                                ? null
                                : controller.selectedRelation.value,
                            hint: const Text(
                              'Relation',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontFamily: 'Inter',
                                fontSize: 16,
                              ),
                            ),
                            icon: const Icon(
                              LucideIcons.chevronDown,
                              color: Color(0xFF4B5563),
                            ),
                            items:
                                ['Family', 'Friends', 'Relative', 'Colleague']
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val != null)
                                controller.selectedRelation.value = val;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // CTA: Save
                    InkWell(
                      onTap: () {
                        // Future: Implement save
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF098268),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Center(
                          child: Text(
                            'Save Contact',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // CTA: Cancel
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF717978)),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF717978),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
    );
  }

  Widget _buildBottomSheetField({
    required TextEditingController controller,
    required String hint,
    Widget? prefix,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          if (prefix != null) prefix,
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF475569),
                  fontFamily: 'Inter',
                  fontSize: 16,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Color(0xFF475569),
              ),
            ),
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
