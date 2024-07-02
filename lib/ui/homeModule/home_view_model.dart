import 'package:flutter/cupertino.dart';
import 'package:system_reports_app/data/local/UserDatabase.dart';
import 'package:system_reports_app/data/network/firebase_current_user.dart';

import '../../data/network/firebase_authentication.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseAuthentication _auth = FirebaseAuthentication();
  final FirebaseCurrentUser currentUser = FirebaseCurrentUser();

  Future<UserDatabase?> getCurrentUserByFirestore() {
    // Simular una carga o proceso con un delay de 2 segundos
    return Future.delayed(const Duration(milliseconds: 5000), () {
      return currentUser.currentUser;
    });
  }

  void signOut() {
    _auth.signOut();
  }

}