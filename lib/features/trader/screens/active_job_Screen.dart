import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tapontask/core/widgets/app_header.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../generated/assets.dart';
import '../../auth/providers/active_job_provider.dart';

class ActiveJobScreen extends StatelessWidget {
  const ActiveJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHeader(
        title: "Active Job",
        headerHeight: 130,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Purple Header
             // _buildHeader(context),

              // Content Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    _buildJobDetailsCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Trader Details'),
                    const SizedBox(height: 10),
                    _buildTraderCard(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Job Progress'),
                          Text(
                          'Last updated: 9:30 AM',
                          style: TextStylesInApp.robotoBody(color: AppColors.textGray400, fontSize: 14.sp,fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // DYNAMIC STEPPER WIDGET (Using Consumer)
                    Consumer<ActiveJobProvider>(
                      builder: (context, provider, child) {
                        return JobStepper(
                          steps: provider.steps,
                          currentStepIndex: provider.currentStepIndex,
                          onStepTapped: (index) => provider.setStep(index),
                        );
                      },
                    ),
                    const SizedBox(height: 15),

                    // Dynamic Status Info Banner
                    _buildStatusBanner(),
                    const SizedBox(height: 20),

                    // Live Location Section
                    _buildSectionTitle('Live Location'),
                    const SizedBox(height: 10),
                    _buildLiveLocationCard(),
                    const SizedBox(height: 20),

                    // Job Updates Timeline
                    _buildSectionTitle('Job Updates'),
                    const SizedBox(height: 10),
                    _buildTimelineUpdates(),
                    const SizedBox(height: 15),

                    // Payment Information Card
                    _buildPaymentCard(),
                    const SizedBox(height: 20),

                    // Action Buttons
                    _buildActionButtons(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStylesInApp.soraHeader(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.authNavy,
      ),
    );
  }

  Widget _buildJobDetailsCard() {
    return  Container(
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
                          fontSize: 14.sp,
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
                            fontSize: 14.sp,
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
                        " May 25, 2025  10:00 AM",
                        style: TextStylesInApp.robotoBody(
                            fontSize: 14.sp,
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
    );
  }

  Widget _buildTraderCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?w=150',
              width: 75,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text('Mike Wilson', style: TextStylesInApp.robotoBody(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                  Text('Plumbing Specialist', style: TextStylesInApp.robotoBody(fontSize: 12.sp, color: AppColors.textGray400)),
                  SizedBox(height: 4),
                  Row(
                  children: [
                    Container(
                      height: 22.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: AppColors.accentOrange,size: 15,),
                          Text('4.8', style: TextStylesInApp.robotoBody(fontSize: 12.sp, color: AppColors.authNavy)),
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('(128 reviews)', style: TextStylesInApp.robotoBody(fontSize: 11.sp, color: AppColors.textGray400)),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildBadge('Licensed'),
                    _buildBadge('Insured'),
                    _buildBadge('Background'),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              _buildIconButton(AppAssets.chat),
              const SizedBox(height: 8),
              _buildIconButton(AppAssets.call),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStylesInApp.soraHeader(color: AppColors.primaryPurple, fontSize: 12.sp, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildIconButton(String icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:  AppColors.backgroundWhite,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Image.asset(icon,  scale: 2.9,),
    );
  }

  Widget _buildStatusBanner() {
    return Consumer<ActiveJobProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  provider.steps[provider.currentStepIndex].icon,
                  color: const Color(0xFF6B42E0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.currentStatusTitle,
                      style:  TextStylesInApp.robotoBody(fontWeight: FontWeight.w500, fontSize: 18.sp,color: AppColors.authNavy),
                    ),
                      SizedBox(height: 2),
                    Text(
                      provider.currentStatusSubtitle,
                      style:   TextStylesInApp.robotoBody(color: AppColors.textGray400, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              if (provider.currentStepIndex == 2) ...[
                  Column(
                  children: [
                    Text('25', style: TextStylesInApp.robotoBody(color: AppColors.primaryPurple, fontSize: 20.sp,fontWeight: FontWeight.w700)),
                    Text('Min', style: TextStylesInApp.robotoBody(fontSize: 14.sp, color: AppColors.textGray400)),
                  ],
                )
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveLocationCard() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: IntrinsicHeight(
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://tile.openstreetmap.org/13/2412/3079.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: IntrinsicHeight(
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.backgroundGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                physics: NeverScrollableScrollPhysics(),
                children: [
                    Text('Estimated Arrival', style: TextStylesInApp.robotoBody(fontSize: 12.sp, color: AppColors.textGray400)),
                    Text('9:55 AM', style: TextStylesInApp.robotoBody(fontWeight: FontWeight.w600, color: AppColors.primaryPurple, fontSize: 16.sp)),
                    SizedBox(height: 4),
                    Text('Distance', style: TextStylesInApp.robotoBody(fontSize: 12.sp, color: AppColors.textGray400)),
                    Text('2.1 km away', style: TextStylesInApp.robotoBody(fontWeight: FontWeight.w600, color: AppColors.primaryPurple, fontSize: 16.sp)),
                   SizedBox( height: 10.h,),
                  Container(
                    width: double.infinity,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withAlpha(10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('View on Map', style: TextStylesInApp.robotoBody(fontWeight: FontWeight.w600, color: AppColors.primaryPurple, fontSize: 12.sp)),
                  ),

                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTimelineUpdates() {
    return Consumer<ActiveJobProvider>(
      builder: (context, provider, child) {
        final updates = provider.timelineUpdates;
        return Column(
          children: List.generate(updates.length, (index) {
            final item = updates[index];
            return _buildTimelineItem(
              icon: item.icon,
              iconBgColor: item.isCompleted ? const Color(0xFF2ECC71) : const Color(0xFF6B42E0),
              title: item.title,
              subtitle: item.subtitle,
              time: item.time,
              showLine: index < updates.length - 1,
            );
          }),
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String time,
    required bool showLine,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: iconBgColor,
                child: Icon(icon, color: Colors.white, size: 14),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF2ECC71),
                  ),
                )
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style:  TextStylesInApp.robotoBody(fontWeight: FontWeight.w600, fontSize: 15.sp,color: AppColors.authNavy)),
                        const SizedBox(height: 2),
                        Text(subtitle, style:   TextStylesInApp.robotoBody(color: AppColors.textGray400, fontSize: 13.sp,fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Text(time, style: TextStylesInApp.robotoBody(color: AppColors.textGray400, fontSize: 13.sp,fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text('Payment Information', style: TextStylesInApp.robotoBody(fontWeight: FontWeight.w500, fontSize: 15.sp,color: AppColors.authNavy)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPaymentCol('Total Amount', 'CAD 125.00'),
              _buildPaymentCol('Paid', 'CAD 0.00'),
              _buildPaymentCol('Due on Completion', 'CAD 125.00'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentCol(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style:   TextStylesInApp.robotoBody(color: AppColors.textGray400, fontSize: 13.sp)),
        const SizedBox(height: 4),
        Text(amount, style:   TextStylesInApp.robotoBody(fontWeight: FontWeight.w600, color: AppColors.primaryPurple, fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Consumer<ActiveJobProvider>(
        builder: (context, provider, child){
          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              if (provider.currentStepIndex == 4) {
                context.pushNamed('payment', queryParameters: {
                  'amount': "120",
                  'bookingId': "task1",
                });
                //context.pushNamed('quotes', pathParameters: {'taskId': 'task1'});
              }
            },
            child: Text(provider.currentStepIndex==4?"Complete Job" :'Cancel Job', style: TextStylesInApp.robotoBody(fontSize: 16.sp,color: AppColors.accentRed, fontWeight: FontWeight.w400)),
          );
    }

          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B42E0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => context.pushNamed('help'),
            child:   Text('Need Help?', style: TextStylesInApp.robotoBody(fontSize: 16.sp,color: AppColors.backgroundWhite, fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. DYNAMIC STEPPER COMPONENT
// ==========================================

class JobStepper extends StatelessWidget {
  final List<StepData> steps;
  final int currentStepIndex;
  final ValueChanged<int>? onStepTapped;

  const JobStepper({
    super.key,
    required this.steps,
    required this.currentStepIndex,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStepIndex;
        final isCurrent = index == currentStepIndex;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: GestureDetector(
            onTap: () => onStepTapped?.call(index),
            child: Column(
              children: [
                Row(
                  children: [
                    // Line segment before icon
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index == 0
                            ? Colors.transparent
                            : (index <= currentStepIndex ? const Color(0xFF2ECC71) : Colors.grey.shade300),
                      ),
                    ),

                    // Step Icon Circle
                    _buildStepCircle(isCompleted, isCurrent, steps[index].icon),

                    // Line segment after icon
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isLast
                            ? Colors.transparent
                            : (index < currentStepIndex ? const Color(0xFF2ECC71) : Colors.grey.shade300),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Step Title Text
                Text(
                  steps[index].label,
                  textAlign: TextAlign.center,
                  style: TextStylesInApp.robotoBody(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400 ,
                    color: isCurrent
                        ? const Color(0xFF6B42E0)
                        : (isCompleted ? Colors.black : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepCircle(bool isCompleted, bool isCurrent, IconData icon) {
    Color bgColor;
    Color iconColor;

    if (isCompleted) {
      bgColor = const Color(0xFF2ECC71);
      iconColor = Colors.white;
    } else if (isCurrent) {
      bgColor = const Color(0xFF6B42E0);
      iconColor = Colors.white;
    } else {
      bgColor = const Color(0xFFE2E8F0);
      iconColor = const Color(0xFF64748B);
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: bgColor,
      child: Icon(
        isCompleted ? Icons.check : icon,
        size: 16,
        color: iconColor,
      ),
    );
  }
}