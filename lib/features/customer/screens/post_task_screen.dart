import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
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
                      _buildSectionLabel('Select Category', textTheme),
                      SizedBox(height: 8.h),
                      _buildCategoryDropdown(homeService, postTaskProvider),
                      SizedBox(height: 24.h),
                      _buildSectionLabelWithIcon(Icons.description_outlined, 'Task Description', textTheme, subtitle: 'Provide a detailed description of your task'),
                      SizedBox(height: 12.h),
                      _buildDescriptionField(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildPhotoSection(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildSectionLabelWithIcon(Icons.location_on_outlined, 'Location', textTheme),
                      SizedBox(height: 12.h),
                      _buildLocationSection(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildSectionLabelWithIcon(Icons.calendar_today_outlined, 'Preferred Date & Time', textTheme),
                      SizedBox(height: 12.h),
                      _buildDateTimeSection(postTaskProvider, textTheme),
                      SizedBox(height: 24.h),
                      _buildSectionLabelWithIcon(Icons.monetization_on_outlined, 'Set your estimated budget', textTheme, subtitle: '(optional)'),
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

  Widget _buildSectionLabel(String label, TextTheme textTheme) {
    return Text(label, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.authNavy));
  }

  Widget _buildSectionLabelWithIcon(IconData icon, String label, TextTheme textTheme, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.authNavy, size: 20.sp),
            SizedBox(width: 8.w),
            Text(label, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.authNavy)),
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

  Widget _buildCategoryDropdown(HomeService homeService, PostTaskProvider provider) {
    final categories = homeService.categories;
    final value = categories.any((c) => c.id == provider.selectedCategoryId)
        ? provider.selectedCategoryId
        : (categories.isNotEmpty ? categories.first.id : null);

    if (value != null && provider.selectedCategoryId != value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.selectCategory(value);
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          prefixIcon: Icon(Icons.grid_view_rounded, color: AppColors.authPurple, size: 20.sp),
        ),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGray500),
        items: categories.map((c) {
          return DropdownMenuItem<String>(
            value: c.id,
            child: Text(c.name),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            provider.selectCategory(val);
          }
        },
      ),
    );
  }

  Widget _buildDescriptionField(PostTaskProvider provider, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _descriptionController,
          onChanged: provider.updateDescription,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'I need a plumber to fix leaking kitchen sink...',
            filled: true,
            fillColor: AppColors.backgroundGray.withOpacity(0.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.borderLight)),
          ),
        ),
        SizedBox(height: 8.h),
        Text('${provider.taskDescription.length}/1000 characters', style: textTheme.labelSmall?.copyWith(color: AppColors.textGray500)),
      ],
    );
  }

  Widget _buildPhotoSection(PostTaskProvider provider, TextTheme textTheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionLabelWithIcon(Icons.image_outlined, 'Add Photos (Optional)', textTheme),
            GestureDetector(
              onTap: () {
                provider.addPhoto('photo${provider.selectedPhotos.length + 1}');
              },
              child: Text('Add Photos', style: TextStyle(color: AppColors.authPurple, fontWeight: FontWeight.w700, fontSize: 12.sp)),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(provider.selectedPhotos.length, (index) => Container(
                width: 80.w,
                height: 80.h,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Icon(Icons.image, color: AppColors.textGray400, size: 24.sp),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          provider.removePhoto(index);
                        },
                        child: Container(
                          margin: EdgeInsets.all(4.w),
                          padding: EdgeInsets.all(2.w),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.close_rounded, size: 14.sp, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              GestureDetector(
                onTap: () {
                  provider.addPhoto('photo${provider.selectedPhotos.length + 1}');
                },
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: AppColors.authPurple, size: 24.sp),
                      Text('Upload\nMore', textAlign: TextAlign.center, style: TextStyle(color: AppColors.authPurple, fontSize: 10.sp, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Provide a detailed description of your task', style: textTheme.labelSmall?.copyWith(color: AppColors.textGray500)),
        ),
      ],
    );
  }

  Widget _buildLocationSection(PostTaskProvider provider, TextTheme textTheme) {
    final locationText = provider.location.isNotEmpty ? provider.location : 'Select Location';
    final parts = locationText.split(',');
    final mainAddress = parts.first;
    final detailsAddress = parts.length > 1 ? parts.sublist(1).join(',').trim() : '';

    return Row(
      children: [
        Container(
          width: 100.w,
          height: 65.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: const DecorationImage(
              image: AssetImage('assets/images/mock_map.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mainAddress, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              if (detailsAddress.isNotEmpty)
                Text(detailsAddress, style: textTheme.bodySmall?.copyWith(color: AppColors.textGray500), maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () async {
                  final newLoc = await context.pushNamed('locationSelect');
                  if (newLoc != null && newLoc is String) {
                    provider.updateLocation(newLoc);
                  }
                },
                child: Text('Change Location >', style: TextStyle(color: AppColors.authPurple, fontWeight: FontWeight.w700, fontSize: 12.sp)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(PostTaskProvider provider, TextTheme textTheme) {
    final dateStr = provider.preferredDate != null
        ? DateFormat('MMM dd, yyyy').format(provider.preferredDate!)
        : 'Select Date';
    final timeStr = provider.preferredTime.isNotEmpty
        ? provider.preferredTime
        : 'Select Time';

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: provider.preferredDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (pickedDate != null) {
                provider.setPreferredDate(pickedDate);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.backgroundGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16.sp, color: AppColors.textGray500),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      dateStr,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                provider.setPreferredTime(pickedTime.format(context));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.backgroundGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 16.sp, color: AppColors.textGray500),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      timeStr,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
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
          keyboardType: TextInputType.number,
          onChanged: (val) {
            provider.updateBudget(double.tryParse(val) ?? 0.0);
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.attach_money_rounded),
            hintText: '100',
            filled: true,
            fillColor: AppColors.backgroundGray.withOpacity(0.5),
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
      body: Stack(
        children: [
          AppGradientHeader(height: 300.h, child: const SizedBox.shrink()),
          Positioned(
            top: 50.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24.sp),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Success', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                  SizedBox(height: 40.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Your task is now live.', textAlign: TextAlign.center, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.authNavy)),
                        SizedBox(height: 12.h),
                        Text('Nearby professionals will start sending quotes soon.', textAlign: TextAlign.center, style: textTheme.bodyMedium?.copyWith(color: AppColors.textGray500)),
                        SizedBox(height: 32.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                            context.read<PostTaskProvider>().reset();
                            // First remove the Success screen
                            Navigator.pop(context);
                            // Then navigate to Matching Traders
                            context.goNamed('matchingTraders', pathParameters: {'taskId': 'demo_task_id'});
                          },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.authPurple, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 16.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), elevation: 0),
                            child: const Text('View My Task', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
