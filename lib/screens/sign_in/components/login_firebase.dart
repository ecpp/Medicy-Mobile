import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';
import 'package:shop_app/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import '../../../helper/database_manager.dart';
import '../../../main.dart';
import '../../../models/Product.dart';
import '../../home/home_screen.dart';

User? user;
String? userEmail, userFirstName, userSurname, userPassword;
String userType = "customer";
Map<String, dynamic>? userCart;
UserData newUser = UserData();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static Future<User?> loginEmailPassword(
      {required String email,
        required String password,
        required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String loginError;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      loginStatus = true;
      final prefs = await SharedPreferences.getInstance();
      userEmail = email;
      userPassword = password;
      prefs.setString("userEmail", email);
      prefs.setString("userPassword", password);
      prefs.setBool("isLoggedIn", true);
      print("Logged in successfully with" + email + "and password" + password);
    } on FirebaseAuthException catch (e) {
      loginError = e.message!;
      if (e.message == 'Given String is empty or null'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            loginError,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: kPrimaryColor,
        ));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            loginError,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: kPrimaryColor,
        ));
      }
      if (e.code == "user-not-found") {
        SnackBar(content: Text('Login error.'), duration: Duration(seconds: 3));
      }
    }
    return user;
  }
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ButtonState stateOnlyText = ButtonState.idle;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 25)),
                        Container(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 34, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 25)),
                        Container(
                          child: Text(
                            "Login to experience new ways",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      emailFormField(),
                      SizedBox(
                        height: 20,
                      ),
                      passwordFormField(),
                      SizedBox(
                        height: 40,
                      ),
                      loginButton(),
                      SizedBox(
                        height: 40,
                      ),
                      registerText(),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailFormField() {
    return TextField(
      decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          contentPadding:
              new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide.none),
          hintText: "Email",
          prefixIcon: Icon(Icons.alternate_email)),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
    );
  }

  Widget passwordFormField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        contentPadding:
            new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            borderSide: BorderSide.none),
        hintText: "Password",
        prefixIcon: Icon(Icons.lock_outline),
      ),
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
    );
  }

  Widget loginButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        ButtonState.loading: Text(
          "Loading",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        ButtonState.fail: Text(
          "Login Failed",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        ButtonState.success: Text(
          "Success",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        )
      },
      stateColors: {
        ButtonState.idle: kPrimaryColor,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.grey.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      progressIndicator:  CircularProgressIndicator( backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation(Colors.red), strokeWidth: 1, ),
      onPressed: () async{
        setState(() {
          stateOnlyText = ButtonState.loading;
        });
        String userEmail = _emailController.text;

        newUser.email = userEmail;
        userSurname = newUser.surname;
        user = await LoginScreen.loginEmailPassword(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );


        if (user != null) {
          await fetchAllUserDataOnLogin();
          setState(() {
            stateOnlyText = ButtonState.success;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileMain()),
                (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Welcome " + userFirstName! + " " + userSurname! + "!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 1),
            backgroundColor: kPrimaryColor,
          ));
        }
        else{
          setState(() {
            stateOnlyText = ButtonState.fail;
          });
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            stateOnlyText = ButtonState.idle;
          });
        }
      },
      state: stateOnlyText,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  RichText registerText(){
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'Don\'t have an account? ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        TextSpan(
            text: 'Register',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                PersistentNavBarNavigator.pushNewScreen(context, screen: SignUpScreen(), withNavBar: false);
              }),
      ]),
    );
  }

}
