import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_gradient_header.dart';
import '../providers/post_task_provider.dart';

class MatchingTradersScreen extends StatelessWidget {
  final String taskId;
  const MatchingTradersScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final postTaskProvider = context.watch<PostTaskProvider>();

    // Mock profiles with different photos matching the style
    final mockTraders = [
      _TraderMock(
        name: 'Mike Wilson',
        rating: '4.8',
        category: 'Plumber',
        price: 'CAD ${postTaskProvider.estimatedBudget > 0 ? postTaskProvider.estimatedBudget.toInt() : 120}',
        experience: '10+ years experience',
        distance: '2 Km away',
        jobsCompleted: '8 jobs completed nearby',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop',
      ),
      _TraderMock(
        name: 'Sarah Smith',
        rating: '4.9',
        category: 'Electrician',
        price: 'CAD 150',
        experience: '8+ years experience',
        distance: '3 Km away',
        jobsCompleted: '15 jobs completed nearby',
        imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop',
      ),
      _TraderMock(
        name: 'John Davis',
        rating: '4.7',
        category: 'Handyman',
        price: 'CAD 90',
        experience: '5 years experience',
        distance: '1.5 Km away',
        jobsCompleted: '5 jobs completed nearby',
        imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppGradientHeader(
              height: 160.h,
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, MediaQuery.paddingOf(context).top + 10.h, 20.w, 20.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.chevron_left_rounded, color: AppColors.authPurple, size: 24.sp),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Matching Traders',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'We found 12 qualified professionals near you',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                ),
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTaskSummaryCard(textTheme, postTaskProvider),
                    SizedBox(height: 20.h),
                    _buildMiniMap(),
                    SizedBox(height: 24.h),
                    ...List.generate(mockTraders.length, (index) {
                      final trader = mockTraders[index];
                      return _buildTraderCard(
                        textTheme: textTheme,
                        name: trader.name,
                        rating: trader.rating,
                        category: trader.category,
                        price: trader.price,
                        experience: trader.experience,
                        distance: trader.distance,
                        jobsCompleted: trader.jobsCompleted,
                        isAvailableToday: true,
                        buttonText: 'View Profile',
                        onButtonPressed: () {
                          context.pushNamed('quotes', pathParameters: {'taskId': taskId});
                        },
                        imageUrl: trader.imageUrl,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => context.pushNamed('quotes', pathParameters: {'taskId': taskId}),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.authPurple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            elevation: 0,
          ),
          child: const Text('View Quotes', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTaskSummaryCard(TextTheme textTheme, PostTaskProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.build_circle_outlined, color: AppColors.authPurple, size: 20.sp),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Your Task',
                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.authNavy),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Wait, no need to navigate, or navigate back to edit
                },
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: AppColors.authPurple, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Edit Task',
                      style: TextStyle(
                        color: AppColors.authPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            provider.taskDescription.isNotEmpty ? provider.taskDescription : 'Fix leaking kitchen sink',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.authPurple, size: 16.sp),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  provider.location.isNotEmpty ? provider.location : '123 Maple street, toronto, ON, Canada',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.textGray600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMap() {
    return Container(
      height: 155.h,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/mock_map.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12.w,
            bottom: 12.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Sort by: Best Match',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.textGray700),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 14.sp, color: AppColors.textGray600),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12.w,
            bottom: 12.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.map_outlined, size: 14.sp, color: AppColors.authPurple),
                  SizedBox(width: 4.w),
                  Text(
                    'View on Map',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: AppColors.authPurple),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraderCard({
    required TextTheme textTheme,
    required String name,
    required String rating,
    required String category,
    required String price,
    required String experience,
    required String distance,
    required String jobsCompleted,
    required bool isAvailableToday,
    required String buttonText,
    required VoidCallback onButtonPressed,
    required String imageUrl,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              imageUrl,
              width: 80.w,
              height: 90.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80.w,
                  height: 90.h,
                  color: Colors.grey[200],
                  child: Icon(Icons.person, color: Colors.grey[400]),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.authNavy,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber[700], size: 12.sp),
                          SizedBox(width: 2.w),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textGray500),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Fixed Price ',
                        style: TextStyle(fontSize: 11.sp, color: AppColors.textGray500),
                        children: [
                          TextSpan(
                            text: price,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      experience,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textGray500),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red[400], size: 12.sp),
                        SizedBox(width: 2.w),
                        Text(
                          distance,
                          style: TextStyle(fontSize: 11.sp, color: AppColors.textGray500),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  jobsCompleted,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textGray500),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isAvailableToday)
                      Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Available Today',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    SizedBox(
                       height: 28.h,
                      child: ElevatedButton(
                        onPressed: onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.authPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          buttonText,
                          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
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
}

class _TraderMock {
  final String name;
  final String rating;
  final String category;
  final String price;
  final String experience;
  final String distance;
  final String jobsCompleted;
  final String imageUrl;

  _TraderMock({
    required this.name,
    required this.rating,
    required this.category,
    required this.price,
    required this.experience,
    required this.distance,
    required this.jobsCompleted,
    required this.imageUrl,
  });
}
