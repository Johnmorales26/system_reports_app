import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';

class SignInViewModel extends ChangeNotifier {
  final FirebaseDatabase _auth = FirebaseDatabase();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisiblePassword = true;

  Future<String> signInWithEmailAndPassword() async {
    if (emailController.text.toString().trim().isEmpty) {
      return 'Email cannot be empty';
    }
    if (passwordController.text.toString().trim().isEmpty) {
      return 'Password cannot be empty';
    }
    return _auth.signInWithEmailAndPassword(
        emailController.text.toString().trim(),
        passwordController.text.toString().trim());
  }

  void changePassword() {
    isVisiblePassword = !isVisiblePassword;
    notifyListeners();
  }

  void disposeTextFields() {
    emailController.dispose();
    passwordController.dispose();
  }
}
