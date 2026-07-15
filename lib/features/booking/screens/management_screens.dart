import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/app_services.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/image_placeholder.dart';
import '../../../core/widgets/loading_button.dart';

class QuotesScreen extends StatefulWidget {
  final String taskId;
  const QuotesScreen({super.key, required this.taskId});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingService>().fetchQuotes(widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingService = context.watch<BookingService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Quotes Received')),
      body: bookingService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingService.quotes.isEmpty
              ? const EmptyState(
                  icon: Icons.request_quote_rounded,
                  title: 'No quotes yet',
                  subtitle: 'Providers will send quotes for your task soon.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: bookingService.quotes.length,
                  itemBuilder: (_, i) {
                    final quote = bookingService.quotes[i];
                    return Container(
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
                              AvatarPlaceholder(radius: 22, name: quote.traderName),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(quote.traderName ?? 'Provider', style: const TextStyle(fontWeight: FontWeight.w600)),
                                    Text(quote.createdAt.timeAgo, style: const TextStyle(fontSize: 12, color: AppColors.textGray400)),
                                  ],
                                ),
                              ),
                              Text(
                                Formatters.formatCurrency(quote.amount),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                              ),
                            ],
                          ),
                          if (quote.message != null) ...[
                            const SizedBox(height: 12),
                            Text(quote.message!, style: const TextStyle(fontSize: 13, color: AppColors.textGray600)),
                          ],
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final success = await bookingService.acceptQuote(widget.taskId, quote.id);
                                if (success && context.mounted) {
                                  context.pushNamed('payment', queryParameters: {
                                    'amount': quote.amount.toString(),
                                    'bookingId': widget.taskId,
                                  });
                                }
                              },
                              child: const Text('Accept Quote'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class TrackingScreen extends StatelessWidget {
  final String bookingId;
  const TrackingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingService>().bookings
        .where((b) => b.id == bookingId)
        .firstOrNull;

    final steps = ['Pending', 'Assigned', 'In Progress', 'Completed'];
    final currentStep = _getStepIndex(booking?.status ?? 'pending');

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Track Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_rounded, size: 48, color: AppColors.primaryPurple.withValues(alpha: 0.4)),
                    const SizedBox(height: 8),
                    Text(
                      'Live tracking map\n(connect Google Maps API)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textGray500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (booking != null) ...[
              Text(booking.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(booking.location, style: const TextStyle(color: AppColors.textGray500)),
              if (booking.providerName != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      AvatarPlaceholder(radius: 24, name: booking.providerName),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.providerName!, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const Text('Estimated arrival: 25 min', style: TextStyle(fontSize: 12, color: AppColors.accentGreen)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone_rounded, color: AppColors.primaryPurple),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),
            const Text('Status Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...List.generate(steps.length, (i) {
              final isActive = i <= currentStep;
              final isCurrent = i == currentStep;
              return Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryPurple : AppColors.borderLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isActive ? Icons.check_rounded : Icons.circle,
                          size: 16,
                          color: isActive ? Colors.white : AppColors.textGray400,
                        ),
                      ),
                      if (i < steps.length - 1)
                        Container(width: 2, height: 40, color: isActive ? AppColors.primaryPurple : AppColors.borderLight),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        steps[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                          color: isActive ? AppColors.textPrimary : AppColors.textGray400,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  int _getStepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return 1;
      case 'in_progress':
        return 2;
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }
}

class PaymentScreen extends StatefulWidget {
  final String amount;
  final String bookingId;
  const PaymentScreen({super.key, required this.amount, required this.bookingId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentService>().fetchPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentService = context.watch<PaymentService>();
    final amount = double.tryParse(widget.amount) ?? 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  const Text('Order Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Service Cost'),
                      Text(Formatters.formatCurrency(amount), style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Service Fee', style: TextStyle(color: AppColors.textGray500)),
                      Text('EGP 0.00'),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        Formatters.formatCurrency(amount),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...paymentService.paymentMethods.map((method) {
              final isSelected = paymentService.selectedMethod?.id == method.id;
              return GestureDetector(
                onTap: () => paymentService.selectPaymentMethod(method),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? AppColors.primaryPurple : AppColors.borderLight, width: isSelected ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(_methodIcon(method.type), color: AppColors.primaryPurple),
                      const SizedBox(width: 12),
                      Expanded(child: Text(method.label, style: const TextStyle(fontWeight: FontWeight.w500))),
                      Radio<String>(
                        value: method.id,
                        groupValue: paymentService.selectedMethod?.id,
                        onChanged: (_) => paymentService.selectPaymentMethod(method),
                        activeColor: AppColors.primaryPurple,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            LoadingButton(
              label: 'Pay Now',
              isLoading: paymentService.isLoading,
              onPressed: () async {
                final success = await paymentService.processPayment(
                  amount: amount,
                  bookingId: widget.bookingId,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment successful!')),
                  );
                  context.go('/customer/dashboard');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _methodIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.applePay:
        return Icons.apple_rounded;
      case PaymentMethodType.googlePay:
        return Icons.g_mobiledata_rounded;
      case PaymentMethodType.wallet:
        return Icons.account_balance_wallet_rounded;
      case PaymentMethodType.paypal:
        return Icons.payment_rounded;
      default:
        return Icons.credit_card_rounded;
    }
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentService>().fetchWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentService = context.watch<PaymentService>();
    final wallet = paymentService.wallet;

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Wallet')),
      body: paymentService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Available Balance', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        Formatters.formatCurrency(wallet?.balance ?? 0),
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryPurple,
                        ),
                        child: const Text('Top Up'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Transaction History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...(wallet?.transactions ?? []).map((txn) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: (txn.type == TransactionType.credit ? AppColors.surfaceGreen : AppColors.surfaceRed),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              txn.type == TransactionType.credit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                              color: txn.type == TransactionType.credit ? AppColors.accentGreen : AppColors.error,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(txn.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                                Text(txn.createdAt.timeAgo, style: const TextStyle(fontSize: 12, color: AppColors.textGray400)),
                              ],
                            ),
                          ),
                          Text(
                            '${txn.type == TransactionType.credit ? '+' : '-'}${Formatters.formatCurrency(txn.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: txn.type == TransactionType.credit ? AppColors.accentGreen : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationService>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifService = context.watch<NotificationService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Notifications')),
      body: notifService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifService.notifications.isEmpty
              ? const EmptyState(icon: Icons.notifications_none_rounded, title: 'No notifications', subtitle: 'You\'re all caught up!')
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: notifService.notifications.length,
                  itemBuilder: (_, i) {
                    final notif = notifService.notifications[i];
                    return GestureDetector(
                      onTap: () => notifService.markAsRead(notif.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: notif.isRead ? AppColors.backgroundWhite : AppColors.primarySurface.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.notifications_rounded, color: AppColors.primaryPurple, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notif.title, style: TextStyle(fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(notif.body, style: const TextStyle(fontSize: 13, color: AppColors.textGray500)),
                                  const SizedBox(height: 4),
                                  Text(notif.createdAt.timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textGray400)),
                                ],
                              ),
                            ),
                            if (!notif.isRead)
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryPurple, shape: BoxShape.circle)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationService>().fetchFaqs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final faqs = context.watch<NotificationService>().faqs;
    final categories = faqs.map((f) => f.category).toSet().toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for help...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: AppColors.backgroundWhite,
            ),
          ),
          const SizedBox(height: 24),
          ...categories.map((cat) {
            final catFaqs = faqs.where((f) => f.category == cat).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...catFaqs.map((faq) => ExpansionTile(
                      title: Text(faq.question, style: const TextStyle(fontSize: 14)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(faq.answer, style: const TextStyle(fontSize: 13, color: AppColors.textGray600, height: 1.5)),
                        ),
                      ],
                    )),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(title: const Text('Messages')),
      body: const EmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'No messages yet',
        subtitle: 'Start a conversation with a provider after booking.',
      ),
    );
  }
}
