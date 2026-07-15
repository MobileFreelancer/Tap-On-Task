import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;
  String? _initError;

  bool get isInitialized => _isInitialized;
  String? get initError => _initError;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _isInitialized = true;
      _initError = null;
      if (kDebugMode) {
        debugPrint('Firebase initialized: ${DefaultFirebaseOptions.currentPlatform.projectId}');
      }
      return true;
    } catch (e) {
      _initError = e.toString();
      if (kDebugMode) {
        debugPrint('Firebase initialization failed: $e');
      }
      return false;
    }
  }
}
