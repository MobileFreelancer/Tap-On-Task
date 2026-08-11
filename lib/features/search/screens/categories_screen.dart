import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/api_category_model.dart';
import '../../customer/providers/post_task_provider.dart';
import '../../../core/widgets/app_gradient_header.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postTaskProvider = context.read<PostTaskProvider>();
      if (postTaskProvider.categories.isEmpty) {
        postTaskProvider.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostTaskProvider>();
    final categories = provider.categories;
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
                    'Categories',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Choose a category to find trusted professionals',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.85),
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
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
                      child: _buildSearchBar(textTheme),
                    ),
                    Expanded(
                      child: provider.isLoadingCategories
                          ? const Center(child: CircularProgressIndicator())
                          : provider.categoryError != null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Error: ${provider.categoryError}'),
                                      ElevatedButton(
                                        onPressed: () => provider.fetchCategories(),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                )
                              : categories.isEmpty
                                  ? const Center(child: Text('No categories found'))
                                  : GridView.builder(
                                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 12.h,
                                        crossAxisSpacing: 12.w,
                                        childAspectRatio: 0.9,
                                      ),
                                      itemCount: categories.length,
                                      itemBuilder: (_, i) {
                                        final cat = categories[i];
                                        return _CategoryGridItem(
                                          category: cat,
                                          onTap: () => context.pushNamed('serviceListing', queryParameters: {
                                            'categoryId': cat.id.toString(),
                                            'categoryName': cat.name,
                                          }),
                                        );
                                      },
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.textGray400, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Choose a category',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textGray400,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final ApiCategory category;
  final VoidCallback onTap;

  const _CategoryGridItem({
    required this.category,
    required this.onTap,
  });



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              // decoration: BoxDecoration(
              //   color: AppColors.primarySurface,
              //   shape: BoxShape.circle,
              // ),
              child: SvgPicture.network(
                category.iconPath.toString(),
                fit: BoxFit.cover,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: AppColors.authPurple, size: 20.sp);
                },
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              category.name,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
                color: AppColors.authNavy,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
