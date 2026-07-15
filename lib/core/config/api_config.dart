import 'package:flutter_dotenv/flutter_dotenv.dart';

enum DataSourceType { mock, api, firebase }

enum Environment { development, staging, production }

class ApiConfig {
  static DataSourceType get dataSourceType {
    const value = String.fromEnvironment('DATA_SOURCE');
    if (value == 'api') return DataSourceType.api;
    if (value == 'firebase') return DataSourceType.firebase;
    return DataSourceType.mock;
  }

  static bool get useFirebase => dataSourceType == DataSourceType.firebase;
  static bool get useApi => dataSourceType == DataSourceType.api;
  static bool get useMock => dataSourceType == DataSourceType.mock;

  /// When true, email/password auth uses Firebase instead of mock/API.
  static bool get useFirebaseAuth => !useMock;

  static String get baseUrl {
    const dartDefine = String.fromEnvironment('BASE_URL');
    if (dartDefine.isNotEmpty) return dartDefine;
    final envVal = dotenv.env['BASE_URL'];
    if (envVal != null && envVal.isNotEmpty) return envVal;
    return 'https://api.tapontask.com';
  }

  static Environment get currentEnvironment {
    const value = String.fromEnvironment('ENVIRONMENT');
    if (value == 'production') return Environment.production;
    if (value == 'staging') return Environment.staging;
    return Environment.development;
  }

  static bool get isDevelopment => currentEnvironment == Environment.development;
  static bool get isProduction => currentEnvironment == Environment.production;

  static const Duration connectTimeout = Duration(seconds: 40);
  static const Duration receiveTimeout = Duration(seconds: 40);

  static const String storageKeyAccessToken = 'access_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUserID = 'user_id';
  static const String storageKeyUserRole = 'user_role';
  static const String storageKeyIsLoggedIn = 'is_logged_in';
}
