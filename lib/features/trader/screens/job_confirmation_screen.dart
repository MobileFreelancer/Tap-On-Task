import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapontask/core/constants/app_colors.dart';
import 'package:tapontask/core/theme/text_styles.dart';

import '../../../core/widgets/app_header.dart';
import '../../../generated/assets.dart';
import 'package:go_router/go_router.dart';

class JobConfirmationScreen extends StatefulWidget {
  const JobConfirmationScreen({super.key});

  @override
  State<JobConfirmationScreen> createState() => _JobConfirmationScreenState();
}

class _JobConfirmationScreenState extends State<JobConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppHeader(
        headerHeight: 150,
        title: "Review & Confirm",
        subtitle: "Review the quote and accept or\nreject it",
        //topPadding: 160.h,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          physics: const BouncingScrollPhysics(),
          children: [
            // --- Job Details Card ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
                color: AppColors.textGrayF9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                spacing: 8.w,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    margin: EdgeInsets.only(bottom: 55.h),
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(AppAssets.toolIcon, scale: 3.2),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Fix leaking kitchen sink",
                              style: TextStylesInApp.robotoBody(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.authNavy),
                            ),
                            Text(
                              "View Details",
                              style: TextStylesInApp.robotoBody(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryPurple),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.location_solid),
                            Expanded(
                              child: Text(
                                "123 Maple street, toronto, ON, Canada",
                                style: TextStylesInApp.robotoBody(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textGray400),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined),
                            Expanded(
                              child: Text(
                                "May 25, 2025  10:00 AM",
                                style: TextStylesInApp.robotoBody(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textGray400),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),

            // --- Trader Details Heading ---
            Text(
              "Trader Details",
              style: TextStylesInApp.soraHeader(
                color: AppColors.authNavy,
                fontWeight: FontWeight.w600,
                fontSize: 18.r,
              ),
            ),
            SizedBox(height: 10.h),

            // --- Trader Details Card ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withValues(alpha: .1), width: .5),
                color: AppColors.textGrayF9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                spacing: 8.w,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: DecorationImage(
                            image: AssetImage(AppAssets.dummyTrader),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8.w, top: 8.h),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundOffWhite,
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: AppColors.accentOrange),
                            Text(
                              "4.8",
                              style: TextStylesInApp.robotoBody(
                                fontSize: 12.sp,
                                color: AppColors.authNavy,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mike Wilson",
                          style: TextStylesInApp.robotoBody(
                            fontSize: 18.sp,
                            color: AppColors.authNavy,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "10+ years experience",
                          style: TextStylesInApp.robotoBody(
                            fontSize: 15.sp,
                            color: AppColors.textGray400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.location_solid),
                            Expanded(
                              child: Text(
                                "2 Km away",
                                style: TextStylesInApp.robotoBody(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textGray400),
                              ),
                            )
                          ],
                        ),
                        Text(
                          "8 jobs completed nearby",
                          style: TextStylesInApp.robotoBody(
                            fontSize: 15.sp,
                            color: AppColors.textGray400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          spacing: 10.w,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  color: Colors.green, shape: BoxShape.circle),
                            ),
                            Expanded(
                              child: Text(
                                "Available Today",
                                style: TextStylesInApp.robotoBody(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textGray400),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: GestureDetector(
                      onTap: () => context.go('/trader/detail'),
                      child: Image.asset(
                        AppAssets.forwordimage,
                        scale: 2.3,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15.h),
            const QuoteDetailsSection(),
          ],
        ),
      ),
    );
  }
}


class QuoteDetailsSection extends StatefulWidget {
  const QuoteDetailsSection({super.key});

  @override
  State<QuoteDetailsSection> createState() => _QuoteDetailsSectionState();
}

class _QuoteDetailsSectionState extends State<QuoteDetailsSection> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

          Text(
          "Quote Breakdown",
          style:TextStylesInApp.soraHeader(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.authNavy,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildQuoteRow("Service Cost", "CAD 120.00"),
              const SizedBox(height: 8),
              _buildQuoteRow("Materials", "Included", isGreenText: true),
              const SizedBox(height: 8),
              _buildQuoteRow("Travel Fee", "CAD 0.00"),
              const SizedBox(height: 8),
              _buildQuoteRow("Platform Fee", "CAD 5.00"),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(color: Color(0xFFE2E8F0), height: 1),
              ),
              _buildQuoteRow("Total Amount", "CAD 125.00", isTotal: true),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // --- 2. Guarantee Banner ---
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.verified_user_rounded, color: Color(0xFF047857), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "You won't be charged until the job is completed.",
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Message from Mike",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child:   Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.format_quote, color: Color(0xFF7C3AED), size: 16),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "I can fix the leaking kitchen sink quickly. All parts and labor included. See you tomorrow!",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // --- 4. Why Choose Mike Grid ---
        const Text(
          "Why Choose Mike?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
         SizedBox(height: 10.h
        ),
        TrustBadgesCard(),

         SizedBox(height: 20.h
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                value: _isAgreed,
                activeColor: const Color(0xFF7C3AED),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (val) {
                  setState(() {
                    _isAgreed = val ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
                  children: [
                    TextSpan(text: "I agree to the "),
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(
                        color: Color(0xFF7C3AED),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Cancellation Policy",
                      style: TextStyle(
                        color: Color(0xFF7C3AED),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 15.h),
        Row(
          children: [
            Expanded(
              child: Column(
                spacing: 8.h,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 35.w,vertical: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.accentRed,width: 1),
                      borderRadius: BorderRadius.circular(10.r)
                    ),
                    child:Text("Reject Quote",style: TextStylesInApp.robotoBody(color: AppColors.accentRed,fontSize: 16.sp,fontWeight: FontWeight.w400),),
                  ),
                  Text("You can continue searching\nfor other quotes",style: TextStylesInApp.robotoBody(color: AppColors.textGray400,fontSize: 14.sp,fontWeight: FontWeight.w400),textAlign: TextAlign.center,)
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 8.h,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 35.w,vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.circular(10.r)
                    ),
                    child:Text("Accept Quote",style: TextStylesInApp.robotoBody(color: AppColors.backgroundWhite,fontSize: 16.sp,fontWeight: FontWeight.w400),),
                  ),
                  Text("Job will be assigned to\nMike Wilson",style: TextStylesInApp.robotoBody(color: AppColors.textGray400,fontSize: 14.sp,fontWeight: FontWeight.w400),textAlign: TextAlign.center,)
                ],
              ),
            ),
          ],
        ),
    SizedBox(height: 20.h)
      ],
    );
  }

  Widget _buildQuoteRow(String title, String value,
      {bool isGreenText = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStylesInApp.robotoBody(
            fontSize: 16.sp,
            fontWeight:   FontWeight.w600,
            color:  AppColors.authNavy ,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? const Color(0xFF7C3AED)
                : isGreenText
                ? const Color(0xFF059669)
                : const Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureBadge({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}



class TrustBadgesCard extends StatelessWidget {
  const TrustBadgesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Defines the 4 items according to the design
    final List<_BadgeItemData> items = [
      _BadgeItemData(
        title: "Licensed",
        subtitle: "Verified professional",
        icon: Icons.verified_user_rounded, // or custom SVG/png
        iconColor: const Color(0xFF10B981),
        iconBgColor: const Color(0xFFE6F4EA),
      ),
      _BadgeItemData(
        title: "Insured",
        subtitle: "Up to \$1M Coverage",
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFF2563EB),
        iconBgColor: const Color(0xFFE8F0FE),
      ),
      _BadgeItemData(
        title: "Background",
        subtitle: "Verified",
        icon: Icons.groups_rounded,
        iconColor: const Color(0xFF7C3AED),
        iconBgColor: const Color(0xFFF3E8FF),
      ),
      _BadgeItemData(
        title: "Top Rated",
        subtitle: "4.9/5 average rating",
        icon: Icons.shield,
        iconColor: const Color(0xFFF97316),
        iconBgColor: const Color(0xFFFFF7ED),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            children: [
              Expanded(child: _BadgeTile(data: items[0])),
              _buildVerticalDivider(),
              Expanded(child: _BadgeTile(data: items[1])),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: const Divider(
              color: Color(0xFFE5E7EB),
              height: 1,
              thickness: 1,
            ),
          ),

          Row(
            children: [
              Expanded(child: _BadgeTile(data: items[2])),
              _buildVerticalDivider(),
              Expanded(child: _BadgeTile(data: items[3])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 80.h,
      color: const Color(0xFFE5E7EB),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final _BadgeItemData data;

  const _BadgeTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Icon Container with light background
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: data.iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              color: data.iconColor,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 10.h),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(
              color: const Color(0xFF0F172A),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              color: const Color(0xFF64748B),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  _BadgeItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}