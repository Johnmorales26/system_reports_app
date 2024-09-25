import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:system_reports_app/data/network/firebase_current_user.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';

class ProfileRepository {

  FirebaseCurrentUser auth = FirebaseCurrentUser();
  FirebaseDatabase db = FirebaseDatabase();

  User? fetchCurrentUser() {
    return auth.fetchCurrentUserByFirebase();
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile) {
    return db.uploadImageToFirebaseStorage(imageFile);
  }

}