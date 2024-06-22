import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/homeModule/home_screen.dart';
import 'package:system_reports_app/ui/signInModule/sign_in_view_model.dart';
import 'package:system_reports_app/ui/registerModule/sign_up_screen.dart';

import '../style/dimens.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const String route = '/SignInScreen';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignInViewModel>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: double.infinity,
                child: Card.outlined(
                  child: Container(
                    padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
                    child: Column(
                      children: [
                        Text('Sign In',
                            style: Theme.of(context).textTheme.headlineLarge),
                        Text(
                            'Enter your email and password to access your account.',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: Dimens.commonPaddingExtraLarge),
                        _Form(),
                        const SizedBox(height: Dimens.commonPaddingDefault),
                        SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                                onPressed: () async {
                                  var response = await provider
                                      .signInWithEmailAndPassword();
                                  if (response == HomeScreen.route) {
                                    Navigator.pushReplacementNamed(
                                        context, response);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: response,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white);
                                  }
                                },
                                child: const Text('Sign In'))),
                        const SizedBox(height: Dimens.commonPaddingDefault),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('You do not have an account?'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, SignUpScreen.route);
                                  },
                                  child: const Text('Sign up'))
                            ])
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  SignInViewModel? provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInViewModel>(context);
    return Column(
      children: [
        TextField(
            controller: provider?.emailController,
            decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey[200]),
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: Dimens.commonPaddingDefault),
        TextField(
          controller: provider?.passwordController,
          decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () => provider?.changePassword(),
                child: Icon(provider!.isVisiblePassword
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
              filled: true,
              fillColor: Colors.grey[200]),
          obscureText: provider!.isVisiblePassword,
        )
      ],
    );
  }

  @override
  void dispose() {
    provider?.dispose();
    super.dispose();
  }
}
