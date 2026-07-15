import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final int? retryAfter;

  ApiException(this.message, [this.statusCode, this.retryAfter]);

  @override
  String toString() => message;
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
          'Content-Type': 'application/json',
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
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              final retryResponse = await _retryRequest(error.requestOptions);
              handler.resolve(retryResponse);
              return;
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken =
          await _storage.read(key: ApiConfig.storageKeyRefreshToken);
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${ApiConfig.baseUrl}/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;
        await _storage.write(
            key: ApiConfig.storageKeyAccessToken, value: newAccessToken);
        await _storage.write(
            key: ApiConfig.storageKeyRefreshToken, value: newRefreshToken);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token =
        await _storage.read(key: ApiConfig.storageKeyAccessToken);
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
    );
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  String _ensureApiPath(String path) {
    if (path.startsWith('/api/')) return path;
    if (path.startsWith('/')) return '/api$path';
    return '/api/$path';
  }

  ApiException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] as String?;

    switch (statusCode) {
      case 400:
        return ApiException('Invalid request. Please check your input.', 400);
      case 401:
        return ApiException('Invalid credentials. Please try again.', 401);
      case 403:
        if (message?.toLowerCase().contains('token') ?? false) {
          return ApiException('Session expired. Please login again.', 403);
        }
        return ApiException('Access denied.', 403);
      case 404:
        return ApiException('Service not found.', 404);
      case 429:
        final retryAfter = _parseRetryAfter(e);
        return ApiException(
          'Too many requests. Try again in ${_formatRetryAfter(retryAfter)}.',
          429,
          retryAfter,
        );
      case 500:
        return ApiException(
          message ?? 'Server error. Please try again later.',
          500,
        );
      default:
        break;
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('Connection timed out. Please check your internet.', null);
      case DioExceptionType.receiveTimeout:
        return ApiException('Server is taking too long to respond.', null);
      case DioExceptionType.connectionError:
        return ApiException('No internet connection. Please try again.', null);
      default:
        return ApiException(
          message ?? 'Something went wrong. Please try again.',
          statusCode,
        );
    }
  }

  int _parseRetryAfter(DioException e) {
    final bodyRetryAfter = e.response?.data?['retryAfter'] as int?;
    if (bodyRetryAfter != null) return bodyRetryAfter;
    final headerRetryAfter = e.response?.headers.value('Retry-After');
    if (headerRetryAfter != null) {
      final parsed = int.tryParse(headerRetryAfter);
      if (parsed != null) return parsed;
    }
    return 60;
  }

  String _formatRetryAfter(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes == 0) return '$remainingSeconds seconds';
    if (remainingSeconds == 0) return '$minutes minutes';
    return '$minutes minutes and $remainingSeconds seconds';
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(_ensureApiPath(path), queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(_ensureApiPath(path), data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(_ensureApiPath(path), data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.patch(_ensureApiPath(path), data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(_ensureApiPath(path));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> uploadFile(String path, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      return await _dio.post(_ensureApiPath(path), data: formData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ----- Auth Endpoints -----
  Future<Map<String, dynamic>> login({required String phone, required String password}) async {
    final response = await post('/auth/login', data: {
      'phone': phone,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> signup({required String phone, required String password, required String role}) async {
    final response = await post('/auth/signup', data: {
      'phone': phone,
      'password': password,
      'role': role,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyOtp({required String phone, required String otp}) async {
    final response = await post('/auth/verify-otp', data: {
      'phone': phone,
      'otp': otp,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    try {
      await post('/auth/logout');
    } catch (_) {}
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await get('/users/me');
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

  Future<void> rateTrader(String taskId, double rating, {String? review}) async {
    await post('/tasks/$taskId/rate', data: {
      'rating': rating,
      'review': review,
    });
  }
}
