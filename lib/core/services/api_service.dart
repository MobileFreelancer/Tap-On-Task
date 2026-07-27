import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, [this.statusCode, this.errors]);

  @override
  String toString() => message;
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  void Function()? onUnauthorized;

  ApiService._internal() {
    _setupDio();
  }

  void _setupDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: ApiConfig.storageKeyAccessToken);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Generate cURL
          final curl = StringBuffer()..write('curl -X ${options.method}');

          options.headers.forEach((key, value) {
            curl.write(" -H '$key: $value'");
          });

          if (options.data != null) {
            if (options.data is FormData) {
              final formData = options.data as FormData;

              for (final field in formData.fields) {
                curl.write(" -F '${field.key}=${field.value}'");
              }

              for (final file in formData.files) {
                curl.write(" -F '${file.key}=@${file.value.filename}'");
              }
            } else {
              curl.write(" -d '${options.data}'");
            }
          }

          curl.write(" '${options.uri}'");

          developer.log(
            '\n========== API REQUEST ==========\n'
            '${curl.toString()}\n'
            '================================',
          );

          handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log(
            '\n========== API RESPONSE ==========\n'
            'URL: ${response.requestOptions.uri}\n'
            'Status: ${response.statusCode}\n'
            'Body: ${response.data}\n'
            '=================================',
          );

          final path = response.requestOptions.path;
          final isAuthRoute = path.contains('/customer-login') ||
              path.contains('/customer-register') ||
              path.contains('/verify-otp') ||
              path.contains('/forgot-password') ||
              path.contains('/resend-reset-otp') ||
              path.contains('/auth/login') ||
              path.contains('/auth/register') ||
              path.contains('/auth/social-login');
          if (response.statusCode == 401 && !isAuthRoute) {
            onUnauthorized?.call();
          }

          handler.next(response);
        },
        onError: (e, handler) {
          developer.log(
            '\n========== API ERROR ==========\n'
            'URL: ${e.requestOptions.uri}\n'
            'Status: ${e.response?.statusCode}\n'
            'Response: ${e.response?.data}\n'
            'Message: ${e.message}\n'
            '===============================',
          );

          final path = e.requestOptions.path;
          final isAuthRoute = path.contains('/customer-login') ||
              path.contains('/customer-register') ||
              path.contains('/verify-otp') ||
              path.contains('/forgot-password') ||
              path.contains('/resend-reset-otp') ||
              path.contains('/auth/login') ||
              path.contains('/auth/register') ||
              path.contains('/auth/social-login');
          if (e.response?.statusCode == 401 && !isAuthRoute) {
            onUnauthorized?.call();
          }

          handler.next(e);
        },
      ),
    );
  }

  String _ensureApiPath(String path) {
    if (path.startsWith('http')) return path;
    
    String cleanPath = path;
    // Remove /api/v1 prefix if present in the path to avoid duplication with baseUrl
    if (cleanPath.startsWith('/api/v1/')) {
      cleanPath = cleanPath.substring(8);
    } else if (cleanPath.startsWith('api/v1/')) {
      cleanPath = cleanPath.substring(7);
    }
    
    // Remove leading slash to ensure it appends to baseUrl correctly
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }
    
    return cleanPath;
  }

  ApiException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] as String?;
    final errors = e.response?.data?['errors'] as Map<String, dynamic>?;

    return ApiException(
      message ?? 'Something went wrong. Please try again.',
      statusCode,
      errors,
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(_ensureApiPath(path), queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data, bool isFormData = false}) async {
    try {
      dynamic payload = data;
      if (isFormData && data is Map<String, dynamic>) {
        payload = FormData.fromMap(data);
      }
      return await _dio.post(_ensureApiPath(path), data: payload);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ----- Auth Endpoints -----
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final response = await post('/customer-login', data: {
      'email': email,
      'password': password,
    }, isFormData: true);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await post('/customer-register', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
    }, isFormData: true);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp}) async {
    final response = await post('/verify-otp', data: {
      'email': email,
      'otp': otp,
    }, isFormData: true);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> forgotPassword(String emailOrPhone) async {
    final response = await post('/forgot-password', data: {
      'email_or_phone': emailOrPhone,
    }, isFormData: true);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> resendResetOtp(String emailOrPhone) async {
    final response = await post('/resend-reset-otp', data: {
      'email_or_phone': emailOrPhone,
    }, isFormData: true);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await get('/profile');
    return response.data as Map<String, dynamic>;
  }

  // ----- Task Endpoints -----
  Future<List<dynamic>> getTasks({String? category, String? status}) async {
    final params = <String, dynamic>{};
    if (category != null) params['category'] = category;
    if (status != null) params['status'] = status;
    final response = await get('/tasks', queryParams: params);
    return response.data['tasks'] as List<dynamic>? ?? [];
  }

  Future<Map<String, dynamic>> getTaskById(String taskId) async {
    final response = await get('/tasks/$taskId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskData) async {
    final response = await post('/tasks', data: taskData);
    return response.data as Map<String, dynamic>;
  }

  Future<void> placeBid(String taskId, double amount, {String? message}) async {
    await post('/tasks/$taskId/bid', data: {
      'amount': amount,
      'message': message,
    });
  }

  Future<void> acceptBid(String taskId, String bidId) async {
    await post('/tasks/$taskId/accept-bid', data: {'bidId': bidId});
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    await patch('/tasks/$taskId', data: {'status': status});
  }

  Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.patch(_ensureApiPath(path), data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
