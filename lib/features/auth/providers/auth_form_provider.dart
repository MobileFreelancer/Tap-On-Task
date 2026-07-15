import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';

class AuthFormProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final forgotEmailController = TextEditingController();

  UserRole _selectedRole = UserRole.customer;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  final List<String> _otpDigits = List.filled(6, '');
  int _resendSeconds = 60;
  bool _canResend = false;
  String _otpFlow = 'verify';
  String _otpContact = '';

  UserRole get selectedRole => _selectedRole;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get termsAccepted => _termsAccepted;
  List<String> get otpDigits => List.unmodifiable(_otpDigits);
  String get otpCode => _otpDigits.join();
  bool get isOtpComplete => _otpDigits.every((d) => d.isNotEmpty);
  int get resendSeconds => _resendSeconds;
  bool get canResend => _canResend;
  String get otpFlow => _otpFlow;
  String get otpContact => _otpContact;

  void setRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  void setOtpDigit(int index, String value) {
    if (index < 0 || index >= 6) return;
    _otpDigits[index] = value.length > 1 ? value[value.length - 1] : value;
    notifyListeners();
  }

  void clearOtp() {
    for (var i = 0; i < 6; i++) {
      _otpDigits[i] = '';
    }
    notifyListeners();
  }

  void initOtpFlow({required String contact, required String flow}) {
    _otpContact = contact;
    _otpFlow = flow;
    clearOtp();
    startResendTimer();
  }

  void startResendTimer() {
    _canResend = false;
    _resendSeconds = 60;
    notifyListeners();
    _runResendTimer();
  }

  Future<void> _runResendTimer() async {
    while (_resendSeconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      _resendSeconds--;
      if (_resendSeconds <= 0) _canResend = true;
      notifyListeners();
    }
  }

  void resetForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    phoneController.clear();
    forgotEmailController.clear();
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    _termsAccepted = false;
    clearOtp();
    notifyListeners();
  }

  String? validateLogin() {
    if (emailController.text.trim().isEmpty) return 'Enter your email or phone';
    if (passwordController.text.isEmpty) return 'Enter your password';
    if (passwordController.text.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateSignup() {
    if (nameController.text.trim().isEmpty) return 'Enter your full name';
    if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      return 'Enter a valid email';
    }
    if (phoneController.text.trim().length < 10) return 'Enter a valid phone number';
    if (passwordController.text.length < 6) return 'Password must be at least 6 characters';
    if (passwordController.text != confirmPasswordController.text) return 'Passwords do not match';
    if (!_termsAccepted) return 'Please accept the terms and conditions';
    return null;
  }

  String? validateForgotPassword() {
    if (forgotEmailController.text.trim().isEmpty) return 'Enter your email or phone number';
    return null;
  }

  String? validateResetPassword() {
    if (passwordController.text.length < 6) return 'Password must be at least 6 characters';
    if (passwordController.text != confirmPasswordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    forgotEmailController.dispose();
    super.dispose();
  }
}
