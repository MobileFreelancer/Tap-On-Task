import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/api_category_model.dart';
import '../../../core/models/service_model.dart';
import '../../../core/services/app_services.dart';
import '../../../core/widgets/app_gradient_header.dart';
import '../../customer/providers/post_task_provider.dart';

class ServiceListingScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ServiceListingScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PostTaskProvider>();
      if (provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<PostTaskProvider>();
    
    // Find the current category and its subcategories
    ApiCategory? currentCategory;
    try {
      currentCategory = provider.categories.firstWhere(
        (c) => c.id.toString() == widget.categoryId,
      );
    } catch (_) {
      currentCategory = null;
    }

    final subcategories = currentCategory?.subcategories ?? [];
    final isLoading = provider.isLoadingCategories && provider.categories.isEmpty;

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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : subcategories.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded, size: 64.sp, color: AppColors.textGray400),
                                SizedBox(height: 16.h),
                                Text(
                                  'No specific services found',
                                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textGray500),
                                ),
                                if (provider.categoryError != null) ...[
                                  SizedBox(height: 8.h),
                                  ElevatedButton(
                                    onPressed: () => provider.fetchCategories(),
                                    child: const Text('Retry'),
                                  ),
                                ]
                              ],
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
                            itemCount: subcategories.length,
                            itemBuilder: (_, i) {
                              return _ServiceGridItem(
                                subcategory: subcategories[i],
                                categoryName: widget.categoryName,
                                onTap: () {
                                  // Update provider state
                                  provider.selectCategory(widget.categoryId);
                                  provider.selectSubcategory(subcategories[i].id.toString());

                                  // Navigate to location selection
                                  context.pushNamed('locationSelect');
                                },
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
  final ApiSubcategory subcategory;
  final String categoryName;
  final VoidCallback onTap;

  const _ServiceGridItem({
    required this.subcategory,
    required this.categoryName,
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
                                subcategory.name,
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
                            Expanded(
                              child: Text(
                                subcategory.slug,
                                style: textTheme.labelSmall?.copyWith(
                                  color: AppColors.textGray600,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
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
            ),
          ],
        ),
      ),
    );
  }
}
