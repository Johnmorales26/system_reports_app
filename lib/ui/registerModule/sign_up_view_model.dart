import 'package:flutter/material.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/ui/registerModule/user_privileges.dart';

import '../../data/network/firebase_authentication.dart';

class SignUpViewModel extends ChangeNotifier {
  final FirebaseAuthentication _auth = FirebaseAuthentication();

  bool isVisiblePassword = true;
  bool isVisibleConfirmPassword = true;
  UserPrivileges userPrivileges = UserPrivileges.user;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<String> signUpWithEmailAndPassword() async {
    final name = nameController.text.toString().trim();
    final email = emailController.text.toString().trim();
    final password = passwordController.text.toString().trim();
    final confirmPassword = confirmPasswordController.text.toString().trim();
    print(userPrivileges.name.toString());
    if (name.isEmpty) {
      return 'Name cannot be empty';
    }
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
    UserDatabase user = UserDatabase(null, name, email, userPrivileges);
    return _auth.signUpWithEmailAndPassword(user, password);
  }

  void changePrivileges(UserPrivileges privileges) {
    userPrivileges = privileges;
    notifyListeners();
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
