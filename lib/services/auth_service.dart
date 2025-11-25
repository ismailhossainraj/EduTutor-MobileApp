import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user with email and password, then save user info to Firestore
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? gender,
    required UserRole role,
    // Student specific fields
    String? schoolName,
    String? classLevel,
    // Teacher specific fields
    String? college,
    String? educationLevel,
    String? university,
    String? interest,
    String? phoneNumber,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        UserModel userModel = UserModel(
          uid: user.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          role: role,
          createdAt: DateTime.now(),
          // Student fields
          schoolName: schoolName,
          classLevel: classLevel,
          // Teacher fields
          college: college,
          educationLevel: educationLevel,
          university: university,
          interest: interest,
          phoneNumber: phoneNumber,
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Login user with email and password
  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // Get user info from Firestore
  Future<UserModel?> getUserInfo(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
