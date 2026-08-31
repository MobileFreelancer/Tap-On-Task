import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
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
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
                      _buildSearchBar(locationProvider),
                      SizedBox(height: 20.h),
                      _buildMapSection(locationProvider),
                      SizedBox(height: 24.h),
                      _buildAddressRow(textTheme, locationProvider),
                      SizedBox(height: 16.h),
                      _buildCurrentLocationToggle(textTheme, locationProvider),
                      SizedBox(height: 32.h),
                      _buildConfirmButton(locationProvider),
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

  Widget _buildSearchBar(LocationProvider provider) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: _searchController,
      googleAPIKey: "AIzaSyAVNNJrEeHazGe_U5SGEr6mF4uQ5G_vKYs",
      inputDecoration: InputDecoration(
        hintText: "Search location...",
        hintStyle: TextStyle(color: AppColors.textGray400, fontSize: 14.sp),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textGray400, size: 20.sp),
       // suffixIcon: Icon(Icons.close_rounded, color: AppColors.textGray400, size: 20.sp),
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
      debounceTime: 800,
      itemClick: (Prediction prediction) async {
        _searchController.text = prediction.description ?? "";
        _searchController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description?.length ?? 0));
        
        if (prediction.description != null) {
          await provider.updateLocationFromAddressText(prediction.description!);
          _mapController?.animateCamera(CameraUpdate.newLatLng(provider.selectedLatLng));
        }
      },
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.authPurple),
              SizedBox(width: 7),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapSection(LocationProvider provider) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: provider.selectedLatLng,
            zoom: 15,
          ),
          onMapCreated: _onMapCreated,
          onCameraMove: (position) {
            // No need to update provider on every move, only on idle
          },
          onCameraIdle: () async {
            if (_mapController != null) {
              final LatLngBounds bounds = await _mapController!.getVisibleRegion();
              final LatLng center = LatLng(
                (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
                (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
              );
              // Only update if it moved significantly to avoid infinite loops if any
              if ((center.latitude - provider.selectedLatLng.latitude).abs() > 0.0001 ||
                  (center.longitude - provider.selectedLatLng.longitude).abs() > 0.0001) {
                provider.updateLocationFromLatLng(center);
              }
            }
          },
          onTap: (latLng) {
            provider.updateLocationFromLatLng(latLng);
            _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
          },
          markers: {
            Marker(
              markerId: const MarkerId('selected_location'),
              position: provider.selectedLatLng,
            ),
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
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
              Text(
                provider.isLoading ? 'Loading address...' : provider.selectedAddress.split(',').first,
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                provider.isLoading ? '' : provider.selectedAddress.split(',').skip(1).join(',').trim(),
                style: textTheme.bodySmall?.copyWith(color: AppColors.textGray500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentLocationToggle(TextTheme textTheme, LocationProvider provider) {
    return InkWell(
      onTap: () => provider.toggleUseCurrentLocation(!provider.useCurrentLocation),
      child: Container(
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
      ),
    );
  }

  Widget _buildConfirmButton(LocationProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : () => context.pop(provider.selectedAddress),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.authPurple,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: provider.isLoading 
            ? SizedBox(height: 20.h, width: 20.h, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Confirm Location', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
