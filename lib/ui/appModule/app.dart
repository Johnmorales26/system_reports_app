import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/reportModule/report_screen.dart';
import 'package:system_reports_app/ui/sliderModule/slider_screen.dart';

import '../homeModule/home_screen.dart';
import '../signInModule/sign_in_screen.dart';
import '../registerModule/sign_up_screen.dart';
import '../style/text.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Manrope", "Sora");
    //MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
        title: 'System Reports',
        debugShowCheckedModeBanner: false,
        initialRoute: _authenticationVerification(),
        //theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        routes: {
          SliderScreen.route: (context) => SliderScreen(),
          SignInScreen.route: (context) => const SignInScreen(),
          SignUpScreen.route: (context) => const SignUpScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          ReportScreen.route: (context) => const ReportScreen()
        });
  }

  String _authenticationVerification() {
    if (FirebaseAuth.instance.currentUser != null) {
      return HomeScreen.route;
    } else {
      return SliderScreen.route;
    }
  }
}
