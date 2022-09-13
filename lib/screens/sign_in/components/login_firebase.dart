import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/screens/home/components/body.dart';
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

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("CAN'T LOGIN!"),
              content: Text(loginError),
            );
          });
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
                      buildCustomButton(),
                      SizedBox(
                        height: 40,
                      ),
                      registerButton(),
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

  ElevatedButton submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )),
      onPressed: () async {

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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Sign In Success!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: kPrimaryColor,
          ));
        }
      },
      child: Text(
        "  Login  ",
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Loading",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Login Failed",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: Colors.grey.shade400,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.red.shade300,
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
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Sign In Success!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: kPrimaryColor,
          ));
        }
        else{
          setState(() {
            stateOnlyText = ButtonState.fail;
          });
          await Future.delayed(Duration(seconds: 2));
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

  ElevatedButton registerButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )),
      onPressed: () {
        // _formKey.currentState!.validate();
        Navigator.pushNamed(context, SignUpScreen.routeName);
      },
      child: Text(
        "Register",
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
