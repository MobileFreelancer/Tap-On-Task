import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_gradient_header.dart';
import '../../location/providers/location_provider.dart';
import '../providers/post_task_provider.dart';

class MatchingTradersScreen extends StatefulWidget {
  final String taskId;
  const MatchingTradersScreen({super.key, required this.taskId});

  @override
  State<MatchingTradersScreen> createState() => _MatchingTradersScreenState();
}

class _MatchingTradersScreenState extends State<MatchingTradersScreen> {
  GoogleMapController? _mapController;

  final List<_TraderMock> _mockTraders = [
    _TraderMock(
      name: 'Mike Wilson',
      rating: '4.8',
      category: 'Plumber',
      experience: '10+ years experience',
      distance: '2 Km away',
      jobsCompleted: '8 jobs completed nearby',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop',
      latLng: const LatLng(43.6550, -79.3850),
    ),
    _TraderMock(
      name: 'Sarah Smith',
      rating: '4.9',
      category: 'Electrician',
      experience: '8+ years experience',
      distance: '3 Km away',
      jobsCompleted: '15 jobs completed nearby',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop',
      latLng: const LatLng(43.6600, -79.3900),
    ),
    _TraderMock(
      name: 'John Davis',
      rating: '4.7',
      category: 'Handyman',
      experience: '5 years experience',
      distance: '1.5 Km away',
      jobsCompleted: '5 jobs completed nearby',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop',
      latLng: const LatLng(43.6500, -79.3750),
    ),
  ];

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final postTaskProvider = context.watch<PostTaskProvider>();
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          AppGradientHeader(
            height: 180.h,
            showBack: true,
            title: "Matching Traders",
            subTitle: 'We found ${_mockTraders.length} qualified professionals near you',
            onBack: () => context.canPop() ? context.pop() : context.go('/customer/dashboard'),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                ),
                child: ListView(
                  children: [
                    _buildTaskSummaryCard(textTheme, postTaskProvider),
                    SizedBox(height: 20.h),
                    _buildRealMap(locationProvider),
                    SizedBox(height: 24.h),
                    ..._mockTraders.map((trader) {
                      return _buildTraderCard(
                        textTheme: textTheme,
                        name: trader.name,
                        rating: trader.rating,
                        category: trader.category,
                        price: 'CAD ${postTaskProvider.estimatedBudget.toInt()}',
                        experience: trader.experience,
                        distance: trader.distance,
                        jobsCompleted: trader.jobsCompleted,
                        isAvailableToday: true,
                        buttonText: 'View Profile',
                        onButtonPressed: () {
                          context.pushNamed('quotes', pathParameters: {'taskId': widget.taskId});
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
          onPressed: () => context.pushNamed('quotes', pathParameters: {'taskId': widget.taskId}),
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
                onTap: () => context.pop(),
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

  Widget _buildRealMap(LocationProvider locationProvider) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: locationProvider.selectedLatLng,
            zoom: 13,
          ),
          onMapCreated: (controller) => _mapController = controller,
          markers: {
            Marker(
              markerId: const MarkerId('user_location'),
              position: locationProvider.selectedLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            ),
            ..._mockTraders.map((t) => Marker(
                  markerId: MarkerId(t.name),
                  position: t.latLng,
                  infoWindow: InfoWindow(title: t.name, snippet: t.category),
                )),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        ),
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
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80.w,
                height: 90.h,
                color: Colors.grey[200],
                child: Icon(Icons.person, color: Colors.grey[400]),
              ),
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
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.authNavy),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(color: const Color(0xFFFEF9C3), borderRadius: BorderRadius.circular(4.r)),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber[700], size: 12.sp),
                          SizedBox(width: 2.w),
                          Text(rating, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.amber[900])),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(category, style: TextStyle(fontSize: 12.sp, color: AppColors.textGray500)),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(experience, style: TextStyle(fontSize: 12.sp, color: AppColors.textGray500)),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red[400], size: 12.sp),
                        SizedBox(width: 2.w),
                        Text(distance, style: TextStyle(fontSize: 11.sp, color: AppColors.textGray500)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isAvailableToday)
                      Row(
                        children: [
                          Container(width: 6.w, height: 6.w, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                          SizedBox(width: 6.w),
                          Text('Available Today', style: TextStyle(fontSize: 11.sp, color: Colors.green, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    SizedBox(
                      height: 28.h,
                      child: ElevatedButton(
                        onPressed: onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.authPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                        ),
                        child: Text(buttonText, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold)),
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
  final String experience;
  final String distance;
  final String jobsCompleted;
  final String imageUrl;
  final LatLng latLng;

  _TraderMock({
    required this.name,
    required this.rating,
    required this.category,
    required this.experience,
    required this.distance,
    required this.jobsCompleted,
    required this.imageUrl,
    required this.latLng,
  });
}
