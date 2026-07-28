import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_header.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveCard = true;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: AppHeader(
        headerHeight: 150.h,
        title: "Add New Card",
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              SizedBox(height: 10.h),
              Text(
                "Cardholder Name",
                style: TextStylesInApp.robotoBody(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.authNavy,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _nameController,
                style: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.authNavy),
                decoration: InputDecoration(
                  hintText: "John Doe",
                  hintStyle: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.textGray400),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.primaryPurple),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter cardholder name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              Text(
                "Card Number",
                style: TextStylesInApp.robotoBody(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.authNavy,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                style: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.authNavy),
                decoration: InputDecoration(
                  hintText: "1234 5678 9012 3456",
                  hintStyle: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.textGray400),
                  suffixIcon: Icon(Icons.credit_card_rounded, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.primaryPurple),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter card number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expiry Date",
                          style: TextStylesInApp.robotoBody(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authNavy,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.datetime,
                          style: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.authNavy),
                          decoration: InputDecoration(
                            hintText: "MM/YY",
                            hintStyle: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.textGray400),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: AppColors.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: AppColors.borderLight),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: AppColors.primaryPurple),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter expiry date";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CVV",
                          style: TextStylesInApp.robotoBody(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authNavy,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          style: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.authNavy),
                          decoration: InputDecoration(
                            hintText: "123",
                            hintStyle: TextStylesInApp.robotoBody(fontSize: 16.sp, color: AppColors.textGray400),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: AppColors.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: AppColors.borderLight),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: AppColors.primaryPurple),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter CVV";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: Checkbox(
                      value: _saveCard,
                      activeColor: AppColors.primaryPurple,
                      onChanged: (val) {
                        setState(() {
                          _saveCard = val ?? false;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Save card for future payments",
                    style: TextStylesInApp.robotoBody(
                      fontSize: 14.sp,
                      color: AppColors.authNavy,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigate back to payment screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Card added successfully!')),
                      );
                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add Card",
                    style: TextStylesInApp.robotoBody(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
