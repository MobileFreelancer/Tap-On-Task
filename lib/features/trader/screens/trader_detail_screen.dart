import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tapontask/core/theme/text_styles.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_header.dart';

class TraderDetailScreen extends StatelessWidget {
  const TraderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHeader(
        title: "Mike Wilson",
        headerHeight: 130,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 0.0.w),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildProfileCard(),
                    _buildRatingSection(),
                    _buildAboutMeSection(),
                    _buildPortfolioSection(),
                    _buildServicesSection(),
                    _buildReviewsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildProfileCard() {
    return _buildCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
          color: AppColors.textGrayF9,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?w=150',
                width: 90,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                    'Plumber',
                    style:  TextStylesInApp.robotoBody(fontSize: 18.sp,color: AppColors.authNavy, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                    Text(
                    '10+ years experience',
                    style: TextStylesInApp.robotoBody(fontSize: 15.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 6),
                    Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.black87),
                      SizedBox(width: 4),
                      Text(
                        '2 Km away',
                        style: TextStylesInApp.robotoBody(fontSize: 15.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                    Text(
                    '8 jobs completed nearby',
                    style:  TextStylesInApp.robotoBody(fontSize: 15.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                        Text(
                        'Available Today',
                        style: TextStylesInApp.robotoBody(fontSize: 15.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Rating Breakdown Card ---
  Widget _buildRatingSection() {
    return _buildCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
          color: AppColors.textGrayF9,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            // Overall Rating
            Expanded(
              flex: 2,
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '4.8 ',
                        style: TextStylesInApp.robotoBody(fontSize: 24.sp,color: AppColors.authNavy, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          5,
                              (index) => const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                    Text(
                    '125 Reviews',
                    style: TextStylesInApp.robotoBody(fontSize: 13.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const ContainerDivider(),
            // Progress Bars
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _buildRatingBar(5, 0.85, '84'),
                  _buildRatingBar(4, 0.40, '25'),
                  _buildRatingBar(3, 0.90, '10',),
                  _buildRatingBar(2, 0.20, '3'),
                  _buildRatingBar(1, 0.15, '3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int starNum, double percent, String count,
      {bool highlighted = false}) {
    return Padding(
      padding:   EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$starNum',
            style:   TextStylesInApp.robotoBody(fontSize: 13.sp,color: AppColors.authNavy, fontWeight: FontWeight.w400),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star, size: 10, color: Colors.orange),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3),
                border: highlighted
                    ? Border.all(color: Colors.blue, width: 1)
                    : null,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: highlighted ? Colors.blue : Colors.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 16,
            child: Text(
              count,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // --- About Me Section ---
  Widget _buildAboutMeSection() {
    return _buildCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
          color: AppColors.textGrayF9,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
              'About Me',
              style: TextStylesInApp.robotoBody(fontSize: 18.sp,color: AppColors.authNavy, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
              Text(
              'Skilled handyman offering plumbing, electrical, and home repair services reliable and professional.',
              style: TextStylesInApp.robotoBody(fontSize: 15.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  // --- Portfolio Section ---
  Widget _buildPortfolioSection() {
    final List<String> images = [
      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=150',
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=150',
      'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=150',
    ];

    return _buildCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
          color: AppColors.textGrayF9,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
              'Portfolio',
              style: TextStylesInApp.robotoBody(fontSize: 18.sp,color: AppColors.authNavy, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: images.map((url) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- My Services Section ---
  Widget _buildServicesSection() {
    return _buildCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
          color: AppColors.textGrayF9,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
              'My Services',
              style: TextStylesInApp.robotoBody(fontSize: 18.sp,color: AppColors.authNavy, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildBulletPoint('Plumbing, Electrical, Carpentry'),
            const SizedBox(height: 6),
            _buildBulletPoint('Starting at \$50'),
            const SizedBox(height: 6),
            _buildBulletPoint('Typically responds in 1 hour'),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStylesInApp.robotoBody(fontSize: 16.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  // --- Reviews Section ---
  Widget _buildReviewsSection() {
    return _buildCard(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
          color: AppColors.textGrayF9,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Text(
                  'Reviews',
                  style: TextStylesInApp.robotoBody(fontSize: 18.sp,color: AppColors.authNavy, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {},
                  child:   Text(
                    'View All',
                    style: TextStylesInApp.robotoBody(fontSize: 18.sp,color: AppColors.authNavy, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
                  ),
                ),
                const SizedBox(width: 10),
                // Name, Rating & Comment
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                            Text(
                            'Sarah M.',
                            style: TextStylesInApp.robotoBody(fontSize: 18.sp,color: AppColors.authNavy, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: List.generate(
                              5,
                                  (index) => const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                        Text(
                        'Great work! Fixed my leaky sink quickly. Highly recommended!',
                        style: TextStylesInApp.robotoBody(fontSize: 16.sp,color: AppColors.textGray500, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusable Card Builder Container ---
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Vertical Line Divider Component
class ContainerDivider extends StatelessWidget {
  const ContainerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 1,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}