import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/app_bottom_nav.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/role_selection_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/search/screens/categories_screen.dart';
import '../../features/search/screens/service_listing_screen.dart';
import '../../features/booking/screens/service_detail_screen.dart';
import '../../features/booking/screens/booking_flow_screens.dart';
import '../../features/booking/screens/management_screens.dart';
import '../../features/customer/screens/my_tasks_screen.dart';
import '../../features/customer/screens/post_task_screen.dart';
import '../../features/trader/screens/trader_dashboard.dart';
import '../../features/trader/screens/available_tasks_screen.dart';
import '../../features/trader/screens/my_bids_screen.dart';
import '../../features/task/screens/task_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';

class AppRouter {
  AppRouter._();

  static final _authService = AuthService();

  static final _router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: _authService,
    redirect: _authGuard,
    routes: [
      // ----- Public / Auth Routes -----
      GoRoute(path: '/splash', name: 'splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/welcome', name: 'welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/role-selection', name: 'roleSelection', builder: (_, _) => const RoleSelectionScreen()),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, state) => LoginScreen(initialRole: state.uri.queryParameters['role'] ?? 'customer'),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (_, state) => SignupScreen(initialRole: state.uri.queryParameters['role'] ?? 'customer'),
      ),
      GoRoute(
        path: '/verify-otp',
        name: 'verifyOtp',
        builder: (_, state) => OtpVerificationScreen(
          phoneNumber: state.uri.queryParameters['phone'] ?? '',
          flow: state.uri.queryParameters['flow'] ?? 'verify',
        ),
      ),
      GoRoute(path: '/forgot-password', name: 'forgotPassword', builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(
        path: '/reset-password',
        name: 'resetPassword',
        builder: (_, state) => ResetPasswordScreen(phone: state.uri.queryParameters['phone']),
      ),

      // ----- Customer Shell (Bottom Nav) -----
      ShellRoute(
        builder: (context, state, child) {
          final index = _customerNavIndex(state.uri.path);
          return AppShell(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(path: '/customer/dashboard', name: 'customerDashboard', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/customer/search', name: 'search', builder: (_, _) => const SearchScreen()),
          GoRoute(path: '/customer/my-tasks', name: 'myTasks', builder: (_, _) => const MyTasksScreen()),
          GoRoute(path: '/customer/messages', name: 'messages', builder: (_, _) => const MessagesScreen()),
          GoRoute(path: '/profile', name: 'profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),

      // ----- Trader Shell (Bottom Nav) -----
      ShellRoute(
        builder: (context, state, child) {
          final index = _traderNavIndex(state.uri.path);
          return AppShell(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(path: '/trader/dashboard', name: 'traderDashboard', builder: (_, _) => const TraderDashboard()),
          GoRoute(path: '/trader/available-tasks', name: 'availableTasks', builder: (_, _) => const AvailableTasksScreen()),
          GoRoute(path: '/trader/my-bids', name: 'myBids', builder: (_, _) => const MyBidsScreen()),
          GoRoute(path: '/trader/messages', name: 'traderMessages', builder: (_, _) => const MessagesScreen()),
          GoRoute(path: '/trader/profile', name: 'traderProfile', builder: (_, _) => const ProfileScreen()),
        ],
      ),

      // ----- Feature Routes (outside shell) -----
      GoRoute(path: '/customer/post-task', name: 'postTask', builder: (_, _) => const PostTaskScreen()),
      GoRoute(path: '/categories', name: 'categories', builder: (_, _) => const CategoriesScreen()),
      GoRoute(
        path: '/service-listing',
        name: 'serviceListing',
        builder: (_, state) => ServiceListingScreen(
          categoryId: state.uri.queryParameters['categoryId'] ?? '',
          categoryName: state.uri.queryParameters['categoryName'] ?? 'Services',
        ),
      ),
      GoRoute(
        path: '/service/:serviceId',
        name: 'serviceDetail',
        builder: (_, state) => ServiceDetailScreen(serviceId: state.pathParameters['serviceId']!),
      ),
      GoRoute(
        path: '/provider/:providerId',
        name: 'providerDetail',
        builder: (_, state) => ProviderDetailScreen(providerId: state.pathParameters['providerId']!),
      ),
      GoRoute(
        path: '/location-select',
        name: 'locationSelect',
        builder: (_, state) => LocationSelectScreen(
          serviceId: state.uri.queryParameters['serviceId'],
          providerId: state.uri.queryParameters['providerId'],
          title: state.uri.queryParameters['title'] ?? '',
          price: state.uri.queryParameters['price'] ?? '0',
        ),
      ),
      GoRoute(
        path: '/booking-details',
        name: 'bookingDetails',
        builder: (_, state) => BookingDetailsScreen(
          title: state.uri.queryParameters['title'] ?? '',
          price: state.uri.queryParameters['price'] ?? '0',
          location: state.uri.queryParameters['location'] ?? '',
          scheduledAt: state.uri.queryParameters['scheduledAt'] ?? '',
          serviceId: state.uri.queryParameters['serviceId'],
          providerId: state.uri.queryParameters['providerId'],
        ),
      ),
      GoRoute(path: '/booking-success', name: 'bookingSuccess', builder: (_, _) => const BookingSuccessScreen()),
      GoRoute(
        path: '/quotes/:taskId',
        name: 'quotes',
        builder: (_, state) => QuotesScreen(taskId: state.pathParameters['taskId']!),
      ),
      GoRoute(
        path: '/tracking/:bookingId',
        name: 'tracking',
        builder: (_, state) => TrackingScreen(bookingId: state.pathParameters['bookingId']!),
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (_, state) => PaymentScreen(
          amount: state.uri.queryParameters['amount'] ?? '0',
          bookingId: state.uri.queryParameters['bookingId'] ?? '',
        ),
      ),
      GoRoute(path: '/wallet', name: 'wallet', builder: (_, _) => const WalletScreen()),
      GoRoute(path: '/notifications', name: 'notifications', builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: '/help', name: 'help', builder: (_, _) => const HelpSupportScreen()),
      GoRoute(
        path: '/task/:taskId',
        name: 'taskDetail',
        builder: (_, state) => TaskDetailScreen(taskId: state.pathParameters['taskId']!),
      ),
      GoRoute(path: '/profile/edit', name: 'editProfile', builder: (_, _) => const EditProfileScreen()),
    ],
    errorBuilder: (context, state) => _buildNotFound(context),
  );

  static GoRouter get router => _router;

  static int _customerNavIndex(String path) {
    if (path.startsWith('/customer/post-task')) return 0;
    if (path.startsWith('/categories')) return 1;
    if (path.startsWith('/customer/dashboard')) return 2;
    if (path.startsWith('/help')) return 3;
    if (path.startsWith('/profile')) return 4;
    return 2;
  }

  static int _traderNavIndex(String path) {
    if (path.startsWith('/trader/available-tasks')) return 0;
    if (path.startsWith('/categories')) return 1;
    if (path.startsWith('/trader/dashboard')) return 2;
    if (path.startsWith('/help')) return 3;
    if (path.startsWith('/trader/profile')) return 4;
    return 2;
  }

  static String? _authGuard(BuildContext context, GoRouterState state) {
    final auth = AuthService();
    final isLoggedIn = auth.isLoggedIn;
    final path = state.uri.path;

    final publicPaths = [
      '/splash',
      '/welcome',
      '/role-selection',
      '/login',
      '/signup',
      '/verify-otp',
      '/forgot-password',
      '/reset-password',
    ];

    if (path == '/splash') return null;

    if (!isLoggedIn && !publicPaths.contains(path)) {
      return '/role-selection';
    }

    if (isLoggedIn && publicPaths.contains(path) && path != '/splash') {
      if (auth.isCustomer) return '/customer/dashboard';
      if (auth.isTrader) return '/trader/dashboard';
    }

    return null;
  }

  static Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 80, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 24),
              Text('Page Not Found', style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: () => context.go('/role-selection'), child: const Text('Go Home')),
            ],
          ),
        ),
      ),
    );
  }
}
