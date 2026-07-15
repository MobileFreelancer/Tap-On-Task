import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/task_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/task_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_button.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TaskModel? _task;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final taskService = context.read<TaskService>();
      final task = await taskService.getTaskById(widget.taskId);
      setState(() => _task = task);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorState(message: _error!, onRetry: _loadTask)
              : _buildContent(auth),
    );
  }

  Widget _buildContent(AuthService auth) {
    final task = _task!;
    final isCustomer = auth.isCustomer;
    final isOwner = task.customerId == auth.currentUser?.id;

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(task),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(task),
                const SizedBox(height: 20),
                _buildInfoRow(task),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: const TextStyle(fontSize: 14, color: AppColors.textGray600, height: 1.6),
                ),
                const SizedBox(height: 24),
                _buildCustomerInfo(task),
                const SizedBox(height: 24),
                if (isCustomer && isOwner) _buildOwnerActions(task, auth),
                if (!isCustomer) _buildTraderActions(task, auth),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(TaskModel task) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primaryPurple,
      foregroundColor: AppColors.backgroundWhite,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryPurple, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.backgroundWhite.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.backgroundWhite.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildHeader(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildCategoryBadge(task.category),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(task.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(task.status),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          task.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildInfoRow(TaskModel task) {
    return Row(
      children: [
        _buildInfoChip(Icons.location_on_rounded, task.location),
        const SizedBox(width: 12),
        _buildInfoChip(Icons.schedule_rounded, task.createdAt.timeAgo),
        const Spacer(),
        Text(
          Formatters.formatCurrency(task.budget),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textGray500),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGray600)),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(TaskModel task) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primarySurface,
          child: Text(
            (task.customerName ?? 'U')[0].toUpperCase(),
            style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.customerName ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            Text(
              'Posted ${task.createdAt.timeAgo}',
              style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
            ),
          ],
        ),
        const Spacer(),
        if (task.bidCount > 0)
          Text(
            '${task.bidCount} bids',
            style: const TextStyle(fontSize: 13, color: AppColors.textGray500),
          ),
      ],
    );
  }

  Widget _buildCategoryBadge(TaskCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category.name[0].toUpperCase() + category.name.substring(1),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryPurple),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.open: return AppColors.accentGreen;
      case TaskStatus.assigned: return AppColors.accentBlue;
      case TaskStatus.inProgress: return AppColors.accentOrange;
      case TaskStatus.completed: return AppColors.success;
      case TaskStatus.cancelled: return AppColors.error;
    }
  }

  Widget _buildOwnerActions(TaskModel task, AuthService auth) {
    if (task.status != TaskStatus.open) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage Task',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _cancelTask(task),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
            label: const Text('Cancel Task', style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTraderActions(TaskModel task, AuthService auth) {
    if (task.status != TaskStatus.open) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          'Place a Bid',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        _buildBidSection(task),
      ],
    );
  }

  final _bidAmountController = TextEditingController();
  final _bidMessageController = TextEditingController();

  Widget _buildBidSection(TaskModel task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _bidAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Your Bid (EGP)',
            prefixText: 'EGP ',
            hintText: task.budget.toStringAsFixed(0),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _bidMessageController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Message (optional)',
            hintText: 'Tell the customer why you\'re the best for this task...',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        Consumer<TaskService>(
          builder: (context, taskService, _) => LoadingButton(
            label: 'Submit Bid',
            isLoading: taskService.isLoading,
            onPressed: () => _submitBid(task),
          ),
        ),
      ],
    );
  }

  Future<void> _submitBid(TaskModel task) async {
    final amountText = _bidAmountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your bid amount')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final taskService = context.read<TaskService>();
    final success = await taskService.placeBid(
      taskId: task.id,
      amount: amount,
      message: _bidMessageController.text.trim().isEmpty ? null : _bidMessageController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid placed successfully!')),
      );
      context.pop();
    }
  }

  Future<void> _cancelTask(TaskModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Task'),
        content: const Text('Are you sure you want to cancel this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel Task', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final taskService = context.read<TaskService>();
      await taskService.updateTaskStatus(task.id, 'cancelled');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task cancelled')),
        );
        context.pop();
      }
    }
  }
}
