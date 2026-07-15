import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  static const _customerItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home', route: '/customer/dashboard'),
    _NavItem(icon: Icons.search_rounded, label: 'Search', route: '/customer/search'),
    _NavItem(icon: Icons.assignment_rounded, label: 'My Tasks', route: '/customer/my-tasks'),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Messages', route: '/customer/messages'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile', route: '/profile'),
  ];

  static const _traderItems = [
    _NavItem(icon: Icons.explore_rounded, label: 'Explore', route: '/trader/dashboard'),
    _NavItem(icon: Icons.assignment_rounded, label: 'Tasks', route: '/trader/available-tasks'),
    _NavItem(icon: Icons.handshake_rounded, label: 'My Bids', route: '/trader/my-bids'),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Messages', route: '/trader/messages'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile', route: '/trader/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final items = auth.isCustomer ? _customerItems : _traderItems;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = index == currentIndex;
              final item = items[index];
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (!isSelected) context.go(item.route);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? AppColors.primaryPurple : AppColors.textGray400,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.primaryPurple : AppColors.textGray400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({required this.icon, required this.label, required this.route});
}

class AppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(currentIndex: currentIndex),
    );
  }
}
