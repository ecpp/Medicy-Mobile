import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/user_database.dart';
import '../../home/home_screen.dart';
import '../../sign_in/components/login_firebase.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //bool _value = false; Agreement check box icin belki sonra?

  final formkey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  static Future<User?> registerEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    String registerError;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      registerError = e.message!;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("CAN'T SIGN UP!"),
              content: Text(registerError),
            );
          });
    }
    CircularProgressIndicator();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
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
                            "Register",
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
                            "Signup to Medicy App.",
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
                      nameFormField(),
                      SizedBox(
                        height: 20,
                      ),
                      surnameFormField(),
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
                      submitBtton(),
                      SizedBox(
                        height: 10,
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
    return TextFormField(
      controller: _emailController,
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
    );
  }

  Widget nameFormField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          contentPadding:
              new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide.none),
          hintText: "Name",
          prefixIcon: Icon(Icons.person_outline)),
    );
  }

  Widget surnameFormField() {
    return TextFormField(
      controller: _surnameController,
      decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          contentPadding:
              new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide.none),
          hintText: "Surname",
          prefixIcon: Icon(Icons.person_outline)),
    );
  }

  // Widget phoneNumberFormField() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //       fillColor: Colors.grey.withOpacity(0.1),
  //       filled: true,
  //       contentPadding:
  //           new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(40)),
  //           borderSide: BorderSide.none),
  //       hintText: "Mobile No",
  //       prefixIcon: Icon(Icons.phone_outlined),
  //     ),
  //     keyboardType: TextInputType.number,
  //     validator: (String? value) {
  //       if (value![0] != "0") {
  //         return "Please enter valid mobile number";
  //       } else if (value.length != 10) {
  //         return "Mobile Number must be 10 digits";
  //       }
  //       return null;
  //     },
  //   );
  // }

  Widget passwordFormField() {
    return TextFormField(
      controller: _passwordController,
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
    );
  }

  ElevatedButton submitBtton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: kPrimaryColor,
        padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        // formkey.currentState!.validate();
        User? user = await registerEmailPassword(
            email: _emailController.text,
            password: _passwordController.text,
            context: context);
        createUsertoDB(_nameController.text, _surnameController.text,
            user!.email.toString(), user.uid);
        if (user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Register Success, Please Login',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: kPrimaryColor,
        ));
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

  // Widget agreementCheckBox() {
  //   return Row(
  //     children: <Widget>[
  //       Padding(padding: EdgeInsets.only(left: 15)),
  //       Checkbox(
  //         value: _value,
  //         onChanged: (newValue) {
  //           setState(() {
  //             _value = newValue!;
  //           });
  //         },
  //       ),
  //       Text(
  //         "I accept with the",
  //         style: TextStyle(color: Colors.grey),
  //       ),
  //       TextButton(
  //           onPressed: () {},
  //           child: Text(
  //             "Term & Conditions",
  //             style: TextStyle(color: Colors.black),
  //           )),
  //     ],
  //   );
  // }

}
