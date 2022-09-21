import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import '../sign_in/components/login_firebase.dart';
import 'components/body.dart';
import 'package:shop_app/main.dart';

class ProfileMain extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    print(loginStatus);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: loginStatus ? Body() : SignInScreen(),
    );
  }
}
