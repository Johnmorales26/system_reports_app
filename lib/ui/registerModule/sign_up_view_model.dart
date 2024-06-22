import 'package:flutter/material.dart';

import '../../data/network/firebase_database.dart';

class SignUpViewModel extends ChangeNotifier {
  final FirebaseDatabase _auth = FirebaseDatabase();

  bool isVisiblePassword = true;
  bool isVisibleConfirmPassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<String> signUpWithEmailAndPassword() async {
    final email = emailController.text.toString().trim();
    final password = passwordController.text.toString().trim();
    final confirmPassword = confirmPasswordController.text.toString().trim();
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (confirmPassword.isEmpty) {
      return 'The passwords entered do not match. Please try again.';
    }
    if (password.isEmpty !=
        confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    return _auth.signUpWithEmailAndPassword(email, password);
  }

  void changeVisibilityPassword() {
    isVisiblePassword = !isVisiblePassword;
    notifyListeners();
  }

  void changeVisibilityConfirmPassword() {
    isVisibleConfirmPassword = !isVisibleConfirmPassword;
    notifyListeners();
  }

  void disposeTextFields() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
