import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/loading_button.dart';

class LocationSelectScreen extends StatefulWidget {
  final String? serviceId;
  final String? providerId;
  final String title;
  final String price;

  const LocationSelectScreen({
    super.key,
    this.serviceId,
    this.providerId,
    required this.title,
    required this.price,
  });

  @override
  State<LocationSelectScreen> createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  final _addressController = TextEditingController(text: 'New Cairo, District 5');
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Select Location')),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: AppColors.primarySurface,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_rounded, size: 80, color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        Text(
                          'Map view will be integrated\nwith Google Maps API',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textGray500, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const Center(
                  child: Icon(Icons.location_pin, size: 48, color: AppColors.error),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Task Description (optional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DateTimeChip(
                          icon: Icons.calendar_today_rounded,
                          label: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                            );
                            if (date != null) setState(() => _selectedDate = date);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateTimeChip(
                          icon: Icons.access_time_rounded,
                          label: _selectedTime.format(context),
                          onTap: () async {
                            final time = await showTimePicker(context: context, initialTime: _selectedTime);
                            if (time != null) setState(() => _selectedTime = time);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final scheduledAt = DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime.hour,
                          _selectedTime.minute,
                        );
                        context.pushNamed('bookingDetails', queryParameters: {
                          'serviceId': widget.serviceId ?? '',
                          'providerId': widget.providerId ?? '',
                          'title': widget.title,
                          'price': widget.price,
                          'location': _addressController.text,
                          'scheduledAt': scheduledAt.toIso8601String(),
                        });
                      },
                      child: const Text('Proceed'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DateTimeChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryPurple),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsScreen extends StatefulWidget {
  final String title;
  final String price;
  final String location;
  final String scheduledAt;
  final String? serviceId;
  final String? providerId;

  const BookingDetailsScreen({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.scheduledAt,
    this.serviceId,
    this.providerId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(widget.price) ?? 0;
    final scheduledAt = DateTime.tryParse(widget.scheduledAt) ?? DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryCard(
              title: widget.title,
              location: widget.location,
              scheduledAt: scheduledAt,
              price: price,
            ),
            const SizedBox(height: 20),
            const Text('Add Photos (optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: List.generate(3, (i) => Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Icon(Icons.add_a_photo_rounded, color: AppColors.primaryLight),
                  )),
            ),
            const SizedBox(height: 32),
            LoadingButton(
              label: 'Submit Request',
              isLoading: _isLoading,
              onPressed: () async {
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 1));
                if (mounted) {
                  setState(() => _isLoading = false);
                  context.goNamed('bookingSuccess');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String location;
  final DateTime scheduledAt;
  final double price;

  const _SummaryCard({
    required this.title,
    required this.location,
    required this.scheduledAt,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _row('Service', title),
          _row('Location', location),
          _row('Date & Time', '${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year} at ${TimeOfDay.fromDateTime(scheduledAt).format(context)}'),
          const Divider(height: 24),
          _row('Total', 'EGP ${price.toStringAsFixed(0)}', isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: isBold ? AppColors.textPrimary : AppColors.textGray500, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: isBold ? AppColors.primaryPurple : AppColors.textPrimary))),
        ],
      ),
    );
  }
}

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 56, color: AppColors.accentGreen),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your task has been posted successfully.\nProviders will send you quotes soon.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textGray500, height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.goNamed('myTasks'),
                  child: const Text('View My Tasks'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/customer/dashboard'),
                  child: const Text('Go to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
