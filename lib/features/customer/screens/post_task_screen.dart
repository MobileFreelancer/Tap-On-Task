import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/service_model.dart';
import '../../../core/services/app_services.dart';
import '../../../core/widgets/app_gradient_header.dart';
import '../providers/post_task_provider.dart';

class PostTaskScreen extends StatefulWidget {
  const PostTaskScreen({super.key});

  @override
  State<PostTaskScreen> createState() => _PostTaskScreenState();
}

class _PostTaskScreenState extends State<PostTaskScreen> {
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<PostTaskProvider>();
    _descriptionController = TextEditingController(text: provider.taskDescription);
    _budgetController = TextEditingController(text: provider.estimatedBudget > 0 ? provider.estimatedBudget.toString() : '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postTaskProvider = context.watch<PostTaskProvider>();
    final homeService = context.watch<HomeService>();
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
                    'Post a task',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tell us what you need, we\'ll help you find the right professional',
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Select Category', textTheme),
                      SizedBox(height: 12.h),
                      _buildCategoryDropdown(homeService, postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildSectionHeader('Task Description', textTheme, subtitle: 'Provide a detailed description of your task'),
                      SizedBox(height: 12.h),
                      _buildDescriptionField(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildPhotoSection(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildSectionHeader('Location', textTheme),
                      SizedBox(height: 12.h),
                      _buildLocationSection(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildSectionHeader('Preferred Date & Time', textTheme),
                      SizedBox(height: 12.h),
                      _buildDateTimeSection(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildSectionHeader('Set your estimated budget', textTheme, subtitle: '(optional)'),
                      SizedBox(height: 12.h),
                      _buildBudgetField(postTaskProvider, textTheme),
                      SizedBox(height: 32.h),
                      _buildContinueButton(postTaskProvider, textTheme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, TextTheme textTheme, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _getIconForTitle(title),
            SizedBox(width: 8.w),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.authNavy),
            ),
          ],
        ),
        if (subtitle != null)
          Padding(
            padding: EdgeInsets.only(left: 28.w),
            child: Text(subtitle, style: textTheme.bodySmall?.copyWith(color: AppColors.textGray500)),
          ),
      ],
    );
  }

  Widget _getIconForTitle(String title) {
    IconData icon = Icons.info_outline_rounded;
    if (title.contains('Category')) icon = Icons.grid_view_rounded;
    if (title.contains('Description')) icon = Icons.description_outlined;
    if (title.contains('Photos')) icon = Icons.image_outlined;
    if (title.contains('Location')) icon = Icons.location_on_outlined;
    if (title.contains('Date')) icon = Icons.calendar_today_outlined;
    if (title.contains('budget')) icon = Icons.monetization_on_outlined;
    return Icon(icon, color: AppColors.authNavy, size: 20.sp);
  }

  Widget _buildCategoryDropdown(HomeService homeService, PostTaskProvider provider, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(Icons.plumbing_rounded, color: AppColors.authPurple, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(child: Text('Plumbing', style: textTheme.bodyMedium)),
          Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGray500),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(PostTaskProvider provider, TextTheme textTheme) {
    return Column(
      children: [
        TextField(
          controller: _descriptionController,
          onChanged: provider.updateDescription,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe what needs to be done...',
            filled: true,
            fillColor: AppColors.backgroundGray.withValues(alpha: 0.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.borderLight)),
          ),
        ),
        SizedBox(height: 8.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('120/1000 characters', style: textTheme.labelSmall?.copyWith(color: AppColors.textGray500)),
        ),
      ],
    );
  }

  Widget _buildPhotoSection(PostTaskProvider provider, TextTheme textTheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('Add Photos (Optional)', textTheme),
            Text('Add Photos', style: TextStyle(color: AppColors.authPurple, fontWeight: FontWeight.w700, fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            ...List.generate(3, (index) => Container(
              width: 60.w,
              height: 60.h,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: const DecorationImage(image: NetworkImage('https://via.placeholder.com/60'), fit: BoxFit.cover),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(Icons.close_rounded, size: 12.sp, color: Colors.black),
                ),
              ),
            )),
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: AppColors.authPurple, size: 18.sp),
                  Text('Upload\nMore', textAlign: TextAlign.center, style: TextStyle(color: AppColors.authPurple, fontSize: 8.sp, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text('Provide a detailed description of your task', style: textTheme.labelSmall?.copyWith(color: AppColors.textGray500)),
      ],
    );
  }

  Widget _buildLocationSection(PostTaskProvider provider, TextTheme textTheme) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 100.w,
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: const DecorationImage(image: NetworkImage('https://via.placeholder.com/100x60'), fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('123 Maple Street', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  Text('Toronto, ON, Canada', style: textTheme.bodySmall?.copyWith(color: AppColors.textGray500)),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () => context.pushNamed('locationSelect'),
                    child: Text('Change Location >', style: TextStyle(color: AppColors.authPurple, fontWeight: FontWeight.w700, fontSize: 12.sp)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(PostTaskProvider provider, TextTheme textTheme) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(color: AppColors.backgroundGray.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8.r)),
            child: Row(children: [Icon(Icons.calendar_today_outlined, size: 16.sp, color: AppColors.textGray500), SizedBox(width: 8.w), Text('May 25, 2025', style: textTheme.bodySmall)]),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(color: AppColors.backgroundGray.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8.r)),
            child: Row(children: [Icon(Icons.access_time_rounded, size: 16.sp, color: AppColors.textGray500), SizedBox(width: 8.w), Text('10:00 AM - 12:00 PM', style: textTheme.bodySmall)]),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetField(PostTaskProvider provider, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount', style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: 8.h),
        TextField(
          controller: _budgetController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.attach_money_rounded, size: 20.sp, color: AppColors.textGray500),
            hintText: '100',
            filled: true,
            fillColor: AppColors.backgroundGray.withValues(alpha: 0.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 14.sp, color: AppColors.textGray500),
            SizedBox(width: 8.w),
            Expanded(child: Text('Quotes may vary based on market rates and job requirements', style: textTheme.labelSmall?.copyWith(color: AppColors.textGray500))),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton(PostTaskProvider provider, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleSubmit(provider),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.authPurple, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 16.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), elevation: 0),
        child: const Text('Continue to Review', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Future<void> _handleSubmit(PostTaskProvider provider) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PostTaskSuccessScreen()));
  }
}

class PostTaskSuccessScreen extends StatelessWidget {
  const PostTaskSuccessScreen({super.key});

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
            onBack: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
              child: Text(
                'Success',
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                ),
              ),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your task is now live.',
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.authNavy,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Nearby professionals will start sending quotes soon.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textGray500,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<PostTaskProvider>().reset();
                            context.pushNamed('matchingTraders', pathParameters: {'taskId': 'demo_task_id'});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.authPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            elevation: 0,
                          ),
                          child: const Text('View My Task', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
