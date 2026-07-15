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
import '../widgets/category_chip.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
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
            _buildSearchBar(),
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
                'Hello, ${auth.currentUser?.name ?? 'User'} 👋',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                'What task do you need done?',
                style: TextStyle(fontSize: 13, color: AppColors.textGray500),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textGray600,
                onPressed: () {},
              ),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primarySurface,
                  child: Text(
                    auth.currentUser?.initials ?? 'U',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.textGray400, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Search for a task...',
                style: TextStyle(color: AppColors.textGray400, fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.tune_rounded, color: AppColors.primaryPurple, size: 18),
              ),
            ],
          ),
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
        icon: Icons.assignment_outlined,
        title: 'No tasks available',
        subtitle: 'There are no tasks in this category yet.',
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
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
