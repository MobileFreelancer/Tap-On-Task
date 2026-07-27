import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/services/app_services.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_gradient_header.dart';
import '../../../core/widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeService>().fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeService = context.watch<HomeService>();
    final auth = context.watch<AuthService>();
    final textTheme = Theme.of(context).textTheme;
    final userName = auth.currentUser?.name?.split(' ').first ?? 'John';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: homeService.isLoading
          ? const _HomeShimmer()
          : RefreshIndicator(
              onRefresh: () => homeService.fetchHomeData(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AppGradientHeader(
                      height: 200,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi, $userName',
                                        style: textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'How can we help you today?',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.white.withValues(alpha: 0.85),
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _HeaderIconButton(
                                  icon: Icons.notifications_outlined,
                                  onTap: () => context.pushNamed('notifications'),
                                ),
                                SizedBox(width: 8.w),
                                _HeaderIconButton(
                                  icon: Icons.person_outline_rounded,
                                  onTap: () => context.go('/profile'),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            _buildSearchBar(textTheme),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, -20.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 14.h),
                              _buildPromoBanner(textTheme),
                              SizedBox(height: 24.h),
                              _buildSectionHeader('Recent Searches', textTheme),
                              SizedBox(height: 12.h),
                              _buildRecentSearches(textTheme),
                              SizedBox(height: 24.h),
                              _buildSectionHeader('Popular Category', textTheme, onViewAll: () => context.pushNamed('categories')),
                              SizedBox(height: 12.h),
                              _buildPopularCategories(homeService, textTheme),
                              SizedBox(height: 24.h),
                              _buildSectionHeader('Nearby Professionals', textTheme),
                              SizedBox(height: 12.h),
                              _buildNearbyProfessionals(homeService, textTheme),
                              SizedBox(height: 24.h),
                              _buildSectionHeader('Quick Services', textTheme, onViewAll: () => context.pushNamed('categories')),
                              SizedBox(height: 12.h),
                              _buildQuickServices(homeService, textTheme),
                              SizedBox(height: 24.h),
                              _buildSectionHeader('Active job', textTheme, onViewAll: () => context.pushNamed('myTasks')),
                              SizedBox(height: 12.h),
                              if (homeService.recentBookings.isNotEmpty)
                                _buildJobCard(homeService.recentBookings.first, textTheme, isActive: true),
                              SizedBox(height: 24.h),
                              _buildSectionHeader('Upcoming Job', textTheme, onViewAll: () => context.pushNamed('myTasks')),
                              SizedBox(height: 12.h),
                              ...homeService.recentBookings.skip(1).take(3).map(
                                    (b) => Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: _buildJobCard(b, textTheme),
                                    ),
                                  ),
                              if (homeService.recentBookings.length > 3)
                                Center(
                                  child: TextButton(
                                    onPressed: () => context.pushNamed('myTasks'),
                                    child: Text(
                                      'See More',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: AppColors.authPurple,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('postTask'),
        backgroundColor: AppColors.authPurple,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildSearchBar(TextTheme textTheme) {
    return GestureDetector(
      onTap: () => context.pushNamed('search'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.textGray400, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'What service do you need?',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGray400,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.authPurple,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.tune_rounded, color: Colors.white, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner(TextTheme textTheme) {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B21B6), Color(0xFF7D30FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Need Help',
                    style: textTheme.labelMedium?.copyWith(color: Colors.white, fontSize: 11.sp),
                  ),
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () => context.pushNamed('jobConfirmation'),
                  child: Text(
                    'with Home Services?',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Trusted professionals at your service',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.engineering_rounded, color: Colors.white.withValues(alpha: 0.6), size: 64.sp),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(TextTheme textTheme) {
    final recentSearches = ['Plumbing', 'Electrician', 'Cleaning', 'HVAC'];
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: recentSearches.map((search) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_rounded, size: 14.sp, color: AppColors.authPurple),
              SizedBox(width: 4.w),
              Text(
                search,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.authPurple,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, TextTheme textTheme, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: AppColors.authNavy,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'View All',
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.authNavy,
                fontSize: 13.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPopularCategories(HomeService homeService, TextTheme textTheme) {
    final categories = homeService.categories.take(4).toList();
    return Row(
      children: categories.map((cat) {
        return Expanded(
          child: GestureDetector(
            onTap: () => context.pushNamed('serviceListing', queryParameters: {
              'categoryId': cat.id,
              'categoryName': cat.name,
            }),
            child: Container(
              margin: EdgeInsets.only(right: cat != categories.last ? 8.w : 0),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Icon(cat.icon, color: AppColors.authNavy, size: 28.sp),
                  SizedBox(height: 8.h),
                  Text(
                    cat.name,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNearbyProfessionals(HomeService homeService, TextTheme textTheme) {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: homeService.nearbyProviders.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) {
          final provider = homeService.nearbyProviders[i];
          return Container(
            width: 280.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(color: AppColors.shadowLight, blurRadius: 8.r, offset: Offset(0, 2.h)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: AppColors.primarySurface,
                  child: Text(
                    provider.name.isNotEmpty ? provider.name[0] : 'P',
                    style: textTheme.titleLarge?.copyWith(color: AppColors.authPurple),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        provider.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: AppColors.authNavy
                        ),
                      ),
                      Text(
                        provider.title,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textGray500,
                          fontSize: 12.sp,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_pin, color: AppColors.authNavy, size: 14.sp),

                          SizedBox(width: 8.w),
                          Text(
                            '${(provider.distanceKm ?? 0).toStringAsFixed(0)} km away',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textGray400,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.w),
                      TextButton(
                        onPressed: () => context.pushNamed('providerDetail', pathParameters: {'providerId': provider.id}),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(5.w)))
                        ),
                        child: Text(
                          'View Profile',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textWhite,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.pushNamed('providerDetail', pathParameters: {'providerId': provider.id}),
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.textWhite,
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.textGrayF9),borderRadius: BorderRadiusGeometry.all(Radius.circular(5.w)))
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: AppColors.accentOrange, size: 14.sp),
                      SizedBox(width: 2.w),
                      Text(
                        provider.rating.toString(),
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textGray500,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickServices(HomeService homeService, TextTheme textTheme) {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: homeService.popularServices.take(4).length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) {
          final service = homeService.popularServices[i];
          return GestureDetector(
            onTap: () => context.pushNamed('serviceDetail', pathParameters: {'serviceId': service.id}),
            child: Container(
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                    ),
                    child: Center(
                      child: Icon(Icons.home_repair_service_rounded, color: AppColors.authPurple, size: 36.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: const BoxDecoration(
                                color: AppColors.accentGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Available Now',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.accentGreen,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobCard(BookingModel booking, TextTheme textTheme, {bool isActive = false}) {
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');
    final dayFormat = DateFormat('EEEE');

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isActive ? AppColors.accentGreen : AppColors.borderLight,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: isActive ? AppColors.authNavy : AppColors.primarySurface,
            child: Text(
              _initials(booking.providerName ?? booking.title),
              style: textTheme.labelMedium?.copyWith(
                color: isActive ? Colors.white : AppColors.authPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.providerName ?? booking.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  booking.categoryName ?? 'Service',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textGray500,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dayFormat.format(booking.scheduledAt),
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                dateFormat.format(booking.scheduledAt),
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textGray400,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'J';
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.authPurple, size: 20.sp),
      ),
    );
  }
}

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          ShimmerBox(height: 180.h, width: double.infinity),
          SizedBox(height: 16.h),
          ShimmerBox(height: 130.h, width: double.infinity),
          SizedBox(height: 24.h),
          ShimmerBox(height: 100.h, width: double.infinity),
          SizedBox(height: 12.h),
          ShimmerBox(height: 100.h, width: double.infinity),
        ],
      ),
    );
  }
}
