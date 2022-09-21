import 'package:flutter/material.dart';
import 'components/signup_firebase.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: RegisterScreen(),
      ),
    );
  }
}
