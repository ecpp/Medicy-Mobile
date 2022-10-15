import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/routes.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_app/screens/sign_in/components/login_firebase.dart';

import 'helper/database_manager.dart';

bool loginStatus = false;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final Future<FirebaseApp> _initialization;
  if (kIsWeb) { // if web
    _initialization = Firebase.initializeApp(
      name: 'Medicy',
      options: FirebaseOptions(
          apiKey: "AIzaSyDg9arn7gwhQP-WouWkl-XEjhF8mZIr0AU",
          authDomain: "medicy-a063d.firebaseapp.com",
          projectId: "medicy-a063d",
          storageBucket: "medicy-a063d.appspot.com",
          messagingSenderId: "682478441420",
          appId: "1:682478441420:web:921a72c6935afee0c30369",
          measurementId: "G-NSYB6K7E0E"),
    );
  }
  else{
    _initialization = Firebase.initializeApp();
  }



  var userPass = prefs.getString("userPassword");
  var userEmail = prefs.getString("userEmail");

  runApp(FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        print("state: ${snapshot.connectionState}");
        print("error: ${snapshot.error}");
        print("data: ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError && snapshot.hasData) {
          if (userPass != null && userEmail != null) {
            LoginScreen.loginEmailPassword(
                email: userEmail, password: userPass, context: context, autoLogin: true);
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme(),
              routes: routes,
              home: HomeScreen());
        } else {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          );
        }
      }));
}
