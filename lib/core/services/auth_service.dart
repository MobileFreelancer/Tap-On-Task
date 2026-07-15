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

  bool get _useFirebaseAuth => _firebaseReady && ApiConfig.useFirebaseAuth;

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
    if (firebaseUser == null && _currentUser != null) {
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin() async {
    _setLoading(true);
    try {
      if (_firebaseReady) {
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser != null) {
          await _loadUserFromFirebase(firebaseUser);
          _setLoading(false);
          return _currentUser != null;
        }
      }

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

      final userData = await _api.getProfile();
      _currentUser = UserModel.fromJson(userData);
      _setLoading(false);
      return true;
    } catch (e) {
      await _clearStoredData();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login({
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      if (_useFirebaseAuth && phone.contains('@')) {
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: phone.trim(),
          password: password,
        );
        return await _handleFirebaseUser(credential.user, role);
      }

      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        _currentUser = role == UserRole.trader ? MockData.defaultTrader : MockData.defaultCustomer;
        await _storeAuthData(
          accessToken: 'mock_access_token',
          refreshToken: 'mock_refresh_token',
          userId: _currentUser!.id,
          role: role.name,
        );
        _setLoading(false);
        return true;
      }

      final response = await _api.login(phone: phone, password: password);
      await _storeAuthData(
        accessToken: response['accessToken'] as String,
        refreshToken: response['refreshToken'] as String,
        userId: response['user']['id'] as String,
        role: role.name,
      );
      _currentUser = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
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

  Future<bool> signup({
    required String phone,
    required String password,
    required UserRole role,
    String? name,
    String? email,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      if (_useFirebaseAuth && email != null && email.contains('@')) {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        if (name != null && name.isNotEmpty) {
          await credential.user?.updateDisplayName(name);
        }
        return await _handleFirebaseUser(credential.user, role, name: name, phone: phone);
      }

      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        _currentUser = role == UserRole.trader ? MockData.defaultTrader : MockData.defaultCustomer;
        if (name != null) _currentUser = _currentUser!.copyWith(name: name);
        if (email != null) _currentUser = _currentUser!.copyWith(email: email);
        await _storeAuthData(
          accessToken: 'mock_access_token',
          refreshToken: 'mock_refresh_token',
          userId: _currentUser!.id,
          role: role.name,
        );
        _setLoading(false);
        return true;
      }

      final response = await _api.signup(phone: phone, password: password, role: role.name);
      await _storeAuthData(
        accessToken: response['accessToken'] as String,
        refreshToken: response['refreshToken'] as String,
        userId: response['user']['id'] as String,
        role: role.name,
      );
      _currentUser = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
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

  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      if (_firebaseReady) {
        await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
        _setLoading(false);
        return true;
      }

      if (ApiConfig.useMock) {
        await Future.delayed(const Duration(seconds: 1));
        _setLoading(false);
        return true;
      }

      _setError('Password reset is unavailable.');
      _setLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to send reset email.');
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

  Future<bool> verifyOtp({required String phone, required String otp}) async {
    _setLoading(true);
    _setError(null);
    try {
      if (ApiConfig.useMock || !_firebaseReady) {
        await Future.delayed(const Duration(seconds: 1));
        _setLoading(false);
        return true;
      }
      await _api.verifyOtp(phone: phone, otp: otp);
      _setLoading(false);
      return true;
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

  Future<void> logout() async {
    _setLoading(true);
    try {
      if (!ApiConfig.useMock) await _api.logout();
      await _googleSignIn.signOut();
      if (_firebaseReady) await _firebaseAuth.signOut();
    } catch (_) {
    } finally {
      await _clearStoredData();
      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    }
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
    await _storage.delete(key: ApiConfig.storageKeyAccessToken);
    await _storage.delete(key: ApiConfig.storageKeyRefreshToken);
    await _storage.delete(key: ApiConfig.storageKeyUserID);
    await _storage.delete(key: ApiConfig.storageKeyUserRole);
    await _storage.delete(key: ApiConfig.storageKeyIsLoggedIn);
  }
}
