import 'package:flutter_dotenv/flutter_dotenv.dart';

enum DataSourceType { mock, api, firebase }

enum Environment { development, staging, production }

class ApiConfig {
  static DataSourceType get dataSourceType {
    const value = String.fromEnvironment('DATA_SOURCE', defaultValue: 'api');
    if (value == 'mock') return DataSourceType.mock;
    if (value == 'firebase') return DataSourceType.firebase;
    return DataSourceType.api;
  }

  static bool get useFirebase => dataSourceType == DataSourceType.firebase;
  static bool get useApi => dataSourceType == DataSourceType.api;
  static bool get useMock => dataSourceType == DataSourceType.mock;

  /// When true, email/password auth uses Firebase instead of mock/API.
  static bool get useFirebaseAuth => !useMock && !useApi; // Disable firebase auth when using custom API

  static String get baseUrl {
    String url;
    const dartDefine = String.fromEnvironment('BASE_URL');
    if (dartDefine.isNotEmpty) {
      url = dartDefine;
    } else {
      url = dotenv.env['BASE_URL'] ?? 'https://tot.nkm.mjm.mybluehost.me';
    }
    
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return '$url/api/v1/';
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

  static String get stripePublishableKey {
    const dartDefine = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
    if (dartDefine.isNotEmpty) return dartDefine;
    return dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  }

  /// Temporary client-side secret for PaymentIntent creation until backend
  /// exposes a create-intent endpoint. Do not ship production builds with this.
  static String get stripeSecretKey {
    const dartDefine = String.fromEnvironment('STRIPE_SECRET_KEY');
    if (dartDefine.isNotEmpty) return dartDefine;
    return dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  }

  static const String storageKeyAccessToken = 'access_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUserID = 'user_id';
  static const String storageKeyUserRole = 'user_role';
  static const String storageKeyIsLoggedIn = 'is_logged_in';
}
