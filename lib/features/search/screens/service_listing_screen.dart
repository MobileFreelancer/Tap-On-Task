import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/service_model.dart';
import '../../../core/services/app_services.dart';
import '../../../core/widgets/app_gradient_header.dart';

class ServiceListingScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ServiceListingScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  List<ServiceModel> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final searchService = context.read<SearchService>();
    _services = await searchService.getServicesByCategory(widget.categoryId);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          AppGradientHeader(
            height: 180.h,
            showBack: true,
            onBack: () => context.pop(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.categoryName,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Choose a Service that matches your needs',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _services.isEmpty
                        ? Center(
                            child: Text(
                              'No services in this category',
                              style: textTheme.bodyMedium?.copyWith(color: AppColors.textGray500),
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(20.w),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              childAspectRatio: 1,
                            ),
                            itemCount: _services.length,
                            itemBuilder: (_, i) {
                              return _ServiceGridItem(
                                service: _services[i],
                                onTap: () => context.pushNamed('locationSelect'),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceGridItem extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _ServiceGridItem({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90.h,
              child: Padding(
                padding:  EdgeInsets.all(5.w),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10.r),
                    image: const DecorationImage(
                      image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXrTgXOmC4FUVGct7i7I8j6dC6tAF6i7_vi2wRKZsrWw&s=10'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 40.w,
                      width: 40.w,
                decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    borderRadius: BorderRadius.circular(10.r),),
                      child: Icon(Icons.cleaning_services_outlined, color: AppColors.backgroundWhite)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                service.title,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: AppColors.authNavy,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
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
                                color: AppColors.textGray600,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
