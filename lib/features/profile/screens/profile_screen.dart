import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/shimmer_loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    if (auth.isLoading && auth.currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundOffWhite,
        appBar: AppBar(title: const Text('Profile')),
        body: const ProfileShimmer(),
      );
    }

    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 8),
            if (user?.role == UserRole.trader) _buildTraderStats(user!),
            if (user?.role == UserRole.customer) _buildCustomerStats(user!),
            const SizedBox(height: 8),
            _buildMenuSection(context, user),
            const SizedBox(height: 8),
            _buildLogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: user?.role == UserRole.trader
                    ? AppColors.surfaceYellow
                    : AppColors.primarySurface,
                child: Text(
                  user?.initials ?? 'U',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: user?.role == UserRole.trader
                        ? AppColors.accentOrange
                        : AppColors.primaryPurple,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => context.pushNamed('editProfile'),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.backgroundWhite, width: 2),
                    ),
                    child: const Icon(Icons.edit_rounded, size: 14, color: AppColors.backgroundWhite),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? 'User',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? user?.phoneNumber ?? '',
            style: const TextStyle(fontSize: 14, color: AppColors.textGray500),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: user?.role == UserRole.trader
                  ? AppColors.surfaceYellow
                  : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user?.role == UserRole.trader ? 'Tech / Trader' : 'Customer',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: user?.role == UserRole.trader
                    ? AppColors.accentOrange
                    : AppColors.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraderStats(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.star_rounded, user.rating.toStringAsFixed(1), 'Rating', AppColors.accentOrange),
          _buildStatItem(Icons.task_alt_rounded, '${user.completedTasks}', 'Completed', AppColors.accentGreen),
          _buildStatItem(Icons.assignment_rounded, '${user.taskCount}', 'Total Tasks', AppColors.primaryPurple),
        ],
      ),
    );
  }

  Widget _buildCustomerStats(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.star_rounded, user.rating.toStringAsFixed(1), 'Rating', AppColors.accentOrange),
          _buildStatItem(Icons.assignment_rounded, '${user.taskCount}', 'Tasks Posted', AppColors.primaryPurple),
          _buildStatItem(Icons.check_circle_rounded, '${user.completedTasks}', 'Completed', AppColors.accentGreen),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray500)),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, UserModel? user) {
    final menuItems = [
      _MenuItem(icon: Icons.person_rounded, title: 'Edit Profile', route: 'editProfile'),
      _MenuItem(icon: Icons.assignment_rounded, title: 'My Bookings', route: 'myTasks'),
      _MenuItem(icon: Icons.notifications_outlined, title: 'Notifications', route: 'notifications'),
      _MenuItem(icon: Icons.wallet_rounded, title: 'Wallet', route: 'wallet'),
      _MenuItem(icon: Icons.credit_card_rounded, title: 'Payment Methods', route: 'payment'),
      _MenuItem(icon: Icons.help_outline_rounded, title: 'Help & Support', route: 'help'),
      _MenuItem(icon: Icons.info_outline_rounded, title: 'About', route: null),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return Column(
            children: [
              if (index > 0) const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(item.icon, color: AppColors.textGray600, size: 22),
                title: Text(item.title, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textGray400),
                onTap: () {
                  if (item.route != null) {
                    if (item.route == 'editProfile') {
                      context.pushNamed(item.route!);
                    } else if (item.route == 'myTasks') {
                      context.goNamed(item.route!);
                    } else if (item.route == 'payment') {
                      context.pushNamed(item.route!, queryParameters: {'amount': '0', 'bookingId': ''});
                    } else {
                      context.pushNamed(item.route!);
                    }
                  }
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LoadingButton(
        label: 'Log Out',
        isLoading: _isLoggingOut,
        backgroundColor: AppColors.surfaceRed,
        foregroundColor: AppColors.error,
        onPressed: () => _handleLogout(),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isLoggingOut = true);
      await context.read<AuthService>().logout();
      if (mounted) {
        context.go('/role-selection');
      }
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? route;
  const _MenuItem({required this.icon, required this.title, this.route});
}
