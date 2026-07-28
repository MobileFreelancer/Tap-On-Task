import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_gradient_header.dart';
import '../../../core/widgets/app_header.dart';
import '../../auth/widgets/auth_scaffold.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I book a service?',
      'answer': 'You can book a service by selecting a category from the home screen, choosing a provider, and following the booking steps.'
    },
    {
      'question': 'How do payments work?',
      'answer': 'Payments are handled securely through our platform. You can pay using credit/debit cards or your wallet balance.'
    },
    {
      'question': 'Can I reschedule or cancel my booking?',
      'answer': 'Yes, you can reschedule or cancel your booking from the "My Tasks" section, subject to the provider\'s cancellation policy.'
    },
    {
      'question': 'How do I track my job?',
      'answer': 'Once a job is active, you can track it in real-time from the "Active Job" screen available in your dashboard.'
    },
    {
      'question': 'Can I reschedule or cancel my booking?',
      'answer': 'Yes, you can reschedule or cancel your booking from the "My Tasks" section.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AppHeader(
       title: "Help & Support",
      headerHeight: 140.h,
      child: Column(
        children: [
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHelpHeroCard(),
                      SizedBox(height: 10.h),
                      Text(
                        'Frequently Asked Questions',
                        style: TextStylesInApp.soraHeader(
                          fontSize: 18.sp,
                          color: AppColors.authNavy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildFaqList(),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: _buildContactCard(
                                icon: Icons.chat_bubble_outline_rounded,
                                iconColor: Colors.blue,
                                title: 'Live Chat',
                                subtitle: 'Online',
                                statusColor: Colors.green,
                                buttonText: 'Chat Now',
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildContactCard(
                              icon: Icons.email_outlined,
                              iconColor: AppColors.primaryPurple,
                              title: 'Email Us',
                              subtitle: 'We\'ll reply\nwithin 24 hours',
                              buttonText: 'Send Email',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildTicketCard(),
                      SizedBox(height: 100.h),
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

  Widget _buildHelpHeroCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.textGrayF9,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.headset_mic_outlined,
              color: AppColors.primaryPurple,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We\'re here to help',
                  style: TextStylesInApp.robotoBody(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.authNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Find answers or contact our support team.',
                  style: TextStylesInApp.robotoBody(
                    fontSize: 14.sp,
                    color: AppColors.textGray500,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Contact Support',
                    style: TextStylesInApp.robotoBody(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _faqs.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Material(
          color: AppColors.textGrayF9,
          borderRadius: BorderRadius.circular(12.r),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
            childrenPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide.none,
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide.none,
            ),
            iconColor: AppColors.primaryPurple,
            collapsedIconColor: AppColors.primaryPurple,
            leading: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                'Q',
                style: TextStylesInApp.robotoBody(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
            title: Text(
              _faqs[index]['question']!,
              style: TextStylesInApp.robotoBody(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.authNavy,
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(60.w, 0, 16.w, 16.h),
                child: Text(
                  _faqs[index]['answer']!,
                  style: TextStylesInApp.robotoBody(
                    fontSize: 13.sp,
                    color: AppColors.textGray500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Color? statusColor,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.textGrayF9,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStylesInApp.robotoBody(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.authNavy,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              if (statusColor != null) ...[
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
              ],
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStylesInApp.robotoBody(
                    fontSize: 12.sp,
                    color: AppColors.textGray500,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: iconColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
              ),
              child: Text(
                buttonText,
                style: TextStylesInApp.robotoBody(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color:AppColors.primaryPurple.withAlpha(15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.authNavy.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.description_outlined,
              color: AppColors.authNavy.withOpacity(0.7),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Support Tickets',
                  style: TextStylesInApp.robotoBody(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.authNavy,
                  ),
                ),
                Text(
                  'View your previous tickets and their status',
                  style: TextStylesInApp.robotoBody(
                    fontSize: 12.sp,
                    color: AppColors.textGray500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textGray400),
        ],
      ),
    );
  }
}
