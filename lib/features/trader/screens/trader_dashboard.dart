import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/task_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/task_service.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/task_card.dart';
import '../../customer/widgets/category_chip.dart';

class TraderDashboard extends StatefulWidget {
  const TraderDashboard({super.key});

  @override
  State<TraderDashboard> createState() => _TraderDashboardState();
}

class _TraderDashboardState extends State<TraderDashboard> {
  TaskCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskService>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final taskService = context.watch<TaskService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(auth),
            _buildStats(auth),
            _buildCategoryList(),
            Expanded(child: _buildTaskList(taskService)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AuthService auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, ${auth.currentUser?.name ?? 'Trader'} 👋',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                'Find tasks and start earning',
                style: TextStyle(fontSize: 13, color: AppColors.textGray500),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon:  Icon(Icons.notification_add_rounded),
                color: AppColors.textGray600,
                onPressed: () {},
              ),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.surfaceYellow,
                  child: Text(
                    auth.currentUser?.initials ?? 'T',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accentOrange),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(AuthService auth) {
    final user = auth.currentUser;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          _buildStatCard('Rating', '${user?.rating ?? 0.0}', Icons.star_rounded, AppColors.accentOrange),
          const SizedBox(width: 12),
          _buildStatCard('Tasks', '${user?.completedTasks ?? 0}', Icons.task_alt_rounded, AppColors.accentGreen),
          const SizedBox(width: 12),
          _buildStatCard('Earnings', 'EGP ${((user?.completedTasks ?? 0) * 150).toStringAsFixed(0)}', Icons.wallet_rounded, AppColors.primaryPurple),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.textGray500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = TaskCategory.values;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryChip(
            category: cat,
            isSelected: _selectedCategory == cat,
            onTap: () {
              setState(() {
                _selectedCategory = _selectedCategory == cat ? null : cat;
              });
              context.read<TaskService>().fetchTasks(category: _selectedCategory);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskList(TaskService taskService) {
    if (taskService.isLoading) {
      return const TaskCardShimmer();
    }

    if (taskService.error != null) {
      return ErrorState(
        message: taskService.error!,
        onRetry: () => taskService.fetchTasks(category: _selectedCategory),
      );
    }

    if (taskService.tasks.isEmpty) {
      return EmptyState(
        icon: Icons.explore_outlined,
        title: 'No tasks available',
        subtitle: 'Check back later for new tasks in your area.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => taskService.fetchTasks(category: _selectedCategory),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: taskService.tasks.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Tasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  Text(
                    '${taskService.tasks.length} tasks',
                    style: TextStyle(fontSize: 13, color: AppColors.textGray500),
                  ),
                ],
              ),
            );
          }
          return TaskCard(task: taskService.tasks[index - 1]);
        },
      ),
    );
  }
}
