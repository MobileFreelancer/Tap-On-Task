import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';

class AuthInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffix;

  const AuthInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(14)),
      decoration: BoxDecoration(
        color: AppColors.authInputBg,
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(14)),
            child: Icon(icon, color: AppColors.authPurple, size: context.w(20)),
          ),
          Container(width: 1, height: context.h(24), color: AppColors.borderLight),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: AppTextStyles.authInputText(context),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.authInputHint(context),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.w(14),
                  vertical: context.h(16),
                ),
                suffixIcon: suffix,
              ),
            ),
          ),
        ],
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
      suffix: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.authPurple,
          size: context.w(20),
        ),
        onPressed: onToggle,
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
    return SizedBox(
      width: double.infinity,
      height: context.h(52),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.authNavy,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(12))),
          textStyle: AppTextStyles.authButton(context),
        ),
        child: isLoading
            ? SizedBox(
                width: context.w(24),
                height: context.w(24),
                child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  final String text;
  const AuthDivider({super.key, this.text = 'Or sign in with'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(20)),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.borderLight)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(12)),
            child: Text(text, style: AppTextStyles.authDivider(context)),
          ),
          const Expanded(child: Divider(color: AppColors.borderLight)),
        ],
      ),
    );
  }
}

class OtpInputRow extends StatelessWidget {
  final List<String> digits;
  final void Function(int index, String value) onChanged;

  const OtpInputRow({super.key, required this.digits, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: context.w(48),
          height: context.h(56),
          child: TextFormField(
            key: ValueKey('otp_${index}_${digits[index]}'),
            initialValue: digits[index].isEmpty ? null : digits[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTextStyles.otpDigit(context),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.authInputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.r(10)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.r(10)),
                borderSide: const BorderSide(color: AppColors.authPurple, width: 2),
              ),
            ),
            onChanged: (v) => onChanged(index, v),
          ),
        );
      }),
    );
  }
}
