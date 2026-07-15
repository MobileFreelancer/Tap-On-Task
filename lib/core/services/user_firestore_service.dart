import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserFirestoreService {
  UserFirestoreService._();
  static final UserFirestoreService instance = UserFirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const _collection = 'users';

  Future<void> saveUser(UserModel user) async {
    await _db.collection(_collection).doc(user.id).set({
      ...user.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection(_collection).doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> updateUserRole(String uid, UserRole role) async {
    await _db.collection(_collection).doc(uid).update({'role': role.name});
  }
}
