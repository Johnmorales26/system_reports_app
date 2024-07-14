import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/utils/constants.dart';

class FirebaseCurrentUser {

  UserDatabase? _userDatabase;
  static final FirebaseCurrentUser _instance = FirebaseCurrentUser._internal();

  factory FirebaseCurrentUser() {
    return _instance;
  }

  FirebaseCurrentUser._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _fetchCurrentUserByFirestore(user.uid);
      } else {
        _userDatabase = null;
      }
    });
  }

  void _fetchCurrentUserByFirestore(String uid) {
    final docRef = FirebaseFirestore.instance.collection(Constants.COLLECTION_USERS).doc(uid);
    docRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data() != null) {
          _userDatabase = UserDatabase.fromJson(snapshot.data()!);
        } else {
          _userDatabase = null;
        }
      } else {
        _userDatabase = null;
      }
    });
  }

  UserDatabase? get currentUser => _userDatabase;
}
