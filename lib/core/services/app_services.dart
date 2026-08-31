import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/notification_model.dart';
import '../models/task_model.dart';
import '../models/api_job_model.dart';
import 'api_service.dart';
import 'app_mock_data.dart';
import 'stripe_payment_service.dart';

class HomeService extends ChangeNotifier {
  static final HomeService _instance = HomeService._internal();
  factory HomeService() => _instance;
  HomeService._internal();

  final ApiService _api = ApiService();

  List<BannerModel> _banners = [];
  List<ServiceCategoryModel> _categories = [];
  List<ServiceModel> _popularServices = [];
  List<ProviderModel> _nearbyProviders = [];
  List<BookingModel> _recentBookings = [];
  List<ApiJobModel> _apiJobs = [];
  bool _isLoading = false;
  String? _error;

  List<BannerModel> get banners => _banners;
  List<ServiceCategoryModel> get categories => _categories;
  List<ServiceModel> get popularServices => _popularServices;
  List<ProviderModel> get nearbyProviders => _nearbyProviders;
  List<BookingModel> get recentBookings => _recentBookings;
  List<ApiJobModel> get apiJobs => _apiJobs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch dynamic jobs from API
      _apiJobs = await _api.getJobList(filter: 'active');

      // Mock data for other sections as API is not ready
      await Future.delayed(const Duration(milliseconds: 600));
      _banners = AppMockData.banners;
      _categories = AppMockData.categories;
      _popularServices = AppMockData.services;
      _nearbyProviders = AppMockData.providers;
      _recentBookings = AppMockData.bookings;
    } catch (e) {
      _error = 'Failed to load home data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  ServiceCategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

class SearchService extends ChangeNotifier {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final ApiService _api = ApiService();

  List<ServiceModel> _results = [];
  List<ProviderModel> _providerResults = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  String? _error;
  String _query = '';

  List<ServiceModel> get results => _results;
  List<ProviderModel> get providerResults => _providerResults;
  List<String> get recentSearches => _recentSearches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get query => _query;

  Future<void> search(String query) async {
    _query = query;
    if (query.isEmpty) {
      _results = [];
      _providerResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Force mock for search as API is not ready
      await Future.delayed(const Duration(milliseconds: 400));
      _results = AppMockData.searchServices(query);
      _providerResults = AppMockData.searchProviders(query);
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) _recentSearches.removeLast();
      }
    } catch (_) {
      _error = 'Search failed.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _results = [];
    _providerResults = [];
    notifyListeners();
  }

  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    // Force mock
    await Future.delayed(const Duration(milliseconds: 300));
    return AppMockData.getServicesByCategory(categoryId);
  }

  Future<List<ProviderModel>> getProvidersByCategory(String categoryId) async {
    // Force mock
    await Future.delayed(const Duration(milliseconds: 300));
    return AppMockData.getProvidersByCategory(categoryId);
  }

  Future<ServiceModel?> getServiceById(String id) async {
    // Force mock
    await Future.delayed(const Duration(milliseconds: 200));
    return AppMockData.getServiceById(id);
  }

  Future<ProviderModel?> getProviderById(String id) async {
    // Force mock
    await Future.delayed(const Duration(milliseconds: 200));
    return AppMockData.getProviderById(id);
  }
}

class BookingService extends ChangeNotifier {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final ApiService _api = ApiService();

  List<BookingModel> _bookings = [];
  List<TaskBidModel> _quotes = [];
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  List<TaskBidModel> get quotes => _quotes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Force mock
      await Future.delayed(const Duration(milliseconds: 500));
      _bookings = AppMockData.bookings;
    } catch (_) {
      _error = 'Failed to load bookings.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchQuotes(String taskId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Force mock
      await Future.delayed(const Duration(milliseconds: 400));
      _quotes = AppMockData.quotes.where((q) => q.taskId == taskId).toList();
    } catch (_) {
      _error = 'Failed to load quotes.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> acceptQuote(String taskId, String bidId) async {
    try {
      // Force mock
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (_) {
      _error = 'Failed to accept quote.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> createBooking({
    required String title,
    required String description,
    required String categoryId,
    required double amount,
    required String location,
    required DateTime scheduledAt,
    String? serviceId,
    String? providerId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Force mock
      await Future.delayed(const Duration(seconds: 1));
      final booking = BookingModel(
        id: 'book${DateTime.now().millisecondsSinceEpoch}',
        taskId: 'task${DateTime.now().millisecondsSinceEpoch}',
        serviceId: serviceId,
        providerId: providerId,
        title: title,
        status: 'pending',
        scheduledAt: scheduledAt,
        location: location,
        amount: amount,
      );
      _bookings.insert(0, booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _error = 'Failed to create booking.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class PaymentService extends ChangeNotifier {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  final ApiService _api = ApiService();

  WalletModel? _wallet;
  List<PaymentMethodModel> _paymentMethods = [];
  PaymentMethodModel? _selectedMethod;
  bool _isLoading = false;
  String? _error;

  WalletModel? get wallet => _wallet;
  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  PaymentMethodModel? get selectedMethod => _selectedMethod;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWallet() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Force mock
      await Future.delayed(const Duration(milliseconds: 400));
      _wallet = AppMockData.wallet;
    } catch (_) {
      _error = 'Failed to load wallet.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPaymentMethods() async {
    try {
      // Force mock
      await Future.delayed(const Duration(milliseconds: 300));
      _paymentMethods = AppMockData.paymentMethods;
      _selectedMethod = _paymentMethods.firstWhere(
        (m) => m.isDefault,
        orElse: () => _paymentMethods.first,
      );
      notifyListeners();
    } catch (_) {}
  }

  void selectPaymentMethod(PaymentMethodModel method) {
    _selectedMethod = method;
    notifyListeners();
  }

  Map<String, dynamic>? _lastPaymentResponse;
  Map<String, dynamic>? get lastPaymentResponse => _lastPaymentResponse;

  Future<StripePaymentOutcome> processPayment({
    required double amount,
    required String bookingId,
    String currency = 'cad',
  }) async {
    _isLoading = true;
    _error = null;
    _lastPaymentResponse = null;
    notifyListeners();

    final outcome = await StripePaymentService.instance.pay(
      amount: amount,
      bookingId: bookingId,
      currency: currency,
    );

    _lastPaymentResponse = outcome.paymentResponse;
    if (!outcome.isSuccess) {
      _error = outcome.message;
    }

    _isLoading = false;
    notifyListeners();
    return outcome;
  }
}

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ApiService _api = ApiService();

  List<NotificationModel> _notifications = [];
  List<FaqModel> _faqs = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  List<FaqModel> get faqs => _faqs;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Force mock
      await Future.delayed(const Duration(milliseconds: 400));
      _notifications = AppMockData.notifications;
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFaqs() async {
    // Force mock
    _faqs = AppMockData.faqs;
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = NotificationModel(
        id: _notifications[index].id,
        title: _notifications[index].title,
        body: _notifications[index].body,
        createdAt: _notifications[index].createdAt,
        isRead: true,
        type: _notifications[index].type,
        referenceId: _notifications[index].referenceId,
      );
      notifyListeners();
    }
  }
}
