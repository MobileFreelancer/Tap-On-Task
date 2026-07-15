import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/task_service.dart';
import '../../../core/services/app_services.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../core/widgets/task_card.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskService>().fetchMyTasks();
      context.read<BookingService>().fetchBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: const Text('My Tasks'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryPurple,
          unselectedLabelColor: AppColors.textGray500,
          indicatorColor: AppColors.primaryPurple,
          tabs: const [
            Tab(text: 'Posted Tasks'),
            Tab(text: 'Bookings'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            color: AppColors.primaryPurple,
            onPressed: () => context.pushNamed('postTask'),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostedTasks(),
          _buildBookings(),
        ],
      ),
    );
  }

  Widget _buildPostedTasks() {
    final taskService = context.watch<TaskService>();

    if (taskService.isLoading && taskService.myTasks.isEmpty) {
      return const TaskCardShimmer();
    }

    if (taskService.error != null) {
      return ErrorState(message: taskService.error!, onRetry: () => taskService.fetchMyTasks());
    }

    if (taskService.myTasks.isEmpty) {
      return EmptyState(
        icon: Icons.assignment_ind_rounded,
        title: 'No tasks yet',
        subtitle: 'Post your first task to get started!',
        actionLabel: 'Post a Task',
        onAction: () => context.pushNamed('postTask'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => taskService.fetchMyTasks(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: taskService.myTasks.length,
        itemBuilder: (context, index) {
          final task = taskService.myTasks[index];
          return Column(
            children: [
              TaskCard(task: task),
              if (task.bidCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.pushNamed('quotes', pathParameters: {'taskId': task.id}),
                      icon: const Icon(Icons.request_quote_rounded, size: 18),
                      label: Text('View ${task.bidCount} Quotes'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookings() {
    final bookingService = context.watch<BookingService>();

    if (bookingService.isLoading && bookingService.bookings.isEmpty) {
      return const TaskCardShimmer();
    }

    if (bookingService.bookings.isEmpty) {
      return const EmptyState(
        icon: Icons.event_note_rounded,
        title: 'No bookings yet',
        subtitle: 'Book a service to see your bookings here.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => bookingService.fetchBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: bookingService.bookings.length,
        itemBuilder: (_, i) {
          final booking = bookingService.bookings[i];
          return GestureDetector(
            onTap: () => context.pushNamed('tracking', pathParameters: {'bookingId': booking.id}),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(booking.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking.statusLabel,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryPurple),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (booking.providerName != null)
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textGray400),
                        const SizedBox(width: 4),
                        Text(booking.providerName!, style: const TextStyle(fontSize: 13, color: AppColors.textGray500)),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textGray400),
                      const SizedBox(width: 4),
                      Text(booking.scheduledAt.formattedWithTime, style: const TextStyle(fontSize: 13, color: AppColors.textGray500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.formatCurrency(booking.amount),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
