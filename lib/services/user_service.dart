import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static Future<String?> fetchUserEmail(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['email'] as String?;
  }

  static Future<String?> fetchUserName(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['name'] as String?;
  }
}