import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/task_model.dart';
import '../../../core/services/task_service.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/task_card.dart';
import '../../customer/widgets/category_chip.dart';

class AvailableTasksScreen extends StatefulWidget {
  const AvailableTasksScreen({super.key});

  @override
  State<AvailableTasksScreen> createState() => _AvailableTasksScreenState();
}

class _AvailableTasksScreenState extends State<AvailableTasksScreen> {
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
    final taskService = context.watch<TaskService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Available Tasks')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryList(),
          Expanded(child: _buildTaskList(taskService)),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = TaskCategory.values;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryChip(
            category: cat,
            isSelected: _selectedCategory == cat,
            onTap: () {
              setState(() => _selectedCategory = _selectedCategory == cat ? null : cat);
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
      return const EmptyState(
        icon: Icons.explore_outlined,
        title: 'No tasks available',
        subtitle: 'Check back later for new tasks.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => taskService.fetchTasks(category: _selectedCategory),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: taskService.tasks.length,
        itemBuilder: (context, index) => TaskCard(task: taskService.tasks[index]),
      ),
    );
  }
}
