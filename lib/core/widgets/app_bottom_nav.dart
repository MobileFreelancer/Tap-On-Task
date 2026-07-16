import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../generated/assets.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onHomeTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onHomeTap,
  });

  static const _customerItems = [
    _NavItem(iconAsset: AppAssets.bottomBarPostTaskIcon, label: 'Post Task', route: '/customer/post-task', isShell: false, index: 0),
    _NavItem(iconAsset: AppAssets.bottomBarCategoryIcon, label: 'Categories', route: '/categories', isShell: false, index: 1),
    _NavItem(iconAsset: AppAssets.bottomBarSupportIcon, label: 'Help & Support', route: '/help', isShell: false, index: 3),
    _NavItem(iconAsset: AppAssets.bottomBarProfileIcon, label: 'Profile', route: '/profile', index: 4),
  ];

  static const _traderItems = [
    _NavItem(iconAsset: AppAssets.bottomBarPostTaskIcon, label: 'Tasks', route: '/trader/available-tasks', index: 0),
    _NavItem(iconAsset: AppAssets.bottomBarCategoryIcon, label: 'Categories', route: '/categories', isShell: false, index: 1),
    _NavItem(iconAsset: AppAssets.bottomBarSupportIcon, label: 'Help & Support', route: '/help', isShell: false, index: 3),
    _NavItem(iconAsset: AppAssets.bottomBarProfileIcon, label: 'Profile', route: '/trader/profile', index: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final auth = context.watch<AuthService>();
    final items = auth.isCustomer ? _customerItems : _traderItems;
    final leftItems = items.where((i) => i.index < 2).toList();
    final rightItems = items.where((i) => i.index > 2).toList();

    final barHeight = 64.h;
    final fabSize = 60.w;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final totalBarHeight = barHeight + bottomPad;

    return SizedBox(
      height: barHeight + fabSize * 0.45 + bottomPad,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: totalBarHeight,
            child: CustomPaint(
              painter: _CurvedBottomBarPainter(
                notchRadius: fabSize / 2 + 6.w,
                barContentHeight: barHeight,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPad,
            height: barHeight,
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, left: 8.w, right: 8.w),
              child: Row(
                children: [
                  for (final item in leftItems)
                    Expanded(
                      child: _NavTile(
                        item: item,
                        isSelected: currentIndex == item.index,
                        textTheme: textTheme,
                        onTap: () => _navigate(context, item),
                      ),
                    ),
                  SizedBox(width: fabSize + 12.w),
                  for (final item in rightItems)
                    Expanded(
                      child: _NavTile(
                        item: item,
                        isSelected: currentIndex == item.index,
                        textTheme: textTheme,
                        onTap: () => _navigate(context, item),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: barHeight - fabSize * 0.42 + bottomPad,
            child: GestureDetector(
              onTap: onHomeTap,
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.authPurple,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.authPurple.withValues(alpha: 0.35),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    AppAssets.bottomBarHomeIcon,
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, _NavItem item) {
    if (item.isShell) {
      context.go(item.route);
    } else {
      context.push(item.route);
    }
  }
}

class _CurvedBottomBarPainter extends CustomPainter {
  final double notchRadius;
  final double barContentHeight;

  _CurvedBottomBarPainter({
    required this.notchRadius,
    required this.barContentHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.backgroundWhite
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = _buildPath(size);
    canvas.drawPath(path.shift(const Offset(0, -2)), shadowPaint);
    canvas.drawPath(path, paint);
  }

  Path _buildPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final r = notchRadius;
    const margin = 6.0;

    path.moveTo(0, 0);
    path.lineTo(centerX - r - margin, 0);
    path.arcToPoint(
      Offset(centerX + r + margin, 0),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, barContentHeight);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, barContentHeight);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _CurvedBottomBarPainter oldDelegate) {
    return oldDelegate.notchRadius != notchRadius ||
        oldDelegate.barContentHeight != barContentHeight;
  }
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.authPurple : AppColors.authNavy;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            item.iconAsset,
            width: 22.w,
            height: 22.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 3.h),
          Text(
            item.label,
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 9.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String iconAsset;
  final String label;
  final String route;
  final int index;
  final bool isShell;

  const _NavItem({
    required this.iconAsset,
    required this.label,
    required this.route,
    required this.index,
    this.isShell = true,
  });
}

class AppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final homeRoute = auth.isCustomer ? '/customer/dashboard' : '/trader/dashboard';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      extendBody: true,
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onHomeTap: () {
          if (currentIndex != 2) context.go(homeRoute);
        },
      ),
    );
  }
}
