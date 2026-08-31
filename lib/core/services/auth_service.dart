import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import '../../firebase_options.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'firebase_service.dart';
import 'mock_data.dart';
import 'user_firestore_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiService _api = ApiService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserFirestoreService _userFirestore = UserFirestoreService.instance;

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS ? DefaultFirebaseOptions.ios.iosClientId : null,
  );

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _firebaseReady = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCustomer => _currentUser?.role == UserRole.customer;
  bool get isTrader => _currentUser?.role == UserRole.trader;
  bool get firebaseReady => _firebaseReady;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? v) {
    _error = v;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> initializeFirebase() async {
    _firebaseReady = await FirebaseService.instance.initialize();
    if (_firebaseReady) {
      _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await _loadUserFromFirebase(firebaseUser);
      }
    }
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null && _currentUser != null && ApiConfig.useFirebaseAuth) {
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserFromFirebase(User firebaseUser) async {
    try {
      final storedUser = await _userFirestore.getUser(firebaseUser.uid);
      final roleStr = await _storage.read(key: ApiConfig.storageKeyUserRole);
      final role = storedUser?.role ??
          (roleStr == 'trader' ? UserRole.trader : UserRole.customer);

      _currentUser = UserModel(
        id: firebaseUser.uid,
        phoneNumber: storedUser?.phoneNumber ?? firebaseUser.phoneNumber ?? '',
        name: firebaseUser.displayName ?? storedUser?.name ?? 'User',
        email: firebaseUser.email ?? storedUser?.email,
        role: role,
        avatarUrl: firebaseUser.photoURL ?? storedUser?.avatarUrl,
        isVerified: firebaseUser.emailVerified,
        rating: storedUser?.rating ?? 0,
        taskCount: storedUser?.taskCount ?? 0,
        completedTasks: storedUser?.completedTasks ?? 0,
      );
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> signInWithGoogle({UserRole? role}) async {
    if (!_firebaseReady) {
      _setError('Firebase is not initialized. Please restart the app.');
      return false;
    }

    _setLoading(true);
    _setError(null);
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return await _handleFirebaseUser(userCredential.user, role ?? UserRole.customer);
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Google sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithApple({UserRole? role}) async {
    if (Platform.isAndroid) {
      _setError('Apple Sign-In is not available on Android.');
      return false;
    }

    if (!_firebaseReady) {
      _setError('Firebase is not initialized. Please restart the app.');
      return false;
    }

    _setLoading(true);
    _setError(null);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      String? displayName;
      if (appleCredential.givenName != null) {
        displayName = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();
        if (displayName.isNotEmpty) {
          await userCredential.user?.updateDisplayName(displayName);
        }
      }

      return await _handleFirebaseUser(
        userCredential.user,
        role ?? UserRole.customer,
        name: displayName,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled) {
        _setError('Apple sign-in failed.');
      }
      _setLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Apple sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> _handleFirebaseUser(
    User? firebaseUser,
    UserRole role, {
    String? name,
    String? phone,
  }) async {
    if (firebaseUser == null) {
      _setError('Authentication failed.');
      _setLoading(false);
      return false;
    }

    final token = await firebaseUser.getIdToken();

    UserModel? storedUser;
    try {
      storedUser = await _userFirestore.getUser(firebaseUser.uid);
    } catch (_) {}

    final resolvedRole = storedUser?.role ?? role;

    _currentUser = UserModel(
      id: firebaseUser.uid,
      phoneNumber: phone ?? storedUser?.phoneNumber ?? firebaseUser.phoneNumber ?? '',
      name: name ?? firebaseUser.displayName ?? storedUser?.name ?? 'User',
      email: firebaseUser.email ?? storedUser?.email,
      role: resolvedRole,
      avatarUrl: firebaseUser.photoURL ?? storedUser?.avatarUrl,
      isVerified: firebaseUser.emailVerified,
    );

    try {
      await _userFirestore.saveUser(_currentUser!);
    } catch (_) {}

    await _storeAuthData(
      accessToken: token ?? 'firebase_token',
      refreshToken: 'firebase_refresh',
      userId: firebaseUser.uid,
      role: resolvedRole.name,
    );

    _setLoading(false);
    notifyListeners();
    return true;
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  Future<bool> tryAutoLogin() async {
    _setLoading(true);
    try {
      final token = await _storage.read(key: ApiConfig.storageKeyAccessToken);
      if (token == null || token.isEmpty) {
        _setLoading(false);
        return false;
      }

      if (ApiConfig.useMock) {
        final roleStr = await _storage.read(key: ApiConfig.storageKeyUserRole);
        _currentUser = roleStr == 'trader' ? MockData.defaultTrader : MockData.defaultCustomer;
        _setLoading(false);
        return true;
      }

      final response = await _api.getProfile();
      if (response['status'] == 'success') {
        _currentUser = UserModel.fromJson(response['data'] as Map<String, dynamic>);
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      await _clearStoredData();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {

      final response = await _api.login(email: email, password: password);
      if (response['status'] == 'success') {
        final data = response['data'] as Map<String, dynamic>;
        await _storeAuthData(
          accessToken: data['token'] as String,
          refreshToken: '',
          userId: data['id'].toString(),
          role: data['role'] as String? ?? 'customer',
        );
        _currentUser = UserModel.fromJson(data);
        _setLoading(false);
        return true;
      }
      _setError(response['message'] as String? ?? 'Login failed');
      _setLoading(false);
      return false;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Something went wrong. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<String?> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        _setLoading(false);
        return "123456"; // Mock OTP
      }

      final response = await _api.signup(name: name, email: email, phone: phone, password: password);
      if (response['status'] == 'success') {
        _setLoading(false);
        return response['data']['otp'].toString();
      }
      _setError(response['message'] as String? ?? 'Registration failed');
      _setLoading(false);
      return null;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return null;
    } catch (e) {
      _setError('Something went wrong. Please try again.');
      _setLoading(false);
      return null;
    }
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        _currentUser = MockData.defaultCustomer;
        _setLoading(false);
        return true;
      }
      final response = await _api.verifyOtp(email: email, otp: otp);
      if (response['status'] == 'success') {
        final data = response['data'] as Map<String, dynamic>;
        await _storeAuthData(
          accessToken: data['token'] as String,
          refreshToken: '',
          userId: data['id'].toString(),
          role: data['role'] as String? ?? 'customer',
        );
        _currentUser = UserModel.fromJson(data);
        _setLoading(false);
        return true;
      }
      _setError(response['message'] as String? ?? 'Verification failed');
      _setLoading(false);
      return false;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Something went wrong. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<String?> forgotPassword(String emailOrPhone) async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        _setLoading(false);
        return "654321";
      }
      final response = await _api.forgotPassword(emailOrPhone);
      if (response['status'] == 'success') {
        _setLoading(false);
        return response['data']['otp'].toString();
      }
      _setError(response['message'] as String? ?? 'Failed to send OTP');
      _setLoading(false);
      return null;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return null;
    } catch (e) {
      _setError('Something went wrong.');
      _setLoading(false);
      return null;
    }
  }

  Future<String?> resendResetOtp(String emailOrPhone) async {
    _setError(null);
    try {
      final response = await _api.resendResetOtp(emailOrPhone);
      if (response['status'] == 'success') {
        return response['data']['otp'].toString();
      }
      _setError(response['message'] as String? ?? 'Failed to resend OTP');
      return null;
    } on ApiException catch (e) {
      _setError(e.message);
      return null;
    } catch (e) {
      _setError('Something went wrong.');
      return null;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _storage.deleteAll();
      _currentUser = null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> _storeAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String role,
  }) async {
    await _storage.write(key: ApiConfig.storageKeyAccessToken, value: accessToken);
    await _storage.write(key: ApiConfig.storageKeyRefreshToken, value: refreshToken);
    await _storage.write(key: ApiConfig.storageKeyUserID, value: userId);
    await _storage.write(key: ApiConfig.storageKeyUserRole, value: role);
    await _storage.write(key: ApiConfig.storageKeyIsLoggedIn, value: 'true');
  }

  Future<void> _clearStoredData() async {
    await _storage.deleteAll();
  }
}
