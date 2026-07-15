import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../models/task_model.dart';
import '../utils/formatters.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('taskDetail', pathParameters: {'taskId': task.id}),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 14, color: AppColors.textGray400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                task.location,
                                style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: const TextStyle(fontSize: 13, color: AppColors.textGray600, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textGray400),
                      const SizedBox(width: 4),
                      Text(
                        task.createdAt.timeAgo,
                        style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                      ),
                      if (task.bidCount > 0) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textGray400),
                        const SizedBox(width: 4),
                        Text(
                          '${task.bidCount} bids',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    Formatters.formatCurrency(task.budget),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData icon;
    Color color;

    switch (task.category) {
      case TaskCategory.cleaning:
        icon = Icons.cleaning_services_rounded;
        color = AppColors.accentBlue;
      case TaskCategory.moving:
        icon = Icons.local_shipping_rounded;
        color = AppColors.accentOrange;
      case TaskCategory.repairs:
        icon = Icons.build_rounded;
        color = AppColors.accentGreen;
      case TaskCategory.delivery:
        icon = Icons.delivery_dining_rounded;
        color = AppColors.accentRed;
      case TaskCategory.shopping:
        icon = Icons.shopping_cart_rounded;
        color = AppColors.accentOrange;
      case TaskCategory.tutoring:
        icon = Icons.school_rounded;
        color = AppColors.accentBlue;
      case TaskCategory.events:
        icon = Icons.event_rounded;
        color = AppColors.primaryPurple;
      case TaskCategory.other:
        icon = Icons.more_horiz_rounded;
        color = AppColors.textGray400;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildStatusBadge() {
    if (task.status == TaskStatus.open) return const SizedBox.shrink();

    Color color;
    switch (task.status) {
      case TaskStatus.assigned:
        color = AppColors.accentBlue;
      case TaskStatus.inProgress:
        color = AppColors.accentOrange;
      case TaskStatus.completed:
        color = AppColors.accentGreen;
      case TaskStatus.cancelled:
        color = AppColors.error;
      default:
        color = AppColors.textGray400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        task.statusLabel,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
