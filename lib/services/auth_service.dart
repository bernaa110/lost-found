import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password, String name) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    await _users.doc(cred.user!.uid).set({
      'email': email,
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
    });
    await cred.user!.updateDisplayName(name);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}