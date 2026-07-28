import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_gradient_header.dart';
import '../providers/location_provider.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
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
                    'Select Location',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Choose your service location',
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
                      _buildSearchBar(textTheme, locationProvider),
                      SizedBox(height: 20.h),
                      _buildMapSection(textTheme),
                      SizedBox(height: 24.h),
                      _buildAddressRow(textTheme, locationProvider),
                      SizedBox(height: 16.h),
                      _buildCurrentLocationToggle(textTheme, locationProvider),
                      SizedBox(height: 24.h),
                      Text(
                        'Saved Locations',
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 12.h),
                      _buildSavedLocationItem(Icons.home_rounded, 'Home', '123 Maple street, toronto, ON, Canada', true),
                      _buildSavedLocationItem(Icons.work_rounded, 'Work', '45 king street west, Toronto, ON M5H 1A1', false),
                      SizedBox(height: 32.h),
                      _buildConfirmButton(textTheme, locationProvider),
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

  Widget _buildSearchBar(TextTheme textTheme, LocationProvider locationProvider) {
    return TextField(
      controller: _searchController,
      onChanged: locationProvider.updateSearchQuery,
      style: textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: '123 Maple street, toronto, ON, Canada',
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textGray400),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textGray400, size: 20.sp),
        suffixIcon: Icon(Icons.close_rounded, color: AppColors.textGray400, size: 20.sp),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.authPurple),
        ),
      ),
    );
  }

  Widget _buildMapSection(TextTheme textTheme) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x200'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(Icons.location_on_rounded, color: AppColors.error, size: 32.sp),
          ),
          Positioned(
            top: 16.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.gps_fixed_rounded, color: AppColors.authPurple, size: 16.sp),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auto-detected location', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.sp)),
                        Text('Accuracy: High', style: TextStyle(color: AppColors.textGray500, fontSize: 9.sp)),
                      ],
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

  Widget _buildAddressRow(TextTheme textTheme, LocationProvider provider) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(color: AppColors.authPurple, borderRadius: BorderRadius.circular(10.r)),
          child: Icon(Icons.location_on_rounded, color: Colors.white, size: 20.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('123 Maple Street', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text('Toronto, ON, Canada', style: textTheme.bodySmall?.copyWith(color: AppColors.textGray500)),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.edit_rounded, size: 14.sp, color: AppColors.authPurple),
          label: Text('Edit', style: TextStyle(color: AppColors.authPurple, fontSize: 12.sp)),
        ),
      ],
    );
  }

  Widget _buildCurrentLocationToggle(TextTheme textTheme, LocationProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: AppColors.authPurple, borderRadius: BorderRadius.circular(8.r)),
            child: Icon(Icons.gps_fixed_rounded, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Use my current location', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text('Detect my current location automatically', style: textTheme.bodySmall?.copyWith(color: AppColors.textGray500, fontSize: 10.sp)),
              ],
            ),
          ),
          Switch(
            value: provider.useCurrentLocation,
            onChanged: provider.toggleUseCurrentLocation,
            activeColor: AppColors.authPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildSavedLocationItem(IconData icon, String title, String address, bool isSelected) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: AppColors.authPurple, borderRadius: BorderRadius.circular(10.r)),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(address, style: TextStyle(color: AppColors.textGray500, fontSize: 11.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (v) {},
            activeColor: AppColors.authPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(TextTheme textTheme, LocationProvider locationProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.pushNamed('postTask'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.authPurple,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: const Text('Confirm Location', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
