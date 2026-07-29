import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapontask/core/theme/text_styles.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../auth/widgets/auth_scaffold.dart';

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
    final textTheme = Theme.of(context).textTheme;

    if (auth.isLoading && auth.currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: const ProfileShimmer(),
      );
    }

    final user = auth.currentUser;

    return AppHeader(
      title:'Profile' ,
      showBackButton: false,
      headerHeight: 120.h,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: 15.w,vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserCard(user, textTheme),
                SizedBox(height: 12.h),
                _buildSectionTitle('Account Management', textTheme),
                SizedBox(height: 12.h),
                _buildMenuGroup([
                  _ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profile',
                    iconBg: AppColors.surfaceBlue,
                    iconColor: AppColors.accentBlue,
                    onTap: () => context.pushNamed('editProfile'),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.shield_outlined,
                    label: 'Security',
                    iconBg: AppColors.surfaceGreen,
                    iconColor: AppColors.accentGreen,
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    iconBg: const Color(0xFFFFF7ED),
                    iconColor: AppColors.accentOrange,
                    onTap: () => context.pushNamed('notifications'),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.translate_rounded,
                    label: 'Language',
                    iconBg: AppColors.primarySurface,
                    iconColor: AppColors.authPurple,
                    trailing: 'English',
                    onTap: () {},
                  ),
                ], textTheme),
                SizedBox(height: 24.h),
                _buildSectionTitle('Support & More', textTheme),
                SizedBox(height: 12.h),
                _buildMenuGroup([
                  _ProfileMenuItem(
                    icon: Icons.headset_mic_outlined,
                    label: 'Contact Support',
                    iconBg: AppColors.surfaceGreen,
                    iconColor: AppColors.accentGreen,
                    onTap: () => context.pushNamed('help'),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    iconBg: const Color(0xFFFDF2F8),
                    iconColor: const Color(0xFFEC4899),
                    onTap: () {},
                  ),
                ], textTheme),
                SizedBox(height: 24.h),
                _buildLogoutTile(textTheme),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextTheme textTheme) {
    return Text(
      title,
      style: TextStylesInApp.robotoBody(
        fontWeight: FontWeight.w700,
        color: AppColors.authNavy,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildUserCard(UserModel? user, TextTheme textTheme) {
    final joinedDate = user != null
        ? DateFormat('MMM d, yyyy').format(user.createdAt)
        : 'May 25, 2025';

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        border: Border.all(color: AppColors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.primarySurface,
                backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                child: user?.avatarUrl == null
                    ? Text(
                        user?.initials ?? 'JA',
                        style: textTheme.headlineSmall?.copyWith(
                          color: AppColors.authPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => context.pushNamed('editProfile'),
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Icon(Icons.camera_alt_outlined, size: 14.sp, color: AppColors.textGray600),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'James Anderson',
                  style: TextStylesInApp.robotoBody(
                    fontWeight: FontWeight.w700,
                    color: AppColors.authNavy,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user?.phoneNumber ?? '+1 (647) 123-4567',
                  style: TextStylesInApp.robotoBody(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray500,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  user?.email ?? 'jamesander18@gmail.com',
                  style: TextStylesInApp.robotoBody(
                    color: AppColors.textGray500,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 12.sp, color: AppColors.textGray400),
                    SizedBox(width: 4.w),
                    Text(
                      joinedDate,
                      style: TextStylesInApp.robotoBody(
                        color: AppColors.textGray400,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup(List<_ProfileMenuItem> items, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        border: Border.all(color: AppColors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              if (index > 0) Divider(height: 1, indent: 60.w, color: AppColors.borderLight),
              ListTile(
                onTap: item.onTap,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                leading: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 16.sp),
                ),
                title: Text(
                  item.label,
                  style: TextStylesInApp.robotoBody(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: AppColors.authNavy
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.trailing != null)
                      Text(
                        item.trailing!,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textGray400,
                          fontSize: 12.sp,
                        ),
                      ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.authNavy, size: 25.sp),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutTile(TextTheme textTheme) {
    return GestureDetector(
      onTap: _isLoggingOut ? null : _handleLogout,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceRed,
          border: Border.all(color: AppColors.accentRed.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Logout',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (_isLoggingOut)
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.error),
              )
            else
              Icon(Icons.chevron_right_rounded, color: AppColors.error, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Out', style: Theme.of(ctx).textTheme.titleLarge),
        content: Text('Are you sure you want to log out?', style: Theme.of(ctx).textTheme.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Log Out', style: Theme.of(ctx).textTheme.labelLarge?.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isLoggingOut = true);
      await context.read<AuthService>().logout();
      if (mounted) {
        context.go('/splash');
      }
    }
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final String? trailing;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.iconBg,
    required this.iconColor,
    this.trailing,
    required this.onTap,
  });
}
