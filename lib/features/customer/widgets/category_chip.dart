import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/task_model.dart';

class CategoryChip extends StatelessWidget {
  final TaskCategory category;
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _getColor().withValues(alpha: 0.1) : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _getColor() : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getIcon(), size: 18, color: isSelected ? _getColor() : AppColors.textGray400),
            const SizedBox(width: 8),
            Text(
              _getLabel(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? _getColor() : AppColors.textGray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (category) {
      case TaskCategory.cleaning: return Icons.cleaning_services_rounded;
      case TaskCategory.moving: return Icons.local_shipping_rounded;
      case TaskCategory.repairs: return Icons.build_rounded;
      case TaskCategory.delivery: return Icons.delivery_dining_rounded;
      case TaskCategory.shopping: return Icons.shopping_cart_rounded;
      case TaskCategory.tutoring: return Icons.school_rounded;
      case TaskCategory.events: return Icons.event_rounded;
      case TaskCategory.other: return Icons.more_horiz_rounded;
    }
  }

  Color _getColor() {
    switch (category) {
      case TaskCategory.cleaning: return AppColors.accentBlue;
      case TaskCategory.moving: return AppColors.accentOrange;
      case TaskCategory.repairs: return AppColors.accentGreen;
      case TaskCategory.delivery: return AppColors.accentRed;
      case TaskCategory.shopping: return AppColors.accentOrange;
      case TaskCategory.tutoring: return AppColors.accentBlue;
      case TaskCategory.events: return AppColors.primaryPurple;
      case TaskCategory.other: return AppColors.textGray400;
    }
  }

  String _getLabel() {
    switch (category) {
      case TaskCategory.cleaning: return 'Cleaning';
      case TaskCategory.moving: return 'Moving';
      case TaskCategory.repairs: return 'Repairs';
      case TaskCategory.delivery: return 'Delivery';
      case TaskCategory.shopping: return 'Shopping';
      case TaskCategory.tutoring: return 'Tutoring';
      case TaskCategory.events: return 'Events';
      case TaskCategory.other: return 'Other';
    }
  }
}
