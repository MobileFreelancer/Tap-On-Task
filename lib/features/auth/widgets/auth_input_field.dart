import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/services.dart';

class AuthInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffix;
  final int? maxLength;

  const AuthInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
     this.maxLength,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: textTheme.bodyMedium?.copyWith(
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      ),
      maxLength:maxLength ,
      decoration: InputDecoration(
        hintText: hint,
        counterText: "",
        fillColor: AppColors.textGrayF9,
        filled: true,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textGray400,
          fontSize: 14.sp,
        ),
        prefixIcon: Container(
          width: 50.w,
          child: Row(
            children: [
              Expanded(child: Icon(icon, color: AppColors.authPurple, size: 20.sp)),
              VerticalDivider(color: AppColors.black.withValues(alpha: 0.03),),
            ],
          ),
        ) ,
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        suffixIcon: suffix,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: AppColors.primaryLight),borderRadius: BorderRadius.all(Radius.circular(10.w))),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withValues(alpha: 0.03)),borderRadius: BorderRadius.all(Radius.circular(10.w))),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.black.withValues(alpha: 0.03)),borderRadius: BorderRadius.all(Radius.circular(10.w))),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.accentRed),borderRadius: BorderRadius.all(Radius.circular(10.w))),
        suffixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
      ),
    );
  }
}

class AuthPasswordField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const AuthPasswordField({
    super.key,
    required this.hint,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AuthInputField(
      hint: hint,
      icon: Icons.lock_outline_rounded,
      controller: controller,
      obscureText: obscure,
      suffix: GestureDetector(
        onTap: onToggle,
        child: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textGray400,
          size: 20.sp,
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.authNavy,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  final String text;
  const AuthDivider({super.key, this.text = 'Or sign in with'});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.borderLight, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textGray400,
                fontSize: 12.sp,
              ),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.borderLight, thickness: 1)),
        ],
      ),
    );
  }
}

class OtpInputRow extends StatefulWidget {
  final List<String> digits;
  final void Function(int index, String value) onChanged;

  const OtpInputRow({
    super.key,
    required this.digits,
    required this.onChanged,
  });

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      6,
          (index) => TextEditingController(
        text: widget.digits[index],
      ),
    );

    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void didUpdateWidget(covariant OtpInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (int i = 0; i < 6; i++) {
      if (_controllers[i].text != widget.digits[i]) {
        _controllers[i].text = widget.digits[i];
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  void _handleChanged(int index, String value) {
    // Handle paste
    if (value.length > 1) {
      final chars = value.split('');

      for (int i = 0; i < chars.length && i < 6; i++) {
        _controllers[i].text = chars[i];
        widget.onChanged(i, chars[i]);
      }

      FocusScope.of(context).unfocus();
      return;
    }

    widget.onChanged(index, value);

    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48.w,
          height: 60.h,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.authNavy,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.authInputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: AppColors.authPurple,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => _handleChanged(index, value),
          ),
        );
      }),
    );
  }
}