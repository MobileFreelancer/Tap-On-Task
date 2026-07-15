import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/task_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';

class MyBidsScreen extends StatefulWidget {
  const MyBidsScreen({super.key});

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskService = context.watch<TaskService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('My Bids')),
      body: taskService.myBids.isEmpty
          ? const EmptyState(
              icon: Icons.handshake_outlined,
              title: 'No bids yet',
              subtitle: 'Browse available tasks and place your first bid!',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskService.myBids.length,
              itemBuilder: (context, index) {
                final bid = taskService.myBids[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.surfaceYellow,
                          child: Text(
                            (bid.traderName ?? 'T')[0].toUpperCase(),
                            style: const TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bid.traderName ?? 'Unknown',
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Bid: EGP ${bid.amount.toStringAsFixed(2)}',
                                style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.w500),
                              ),
                              if (bid.message != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  bid.message!,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textGray500),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          bid.createdAt.timeAgo,
                          style: const TextStyle(fontSize: 11, color: AppColors.textGray400),
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
