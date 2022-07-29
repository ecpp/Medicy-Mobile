import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/routes.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_app/screens/sign_in/components/login_firebase.dart';

import 'helper/database_manager.dart';

bool loginStatus = false;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCuACDkvOC-qWxYd98Yl76Zp4MLYKs_P0E",
        authDomain: "e-commerce-app-267bd.firebaseapp.com",
        projectId: "e-commerce-app-267bd",
        storageBucket: "e-commerce-app-267bd.appspot.com",
        messagingSenderId: "968644185212",
        appId: "1:968644185212:web:1b901fc5194f7f4a4b4df9",
        measurementId: "G-8DVGVD7XS9"),
  );

  var userPass = prefs.getString("userPassword");
  var userEmail = prefs.getString("userEmail");
  print('test');

  runApp(FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          LoginScreen.loginEmailPassword(
              email: userEmail!, password: userPass!, context: context);

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme(),
              routes: routes,
              home: SplashScreen());
        } else {
          return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Center(
                child: CircularProgressIndicator(),
              ));
        }
      }));
}
