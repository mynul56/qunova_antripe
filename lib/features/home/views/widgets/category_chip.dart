import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/contact_response.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Avatar for category
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC4C4C4),
                border: isSelected
                    ? Border.all(color: const Color(0xFF0B836A), width: 2)
                    : null,
                image: DecorationImage(
                  // Placeholder logic since category image isn't in API, but required by CSS
                  image: NetworkImage(
                    'https://i.pravatar.cc/150?img=${category.id.hashCode % 70}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Category Text
            Text(
              category.name,
              style: TextStyle(
                fontFamily: 'Inter',
                color: isSelected ? AppColors.primary : const Color(0xFF6F7D91),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                fontSize: 14,
                height: 22 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
