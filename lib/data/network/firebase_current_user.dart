import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:system_reports_app/data/local/UserDatabase.dart';

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
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    docRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data() != null) {
          _userDatabase = UserDatabase.fromJson(snapshot.data()!);
          print('User data fetched successfully: $_userDatabase'); // Mensaje de éxito
        } else {
          _userDatabase = null;
          print('Snapshot data is null'); // Mensaje si snapshot.data() es null
        }
      } else {
        _userDatabase = null;
        print('Document does not exist'); // Mensaje si el documento no existe
      }
    });
  }

  UserDatabase? get currentUser => _userDatabase;
}
