import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:system_reports_app/data/local/UserDatabase.dart';

class FirebaseDatabase {
  final db = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserDatabase user) async {
    try {
      await db.collection('users').doc(user.uid).set(user.toJson());
      return true;
    } catch (error) {
      print('Error registering user: $error');
      return false;
    }
  }
}