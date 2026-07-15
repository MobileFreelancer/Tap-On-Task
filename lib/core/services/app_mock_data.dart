import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/notification_model.dart';
import '../models/task_model.dart';

class AppMockData {
  AppMockData._();

  static const List<String> trendingSearches = [
    'House Cleaning',
    'Plumber',
    'Electrician',
    'Moving Help',
    'Furniture Assembly',
    'Gardening',
  ];

  static final List<ServiceCategoryModel> categories = [
    ServiceCategoryModel(
      id: 'cleaning',
      name: 'Cleaning',
      icon: Icons.cleaning_services_rounded,
      color: AppColors.primaryPurple,
      serviceCount: 24,
    ),
    ServiceCategoryModel(
      id: 'repairs',
      name: 'Repairs',
      icon: Icons.build_rounded,
      color: AppColors.accentOrange,
      serviceCount: 18,
    ),
    ServiceCategoryModel(
      id: 'moving',
      name: 'Moving',
      icon: Icons.local_shipping_rounded,
      color: AppColors.accentBlue,
      serviceCount: 12,
    ),
    ServiceCategoryModel(
      id: 'delivery',
      name: 'Delivery',
      icon: Icons.delivery_dining_rounded,
      color: AppColors.accentGreen,
      serviceCount: 15,
    ),
    ServiceCategoryModel(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: AppColors.primaryLight,
      serviceCount: 8,
    ),
    ServiceCategoryModel(
      id: 'tutoring',
      name: 'Tutoring',
      icon: Icons.school_rounded,
      color: AppColors.accentOrange,
      serviceCount: 10,
    ),
    ServiceCategoryModel(
      id: 'events',
      name: 'Events',
      icon: Icons.celebration_rounded,
      color: AppColors.accentRed,
      serviceCount: 6,
    ),
    ServiceCategoryModel(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz_rounded,
      color: AppColors.textGray500,
      serviceCount: 5,
    ),
  ];

  static final List<BannerModel> banners = [
    BannerModel(
      id: 'banner1',
      title: 'Get 20% Off',
      subtitle: 'On your first booking this week',
      backgroundColor: AppColors.primaryPurple,
    ),
    BannerModel(
      id: 'banner2',
      title: 'Trusted Pros',
      subtitle: 'Verified professionals near you',
      backgroundColor: AppColors.primaryDark,
    ),
    BannerModel(
      id: 'banner3',
      title: 'Same Day Service',
      subtitle: 'Book now, get help today',
      backgroundColor: AppColors.accentBlue,
    ),
  ];

  static final List<ServiceModel> services = [
    const ServiceModel(
      id: 'svc1',
      title: 'Deep Home Cleaning',
      description: 'Professional deep cleaning for apartments and houses.',
      categoryId: 'cleaning',
      price: 350,
      rating: 4.9,
      reviewCount: 128,
      providerId: 'prov1',
      providerName: 'Mohamed Ali',
      distanceKm: 2.3,
    ),
    const ServiceModel(
      id: 'svc2',
      title: 'Plumbing Repair',
      description: 'Fix leaks, clogs, and faucet installations.',
      categoryId: 'repairs',
      price: 200,
      rating: 4.7,
      reviewCount: 89,
      providerId: 'prov2',
      providerName: 'Karim Hassan',
      distanceKm: 1.5,
    ),
    const ServiceModel(
      id: 'svc3',
      title: 'Furniture Moving',
      description: 'Safe and efficient furniture relocation service.',
      categoryId: 'moving',
      price: 500,
      rating: 4.8,
      reviewCount: 56,
      providerId: 'prov3',
      providerName: 'Ahmed Youssef',
      distanceKm: 3.1,
    ),
    const ServiceModel(
      id: 'svc4',
      title: 'Express Delivery',
      description: 'Fast document and package delivery across Cairo.',
      categoryId: 'delivery',
      price: 150,
      rating: 4.6,
      reviewCount: 203,
      providerId: 'prov4',
      providerName: 'Omar Farouk',
      distanceKm: 0.8,
    ),
    const ServiceModel(
      id: 'svc5',
      title: 'Grocery Shopping',
      description: 'Weekly grocery shopping and delivery service.',
      categoryId: 'shopping',
      price: 100,
      rating: 4.5,
      reviewCount: 42,
      providerId: 'prov5',
      providerName: 'Sara Ibrahim',
      distanceKm: 4.2,
    ),
    const ServiceModel(
      id: 'svc6',
      title: 'Electrical Wiring',
      description: 'Electrical repairs and new wiring installations.',
      categoryId: 'repairs',
      price: 280,
      rating: 4.8,
      reviewCount: 67,
      providerId: 'prov6',
      providerName: 'Hassan Nabil',
      distanceKm: 2.7,
    ),
  ];

  static final List<ProviderModel> providers = [
    ProviderModel(
      id: 'prov1',
      name: 'Mohamed Ali',
      title: 'Professional Cleaner',
      bio: 'Over 5 years of experience in residential and commercial cleaning. I bring my own equipment and eco-friendly products.',
      rating: 4.9,
      reviewCount: 128,
      completedJobs: 340,
      hourlyRate: 150,
      distanceKm: 2.3,
      categoryId: 'cleaning',
      portfolioImages: const [],
      reviews: [
        ReviewModel(
          id: 'rev1',
          userName: 'Nadia M.',
          rating: 5,
          comment: 'Excellent work! My apartment has never been cleaner.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ReviewModel(
          id: 'rev2',
          userName: 'Tarek S.',
          rating: 4.5,
          comment: 'Very professional and on time.',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
    ),
    ProviderModel(
      id: 'prov2',
      name: 'Karim Hassan',
      title: 'Licensed Plumber',
      bio: 'Certified plumber specializing in residential repairs. Available for emergency calls.',
      rating: 4.7,
      reviewCount: 89,
      completedJobs: 210,
      hourlyRate: 180,
      distanceKm: 1.5,
      categoryId: 'repairs',
      portfolioImages: const [],
      reviews: [
        ReviewModel(
          id: 'rev3',
          userName: 'Layla A.',
          rating: 5,
          comment: 'Fixed my leak in under an hour!',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
    ),
    ProviderModel(
      id: 'prov3',
      name: 'Ahmed Youssef',
      title: 'Moving Specialist',
      bio: 'Experienced mover with a team. We handle furniture, appliances, and fragile items with care.',
      rating: 4.8,
      reviewCount: 56,
      completedJobs: 150,
      hourlyRate: 200,
      distanceKm: 3.1,
      categoryId: 'moving',
      portfolioImages: const [],
      reviews: const [],
    ),
  ];

  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'book1',
      taskId: 'task1',
      providerId: 'prov1',
      providerName: 'Mohamed Ali',
      title: 'Deep Home Cleaning',
      status: 'in_progress',
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
      location: 'New Cairo, District 5',
      amount: 350,
      categoryName: 'Cleaning',
    ),
    BookingModel(
      id: 'book2',
      taskId: 'task2',
      providerId: 'prov2',
      providerName: 'Karim Hassan',
      title: 'Plumbing Repair',
      status: 'pending',
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
      location: 'Heliopolis, Cairo',
      amount: 200,
      categoryName: 'Repairs',
    ),
    BookingModel(
      id: 'book3',
      taskId: 'task3',
      title: 'Moving Assistance',
      status: 'completed',
      scheduledAt: DateTime.now().subtract(const Duration(days: 3)),
      location: 'Sheikh Zayed, Giza',
      amount: 500,
      categoryName: 'Moving',
    ),
  ];

  static final List<TaskBidModel> quotes = [
    TaskBidModel(
      id: 'bid1',
      taskId: 'task1',
      traderId: 'prov1',
      traderName: 'Mohamed Ali',
      amount: 320,
      message: 'I can do this today with my own equipment.',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    TaskBidModel(
      id: 'bid2',
      taskId: 'task1',
      traderId: 'prov2',
      traderName: 'Karim Hassan',
      amount: 350,
      message: 'Available tomorrow morning.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    TaskBidModel(
      id: 'bid3',
      taskId: 'task1',
      traderId: 'prov3',
      traderName: 'Ahmed Youssef',
      amount: 300,
      message: 'Experienced cleaner, 5-star rating.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  static final WalletModel wallet = WalletModel(
    balance: 1250,
    transactions: [
      TransactionModel(
        id: 'txn1',
        title: 'Deep Home Cleaning',
        amount: 350,
        type: TransactionType.debit,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        id: 'txn2',
        title: 'Wallet Top-up',
        amount: 500,
        type: TransactionType.credit,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      TransactionModel(
        id: 'txn3',
        title: 'Moving Assistance',
        amount: 500,
        type: TransactionType.debit,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ],
  );

  static final List<PaymentMethodModel> paymentMethods = [
    const PaymentMethodModel(
      id: 'pm1',
      type: PaymentMethodType.card,
      label: 'Visa ending in 4242',
      lastFour: '4242',
      isDefault: true,
    ),
    const PaymentMethodModel(
      id: 'pm2',
      type: PaymentMethodType.applePay,
      label: 'Apple Pay',
    ),
    const PaymentMethodModel(
      id: 'pm3',
      type: PaymentMethodType.googlePay,
      label: 'Google Pay',
    ),
    const PaymentMethodModel(
      id: 'pm4',
      type: PaymentMethodType.wallet,
      label: 'Tap On Task Wallet',
    ),
  ];

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif1',
      title: 'New Quote Received',
      body: 'Mohamed Ali sent you a quote for EGP 320',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      type: 'quote',
      referenceId: 'task1',
    ),
    NotificationModel(
      id: 'notif2',
      title: 'Booking Confirmed',
      body: 'Your cleaning service is scheduled for tomorrow',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'booking',
      referenceId: 'book1',
    ),
    NotificationModel(
      id: 'notif3',
      title: 'Service Completed',
      body: 'Rate your experience with Karim Hassan',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: 'rating',
      isRead: true,
    ),
    NotificationModel(
      id: 'notif4',
      title: 'Payment Successful',
      body: 'EGP 350 was charged to your Visa card',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      type: 'payment',
      isRead: true,
    ),
  ];

  static final List<FaqModel> faqs = [
    const FaqModel(
      id: 'faq1',
      category: 'Account',
      question: 'How do I create an account?',
      answer: 'Download the app, tap Register, and fill in your details. You can sign up as a Customer or a Tech/Trader.',
    ),
    const FaqModel(
      id: 'faq2',
      category: 'Account',
      question: 'How do I reset my password?',
      answer: 'Tap "Forgot Password" on the login screen, enter your email, verify the OTP, and set a new password.',
    ),
    const FaqModel(
      id: 'faq3',
      category: 'Booking',
      question: 'How do I book a service?',
      answer: 'Browse categories on the home screen, select a service, choose a provider, set your location and schedule, then confirm.',
    ),
    const FaqModel(
      id: 'faq4',
      category: 'Booking',
      question: 'Can I cancel a booking?',
      answer: 'Yes, you can cancel from My Tasks before the service starts. Cancellation policies may apply.',
    ),
    const FaqModel(
      id: 'faq5',
      category: 'Payment',
      question: 'What payment methods are accepted?',
      answer: 'We accept credit/debit cards, Apple Pay, Google Pay, and your in-app wallet.',
    ),
    const FaqModel(
      id: 'faq6',
      category: 'Payment',
      question: 'Is my payment information secure?',
      answer: 'Yes, all payments are processed through secure, encrypted channels. We never store your full card details.',
    ),
  ];

  static List<ServiceModel> getServicesByCategory(String categoryId) =>
      services.where((s) => s.categoryId == categoryId).toList();

  static List<ProviderModel> getProvidersByCategory(String categoryId) =>
      providers.where((p) => p.categoryId == categoryId).toList();

  static ServiceModel? getServiceById(String id) {
    try {
      return services.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static ProviderModel? getProviderById(String id) {
    try {
      return providers.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<ServiceModel> searchServices(String query) {
    if (query.isEmpty) return services;
    final q = query.toLowerCase();
    return services
        .where((s) =>
            s.title.toLowerCase().contains(q) ||
            s.description.toLowerCase().contains(q) ||
            (s.providerName?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  static List<ProviderModel> searchProviders(String query) {
    if (query.isEmpty) return providers;
    final q = query.toLowerCase();
    return providers
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.title.toLowerCase().contains(q) ||
            p.bio.toLowerCase().contains(q))
        .toList();
  }
}
