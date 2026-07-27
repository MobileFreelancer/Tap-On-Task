import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_gradient_header.dart';

class MatchingTradersScreen extends StatelessWidget {
  final String taskId;
  const MatchingTradersScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppGradientHeader(
              height: 120.h,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24.sp),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'Matching Traders',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                      ),
                    ),
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
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We found 5 trusted professionals near you',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textGray500,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildMiniMap(),
                    SizedBox(height: 24.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        return _buildTraderCard(textTheme, index);
                      },
                    ),
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
          ),
          child: const Text('View Quotes'),
        ),
      ),
    );
  }

  Widget _buildMiniMap() {
    return Container(
      height: 150.h,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x200'), // Replace with map image
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Icon(Icons.location_on_rounded, color: AppColors.authPurple, size: 32.sp),
      ),
    );
  }

  Widget _buildTraderCard(TextTheme textTheme, int index) {
    final names = ['Mike Wilson', 'Sarah Smith', 'John Davis'];
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: const NetworkImage('https://via.placeholder.com/60'),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  names[index],
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: AppColors.warning, size: 14.sp),
                    Text(' 4.8', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                    Text(' (25 jobs completed)', style: TextStyle(fontSize: 12.sp, color: AppColors.textGray500)),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '10 years experience',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textGray600),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '\$40',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.authPurple,
                ),
              ),
              Text(
                '/hr',
                style: TextStyle(fontSize: 10.sp, color: AppColors.textGray500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
