import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:system_reports_app/ui/appModule/app.dart';
import 'package:system_reports_app/ui/homeModule/home_view_model.dart';
import 'package:system_reports_app/ui/registerModule/sign_up_view_model.dart';
import 'firebase_options.dart';
import 'package:system_reports_app/ui/signInModule/sign_in_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignInViewModel()),
      ChangeNotifierProvider(create: (_) => SignUpViewModel()),
      ChangeNotifierProvider(create: (_) => HomeViewModel())
    ],
    child: const App()
  ));
}