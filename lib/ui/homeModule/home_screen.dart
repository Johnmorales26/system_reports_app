import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/homeModule/home_view_model.dart';
import 'package:system_reports_app/ui/signInModule/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String route = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('System Reports'),
        actions: [
          IconButton(
              onPressed: () {
                provider.signOut();
                Navigator.pushReplacementNamed(context, SignInScreen.route);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: const Text('HomeScreen'),
    );
  }
}
